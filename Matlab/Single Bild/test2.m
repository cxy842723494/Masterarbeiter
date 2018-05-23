clean;
% close all;

[filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end
    [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(filefullpath);
    
    Img = yuv2rgb(yuv(1).Y, yuv(1).U, yuv(1).V);
    
    handels.Img = double(Img)./255;
    handels.R = handels.Img(:,:,1);
    handels.G = handels.Img(:,:,2);
    handels.B = handels.Img(:,:,3);
    handels.Imggray = rgb2gray(handels.Img);
    figure, imshow(handels.Imggray);
    
    %
%     [n,m] = size(handels.Imggray);
%     B = zeros(3,3,(n-4)*(m-4));
%     for x = 3:n-2
%         for y = 3:m-2
%             B(:,:,(x-3)*(n-4)+y-2) = firstorderdirective12(handels.Imggray,1,x,y);
%         end
%     end
% choose the image point
    x=2063;y=3766;
    
%     B = firstorderdirective12(handels.Imggray,1,x,y);
    B = firstorderdirective12(handels.Imggray,2,x,y);
%     B = firstorderdirective3(handels.Imggray,x,y);
    
    B1 = reshape(B,1,9);
    B2 = sort(B1);
    figure,bar(B2);
    for k = 2:8
        B3(k-1) = B2(k+1)-B2(k);
    end
    figure,bar(B3);
    index = find(B3 == max(B3));
    if index ==4
       output=1;
    else 
       output=0; 
    end
    
    