function [Yw, Uw, Vw] = detectFIPandWarp(Y, U, V)

addpath QRFIP

Yw = single(zeros(size(Y)));
Uw = single(zeros(size(U)));
Vw = single(zeros(size(V)));

n = size(Y, 3);
h = size(Y, 1);
w = size(Y, 2);

s.offset = 0;
s.sizeH = 250;192*2*(uint16(w/1920)); % 144
s.sizeW = 450;256*2*(uint16(w/1920));
s.warpRatio = 1;0.9;
s.FIPsize = 81;36*(w/1920); % 4 pixels per module
PatternAreaBW = zeros(s.sizeH, s.sizeW, 4);

for k = 1 : n
    %% Detect the finder patterns
    disp(['Detecting QR Pattern in ' num2str(k) '-th Image']);
    y = Y(:,:,k);
    if max(y(:)) > 1
        y = y / 255;
    end
    th = 0.35;
%     PatternAreaBW(:,:,1) = not(imbinarize(y(s.offset+1:s.sizeH+s.offset,...
%         s.offset+1:s.sizeW+s.offset), 'adaptive', 'ForegroundPolarity', ...
%         'bright', 'Sensitivity', th));
%     PatternAreaBW(:,:,2) = not(imbinarize(y(s.offset+1:s.sizeH+s.offset,...
%         end-s.sizeW-s.offset+1:end-s.offset), 'adaptive', ...
%         'ForegroundPolarity', 'bright', 'Sensitivity', th));
%     PatternAreaBW(:,:,3) = not(imbinarize(...
%         y(end-s.sizeH-s.offset+1:end-s.offset, ...
%         s.offset+1:s.sizeW+s.offset), ...
%         'adaptive', 'ForegroundPolarity','bright', 'Sensitivity', th));
%     PatternAreaBW(:,:,4) = not(imbinarize(...
%         y(end-s.sizeH-s.offset+1:end-s.offset, ...
%         end-s.sizeW-s.offset+1:end-s.offset),...
%         'adaptive', 'ForegroundPolarity','bright', 'Sensitivity', th));
    PatternAreaBW(:,:,1) = not(AdaptiveThreshold(y(s.offset+1:s.sizeH+s.offset,...
        s.offset+1:s.sizeW+s.offset), 25, 2));
    PatternAreaBW(:,:,2) = not(AdaptiveThreshold(y(s.offset+1:s.sizeH+s.offset,...
        end-s.sizeW-s.offset+1:end-s.offset), 25, 2));
    PatternAreaBW(:,:,3) = not(AdaptiveThreshold(...
        y(end-s.sizeH-s.offset+1:end-s.offset, ...
        s.offset+1:s.sizeW+s.offset), ...
        25, 2));
    PatternAreaBW(:,:,4) = not(AdaptiveThreshold(...
        y(end-s.sizeH-s.offset+1:end-s.offset, ...
        end-s.sizeW-s.offset+1:end-s.offset),...
        25, 2));
    
    FIPx = zeros(1, 4);
    FIPy = zeros(1, 4);
    
    for p = 1 : 4
        patternInfo = FinderPatternFinder(PatternAreaBW(:,:,p),true);
        FIPx(p) = patternInfo.posX;
        FIPy(p) = patternInfo.posY;
        if (p == 2 || p == 4)
            FIPx(p) = w - s.sizeW + FIPx(p);
        end
        if (p == 3 || p == 4)
            FIPy(p) = h - s.sizeH + FIPy(p);
        end
    end
    
%     figure, imshow(Y1p)
%     hold on
%     plot(floor(FIPx(1)), floor(FIPy(1)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(2)), floor(FIPy(2)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(3)), floor(FIPy(3)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(4)), floor(FIPy(4)), 'r.','MarkerSize', 10)
%     
%     figure, imshow(Y1n)
%     hold on
%     plot(floor(x1n(1)), floor(y1n(1)), 'r.','MarkerSize', 10)
%     plot(floor(x1n(2)), floor(y1n(2)), 'r.','MarkerSize', 10)
%     plot(floor(x1n(3)), floor(y1n(3)), 'r.','MarkerSize', 10)
%     plot(floor(x1n(4)), floor(y1n(4)), 'r.','MarkerSize', 10)
    
    %% projective transformation
%     ux = [w*(1-s.warpRatio) w*s.warpRatio w*(1-s.warpRatio) w*s.warpRatio];
%     vx = [h*(1-s.warpRatio) h*(1-s.warpRatio) h*s.warpRatio h*s.warpRatio];
    
    ux = [w*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          w*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2 ...
          w*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          w*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2];
       
    vx = [h*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          h*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          h*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2 ...
          h*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2];
    
%     ux = [s.FIPsize/2 w-s.FIPsize/2 s.FIPsize/2 w-s.FIPsize/2];
%     vx = [s.FIPsize/2 s.FIPsize/2 h-s.FIPsize/2  h-s.FIPsize/2];
    
    [tformY, ~, ~] = estimateGeometricTransform(...
        [FIPx; FIPy].', [ux; vx].', 'projective');
    Yw(:,:,k) = imwarp(Y(:,:,k), tformY, 'OutputView', imref2d(size(Y(:,:,k))));
    
    [tformUV, ~, ~] = estimateGeometricTransform(...
        [FIPx/2; FIPy/2].', [ux/2; vx/2].', 'projective');
    Uw(:,:,k) = imwarp(U(:,:,k), tformUV, ...
        'OutputView', imref2d(size(U(:,:,k))));
    Vw(:,:,k) = imwarp(V(:,:,k), tformUV, ...
        'OutputView', imref2d(size(V(:,:,k))));
end