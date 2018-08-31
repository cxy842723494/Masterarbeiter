im =Y;
im =Ynew;
    % center of the image
    center = floor((size(im)+1)/2);
    %% certain vertical line 
    Th = -5:0.1:5;
    % radon transform mit gray iamge 
    [R,x_] = radon(im(:,:,1),Th);
    % find peaks(maxima RF integral)with all the angles which in the range
    [RpTh,pTh] = max(R.');
    
    v=sort(RpTh,'descend');%,'descend'
    v=v(1:18);           
    idx=zeros(1,18);

     for i=1:18
        idx(i) = find(RpTh==v(i));
        x_n(i) = x_(idx(i));
     end
    
    % find the biggst peaks in left and right derection
    [~,px_m] = max(RpTh.'.*-sign(x_));      % Left
    [~,px_p] = max(RpTh.'.*sign(x_));       % Right
    % find the nummer of the pixels travel along from the center 
    x_l = x_(px_m);
    x_r = x_(px_p);
    % degree of the radial line that passes through the center
    Thl = Th(pTh(px_m));
    Thr = Th(pTh(px_p));
    % certain the insection point between the radial line and the boundary line 
    xl = center(2)+x_l*cosd(Thl);
    xr = center(2)+x_r*cosd(Thr);
    % -thl (fragen)
    yl = center(1)+x_l*sind(-Thl);
    yr = center(1)+x_r*sind(-Thr);
    % Slope of the line
    iml = tand(Thl);
    imr = tand(Thr);
    %
    x0l = xl-iml*yl;   % (598,0)
    x0r = xr-imr*yr;
    
    figure, imshow(Y,[]),hold on;
     xy = [x0r 1; x0r 1080];
    plot(xy(:,1),xy(:,2),'LineWidth',10,'Color','red');
    
    % 2160(fragen) 1080*2
    xml = x0l+iml*2160;
    xmr = x0r+imr*2160;
    %% certain horizontal line 
    Th = 80:0.1:100;
    % radon transform
    [R,x_] = radon(im(:,:,1),Th);
    % find peaks with maxima RF integral and the corresponde angle.
    [RpTh,pTh] = max(R.');
    [~,px_m] = max(RpTh.'.*-sign(x_));
    [~,px_p] = max(RpTh.'.*sign(x_));
    x_b = x_(px_m);
    x_t = x_(px_p);
    Thb = Th(pTh(px_m));
    Tht = Th(pTh(px_p));
    xb = center(2)+x_b*cosd(Thb);
    xt = center(2)+x_t*cosd(Tht);
    yb = center(1)+x_b*sind(-Thb);
    yt = center(1)+x_t*sind(-Tht);
    mb = cotd(Thb);
    mt = cotd(Tht);
    y0b = yb-mb*xb;
    y0t = yt-mt*xt;
    ymb = y0b+mb*3840;  %1920*2
    ymt = y0t+mt*3840;
    corners(1,1) = (iml.*y0t+x0l)./(1-mt.*iml);
    corners(2,1) = (mt.*x0l+y0t)./(1-iml.*mt);
    corners(1,2) = (imr.*y0t+x0r)./(1-mt.*imr);
    corners(2,2) = (mt.*x0r+y0t)./(1-imr.*mt);
    corners(1,3) = (imr.*y0b+x0r)./(1-mb.*imr);
    corners(2,3) = (mb.*x0r+y0b)./(1-imr.*mb);
    corners(1,4) = (iml.*y0b+x0l)./(1-mb.*iml);
    corners(2,4) = (mb.*x0l+y0b)./(1-iml.*mb);
end