function [FIPx,FIPy,ux,vx,cr] = detectFIP(Img_handle)     

%     Fn1 = 'YUV_2018_04_20_09_33_51_995.yuv';
%     Fn1 = 'YUV_2018_04_20_09_33_51_995.yuv';

%     load('Text_data.mat');
     addpath QRFIP
    
%     [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(Fn1);
%     figure, imshow(yuv(1).Y,[]);
    
%     Y = yuv(1).Y;
%     U = yuv(1).U;
%     V = yuv(1).V;
    
    Y = Img_handle;
%     figure, imshow(Y,[]);
    % inition the image total black 
%     Yw = single(zeros(size(Y)));
%     Uw = single(zeros(size(U)));
%     Vw = single(zeros(size(V)));
    
    % take the size and the dimension of the image 
    h = size(Y, 1);
    w = size(Y, 2);
    n = size(Y, 3);
    
    % im real we don't need to analyse the whole pixels in the image, we
    % just
    s.offset = 0;
    s.sizeH = 250;192*2*(uint16(w/1920)); % 250:450 d.h. the ratio of the tv 3:4
    s.sizeW = 450;256*2*(uint16(w/1920)); % 192:256 d.h. the ratio of the tv 9:16
    s.warpRatio = 1;0.9;
    s.FIPsize = 108;36*(w/1920); % 4 pixels per module
    PatternAreaBW = zeros(s.sizeH, s.sizeW, 4);
    y = Y(:,:,1);
    if max(y(:)) > 1
        y = y / 255; 
    end
     th = 0.35;
     
     % these section help us to deplete the order of the data, what we need
     % to process. This is beacuse we popurse is to find the qr pattern, 
     % and they only display in the corner of the Monitors.

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
    
    PatternAreaBW(:,:,1) = y(s.offset+1:s.sizeH+s.offset,...
        s.offset+1:s.sizeW+s.offset);
    PatternAreaBW(:,:,2) = y(s.offset+1:s.sizeH+s.offset,...
        end-s.sizeW-s.offset+1:end-s.offset);
    PatternAreaBW(:,:,3) =  y(end-s.sizeH-s.offset+1:end-s.offset, ...
        s.offset+1:s.sizeW+s.offset);
    PatternAreaBW(:,:,4) = y(end-s.sizeH-s.offset+1:end-s.offset, ...
        end-s.sizeW-s.offset+1:end-s.offset);
%     figure, imshow(PatternAreaBW(:,:,1)),title('potential area of the QR Pattern');
%     figure, imshow(PatternAreaBW(:,:,2)),title('potential area of the QR Pattern');
%     figure, imshow(PatternAreaBW(:,:,3)),title('potential area of the QR Pattern');
%     figure, imshow(PatternAreaBW(:,:,4)),title('potential area of the QR Pattern');



    FIPx = zeros(1, 4);
    FIPy = zeros(1, 4);
    
        for p = 1 : 4
        patternInfo = FinderPatternFinder(not(PatternAreaBW(:,:,p)),true);
        FIPx(p) = patternInfo.posX;
        FIPy(p) = patternInfo.posY;
        
        while (FIPx(p)==0||FIPy(p)==0)
        patternInfo = FinderSigularPatternFinder(p); 
        FIPx(p) = patternInfo.posX;
        FIPy(p) = patternInfo.posY;
        end
%         if (p == 2 || p == 4)
%             FIPx(p) = w - s.sizeW + FIPx(p);
%         end
%         if (p == 3 || p == 4)
%             FIPy(p) = h - s.sizeH + FIPy(p);
%         end
        end
        
%         while (FIPx(p)==0||FIPy(p)==0)
%         patternInfo = FinderSigularPatternFinder(p); 
%         FIPx(p) = patternInfo.posX;
%         FIPy(p) = patternInfo.posY;
%         end

        
        FIPx(2) = w - s.sizeW + FIPx(2);
        FIPx(4) = w - s.sizeW + FIPx(4);
      
        FIPy(3) = h - s.sizeH + FIPy(3);
        FIPy(4) = h - s.sizeH + FIPy(4);
    
%     figure, imshow(Y,[])
%     hold on
%     plot(floor(FIPx(1)), floor(FIPy(1)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(2)), floor(FIPy(2)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(3)), floor(FIPy(3)), 'r.','MarkerSize', 10)
%     plot(floor(FIPx(4)), floor(FIPy(4)), 'r.','MarkerSize', 10)
    
    
      ux = [w*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          w*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2 ...
          w*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          w*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2];
      
      vx = [h*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          h*(1-s.warpRatio)/2 + s.FIPsize*s.warpRatio/2 ...
          h*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2 ...
          h*(1+s.warpRatio)/2 - s.FIPsize*s.warpRatio/2];
      
    [tformY, ~, ~] = estimateGeometricTransform(...
        [FIPx; FIPy].', [ux; vx].', 'projective');
%     Yw(:,:,1) = imwarp(Y(:,:,1), tformY, 'OutputView', imref2d(size(Y(:,:,1))));
%     figure, imshow(Yw(:,:,1),[]);
    
    % With the help of the projective transform Matrix we can find the 
    % corner of the monitor in the world coordinate.
    cr = zeros(4,2);
    [cr(1,1),cr(1,2)]= transformPointsInverse(tformY,0,0);
    [cr(2,1),cr(2,2)]= transformPointsInverse(tformY,1920,0);
    [cr(3,1),cr(3,2)]= transformPointsInverse(tformY,0,1080);
    [cr(4,1),cr(4,2)]= transformPointsInverse(tformY,1920,1080);
    
end
    