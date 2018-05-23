
% quantify the likelihood of a rectangular shape being a true positive
% Idea: integrating imbalance points

% Parament: I grayscale image, p an image point,theta(i)=(i-1)*theltatheta,
% l(i)=(cos(theta(i)),sin(theta(i))), for i = 1,2,,,n.
% theltatheta = 360/n. 
%           


%% load the image from the camera
        
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
    
    n = 8;
    
    
    for i = 1:n
    theta(i)=(i-1)*theltatheta;
    l(i,:)=cos(theta(i)),sin(theta(i));
    theltatheta = 360/n;
    end
    
    diff(handels.Imggray,30);