function [X,Y,signalh,signalv,spreh,sprev,Pph,Ppv] = findSamplingPoints(im,borders,numpoints,hblocks,vblocks,filtlen,filtwid)
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
%     blocksized = mean(sqrt(diff(borders.yleft).^2+diff(borders.xleft).^2))/2 ...
%               + mean(sqrt(diff(borders.yright).^2+diff(borders.xright).^2))/2;
%             % Block size along display axis - will need that for filters
%             % one day
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
    %  point is in the spatial peaks.
    spreh = sum(rowsample.^2);
    %sfilt = [-1 1 0 1 -1];
    sfilt = fir1(filtlen,filtwid)...
          .*cos(2*pi*hblocks/numpoints(1)*(-filtlen/2:filtlen/2));
    signalh = conv(spreh,sfilt,'same');
%    signalh(signalh<0) = 0; % remove spurious peaks in the valleys
%    signalh([1:2,end-1:end]) = 0; % remove spurious peaks at the edges
%                                 % (filter not ready)
    [~,Pph] = findpeaks(double(signalh),'minPeakDistance',10);
    % Prevent peaks from registering twice in the presence of noise
    % NB: Maybe some post-processing to clean up any remaining mess of
    % spurious or missing peaks in the future
    %% Now that we have optimum sampling points in the horizontal
    %  direction, we can determine the position of the sampling columns
    borders.xtop = interp1(1:numpoints(1),xrows(1,:),Pph);
    borders.xbot = interp1(1:numpoints(1),xrows(end,:),Pph);
    borders.ytop = interp1(1:numpoints(1),yrows(1,:),Pph);
    borders.ybot = interp1(1:numpoints(1),yrows(end,:),Pph);
    %% And now use that data to refine the line positions.
    %  This is a rinse-and-repeat procedure, so it works almost the same as
    %  above:
    %% Interpolate
    numcols = length(Pph);
    xcols = zeros(numcols,numpoints(2));
    ycols = zeros(numcols,numpoints(2));
    for k=1:numcols
        xcols(k,:) = linspace(borders.xtop(k),borders.xbot(k),numpoints(2));
        ycols(k,:) = linspace(borders.ytop(k),borders.ybot(k),numpoints(2));
    end
    colsample = interp2(double(softpic),xcols,ycols);
    %% Average, clean, peak detection
    sprev = sum(colsample.^2);
    sfilt = fir1(filtlen,filtwid)...
          .*cos(2*pi*vblocks/numpoints(2)*(-filtlen/2:filtlen/2));
    signalv = conv(sprev,sfilt,'same');
    [~,Ppv] = findpeaks(double(signalv),'minPeakDistance',10);
    %% Determine sampling positions for each column
    P0 = Ppv(1);
    Pdiff = diff(Ppv);
    Ptoolarge = find(Pdiff>(sqrt(2)*mean(Pdiff)));
    for k=length(Ptoolarge):-1:1
        Pdiff = [Pdiff(1:(Ptoolarge(k)-1)),Ptoolarge(k)/2,...
                Ptoolarge(k)/2,Pdiff((Ptoolarge(k)+1):end)];
    end
    Ptoosmall = find((Pdiff(1:end-1)+Pdiff(2:end))<(sqrt(2)*mean(Pdiff)));
    for k=length(Ptoosmall):-1:1
        Pdiff = [Pdiff(1:(Ptoosmall(k)-1)),...
            Pdiff(Ptoosmall(k))+Pdiff(Ptoosmall(k)+1),...
            Pdiff((Ptoosmall(k)+2):end)];
    end
    Pdiff = conv([Pdiff(1),Pdiff,Pdiff(end)],[1 2 1]/4,'valid');
    Ppv = cumsum([P0,Pdiff]);
    numrows = length(Ppv);
    X = zeros(numcols,numrows);
    Y = zeros(numcols,numrows);
    for k = 1:numcols
        X(k,:) = interp1(1:numpoints(2),xcols(k,:),Ppv);
        Y(k,:) = interp1(1:numpoints(2),ycols(k,:),Ppv);
    end
end