function [X,Y,blocksized,blocksizev] = findSamplingPoints_zone(im,borders,numpoints,hblocks,vblocks,filtlen,filtwid)
    %% First, clean up inputs - we accept either a struct or a 2x4 matrix.
    if size(borders,2) == 4
        borders = struct('xleft',borders(:,1),'xright',borders(:,2),...
                         'yleft',borders(:,3),'yright',borders(:,4));
    end
    if length(numpoints) == 1
        numpoints = [numpoints numpoints];
    end
    %% And check optional inputs
    if nargin < 5 || isempty(vblocks)
        vblocks = length(borders.xleft);
    end
    if nargin < 4 || isempty(hblocks)
        height = (sqrt((borders.xleft(end) -borders.xleft(1)   ).^2 ...
                      +(borders.yleft(end) -borders.yleft(1)   ).^2 ) ...
               +  sqrt((borders.xright(end)-borders.xright(1)  ).^2 ...
                      +(borders.yright(end)-borders.yright(1)  ).^2 ))/2;
        width  = (sqrt((borders.xleft(end) -borders.xright(end)).^2 ...
                      +(borders.yleft(end) -borders.yright(end)).^2 ) ...
               +  sqrt((borders.xleft(1)   -borders.xright(1)  ).^2 ...
                      +(borders.yleft(1)   -borders.yright(1)  ).^2 ))/2;
        hblocks = vblocks/height*width;
    end
    if nargin < 6 || isempty(filtlen)
        filtlen = 1024;
    end
    if nargin < 7 || isempty(filtwid)
        filtwid = 0.01;
    end
    %% Pre-compute block sizes for filters
    blocksizev = abs(mean(diff(borders.yleft)))/2 ...
               + abs(mean(diff(borders.yright)))/2;
            % Block size along camera axis - for pre-filtering
    blocksized = mean(sqrt(diff(borders.yleft).^2+diff(borders.xleft).^2))/2 ...
              + mean(sqrt(diff(borders.yright).^2+diff(borders.xright).^2))/2;
            % Block size along display axis - will need that for filters
            % one day
    %% Design filter for soft transitions between blocks, using parameters
    %  similar to conventional VLC filtering, then apply
    rcosfilter = rcosdesign(0.3,8,ceil(blocksizev/1.3),'normal');
    rcosfilter = rcosfilter/sum(rcosfilter);
    softpic = conv2(rcosfilter,rcosfilter,single(im),'same');
    %% Since we are never going to hit pixels exactly, we need a form of
    %  interpolation. Linear interpolation is not optimal, but fast, and we
    %  can use a large supersampling factor to make sure we hit our peaks.
    numlines = length(borders.xleft);
    xrows = zeros(numlines,numpoints(1));
    yrows = zeros(numlines,numpoints(1));
    for k=1:numlines
        xrows(k,:) = linspace(borders.xleft(k),borders.xright(k),numpoints(1));
        yrows(k,:) = linspace(borders.yleft(k),borders.yright(k),numpoints(1));
    end
    rowsample = interp2(softpic,xrows,yrows);
    %% Not every line has transitions everywhere, but we have now de-skewed
    %  all lines (this is why correct angles matter), and we are virtually
    %  guaranteed transitions if we sum up all the lines and use a filter
    %  to augment frequencies around the symbol rate. The optimum sampling
    %  point is in the spatial peaks.sprehwin = conv2(rowsample.^2,ones(20,1));
%     sprehwin = conv2(rowsample.^2,ones(21,1),'same');
    sprehwin = conv2(rowsample.^2,ones(41,1),'same');
    sfilt = fir1(filtlen,filtwid)...
          .*cos(2*pi*hblocks/numpoints(1)*(-filtlen/2:filtlen/2));
    signalhwin = conv2(sprehwin,sfilt,'same');
    Pphwin = cell(size(signalhwin,1),1);
    Pposwin = zeros(size(signalhwin));
    for k=1:size(signalhwin,1)
        %[~,Pphwin{k}] = findpeaks(double(signalhwin(k,:)),'minPeakDistance',10);
        d=diff(signalhwin(k,:));
        Pphwin{k}=find((sign(d(1:end-1))>0)&(sign(d(2:end))<0))+1;
        % Prevent peaks from registering twice in the presence of noise
        % NB: Maybe some post-processing to clean up any remaining mess of
        % spurious or missing peaks in the future
        Pposwin(k,Pphwin{k}) = 1;
    end
    poscount = sum(Pposwin.');
    numcols = round(median(poscount));
    pospoints = find(poscount==numcols).';
    posline = cell2mat(Pphwin(pospoints));
    x0 = zeros(1,numcols);
    c = zeros(1,numcols);
    for k=1:numcols
        f = polyfit(pospoints,posline(:,k),1);
        x0(k) = f(2);
        c(k) = f(1);
    end
    f = polyfit(x0.',c.',1);
    a = f(2);
    b = f(1);
    Ppht = a+x0+b*x0;
    Pphb = a*numlines+x0+b*numlines*x0;
    %% Now that we have optimum sampling points in the horizontal
    %  direction, we can determine the position of the sampling columns
    borders.xtop = interp1(1:numpoints(1),xrows(1,:),Ppht,'linear','extrap');
    borders.xbot = interp1(1:numpoints(1),xrows(end,:),Pphb,'linear','extrap');
    borders.ytop = interp1(1:numpoints(1),yrows(1,:),Ppht,'linear','extrap');
    borders.ybot = interp1(1:numpoints(1),yrows(end,:),Pphb,'linear','extrap');
    %% And now use that data to refine the line positions.
    %  This is a rinse-and-repeat procedure, so it works almost the same as
    %  above:
    %% Interpolate
    xcols = zeros(numcols,numpoints(2));
    ycols = zeros(numcols,numpoints(2));
    for k=1:numcols
        xcols(k,:) = linspace(borders.xtop(k),borders.xbot(k),numpoints(2));
        ycols(k,:) = linspace(borders.ytop(k),borders.ybot(k),numpoints(2));
    end
    colsample = interp2(double(softpic),xcols,ycols);
    %% Average, clean, peak detection
%     sprevwin = conv2(colsample.^2,ones(21,1),'same');
    sprevwin = conv2(colsample.^2,ones(41,1),'same');
    sfilt = fir1(filtlen,filtwid)...
          .*cos(2*pi*vblocks/numpoints(2)*(-filtlen/2:filtlen/2));
    signalvwin = conv2(sprevwin,sfilt,'same');
    Ppvwin = cell(size(signalvwin,1),1);
    Pposwin = zeros(size(signalvwin));
    for k=1:size(signalvwin,1)
        %[~,Ppvwin{k}] = findpeaks(double(signalvwin(k,:)),'minPeakDistance',10);
        d=diff(signalvwin(k,:));
        Ppvwin{k}=find((sign(d(1:end-1))>0)&(sign(d(2:end))<0))+1;
        Pposwin(k,Ppvwin{k}) = 1;
    end
    poscount = sum(Pposwin.');
    numrows = round(median(poscount));
    pospoints = find(poscount==numrows);
    posline = cell2mat(Ppvwin(pospoints));
    h = x0(pospoints).';
    y0 = zeros(1,numrows);
    c = zeros(1,numrows);
    for k=1:numrows
        f = polyfit(h,posline(:,k),1);
        y0(k) = f(2);
        c(k) = f(1);
    end
    f = polyfit(y0.',c.',1);
    a = f(2);
    b = f(1);
    Ppv = bsxfun(@plus,a*x0.',y0)+b*x0.'*y0;
    %% Determine sampling positions for each column
    X = zeros(numcols,numrows);
    Y = zeros(numcols,numrows);
    for k = 1:numcols
        X(k,:) = interp1(1:numpoints(2),xcols(k,:),Ppv(k,:),'linear','extrap');
        Y(k,:) = interp1(1:numpoints(2),ycols(k,:),Ppv(k,:),'linear','extrap');
    end
end