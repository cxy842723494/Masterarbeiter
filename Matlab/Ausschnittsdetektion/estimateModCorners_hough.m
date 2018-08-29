function [corners,selectf2,Hh,Hv,select,Th,Rh,Ph,Tv,Rv,Pv,selectf] = estimateModCorners(edges,maxtilt)
 
    %% Hough transform
    % We want to get the boundaries of the modulated rectangle as lines. To
    % do that, we must detect edges residing on a straight line through the
    % picture. The Hough transform provides such information by having
    % peaks at points corresponding to straight lines in a binary image.
    % The effort for a Hough transform depends on the size of the image and
    % the amount of angles analyzed. Since angular resolution is important
    % for further processing, a maximum camera tilt is prescribed.
    if nargin < 4 || isempty(maxtilt)
        maxtilt = 10;
    end
    thetah = [-90:0.1:(maxtilt-90),(90-maxtilt):0.1:89.9];
    thetav = -maxtilt:0.1:maxtilt;
    %% With separate Hough transforms for horizontal and vertical edges,
    %  we prevent accidential detection of three or more (almost) parallel
    %  lines.
    [Hh,Th,Rh] = hough(edges,'Theta',thetah);
    Th = fftshift(Th);
    Hh = fftshift(Hh,2);
    subzero = Th<0;
    Th(subzero) = Th(subzero)+180;
    Hh(:,subzero) = Hh(end:-1:1,subzero);
    %Hh = round(imgaussfilt(Hh,1));
    Ph = houghpeaks(Hh,2,'Threshold',mean(Hh(:)),...
        'NHoodSize',[ceil(length(Rh)/20)*2+1,floor(length(Th)/4)*2+1]);
    [Hv,Tv,Rv] = hough(edges,'Theta',thetav);
    %Hv = round(imgaussfilt(Hv,1));
    Pv = houghpeaks(Hv,2,'Threshold',mean(Hv(:)),...
        'NHoodSize',[ceil(length(Rv)/20)*2+1,floor(length(Tv)/4)*2+1]);
    % 2 peaks each for top/bottom and left/right
    % Threshold is arbitrary, but lower than default to avoid early
    % termination of peak detection. Neighborhood size is drastically
    % increased over defaults to prevent a single edge from being detected
    % twice, because we know the edges are near the perimeter and there is
    % only one edge per perimeter.

    Tph = Th(Ph(:,2));
    Rph = Rh(Ph(:,1));
    Tpv = Tv(Pv(:,2));
    Rpv = Rv(Pv(:,1));
    %% From these peaks, we can determine the line equations
    y0h = Rph./sind(Tph);
    mh = tand(Tph+90);
    x0v = Rpv./cosd(Tpv);
    imv = -tand(Tpv);
    %% And then intersect those to get the corners
    p = [1 2 2 1 ;1 1 2 2];
    corners = zeros(2,4);
    corners(1,:) = (imv(p(2,:)).*y0h(p(1,:))+x0v(p(2,:)))./...
                   (1-mh(p(1,:)).*imv(p(2,:)));
    corners(2,:) = (mh(p(1,:)).*x0v(p(2,:))+y0h(p(1,:)))./...
                   (1-imv(p(2,:)).*mh(p(1,:)));
end