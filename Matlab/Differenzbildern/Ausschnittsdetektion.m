% close all;
clean;

 %% read YUV images and calculate differential images
for k = 1:2
    [filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end
%     img = imread(filefullpath);
%     fn(:,:,:,k) = img;
    [yuv(k).Y, yuv(k).U, yuv(k).V] = readYUV(filefullpath);
    
end

% fn1 = 'YUV_2018_04_20_09_34_44_823.yuv';
% fn2 = 'YUV_2018_04_20_09_34_44_795.yuv';


% [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
% [yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);

tic;
diff(:,:,1) = yuv(1).V - yuv(2).V;
% figure, imshow(diff(:,:,1),[])
diff(:,:,3) = yuv(1).U - yuv(2).U;

%% read single image 
% fn1 = 'yuv_1_bs8_2.yuv';
% fn2 = 'yuv_2_bs8_2.yuv';
% 
% [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
% [yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);
% 
% img = yuv2rgb(yuv(1).Y,yuv(1).U,yuv(1).V);
% grayimg = rgb2gray(img);

%% try some other form images for example:png,JPEG usw.
 
%  img = imread('8.jpg');
%  imggray = rgb2gray(img);

%% corner detection
vblocks = 1080/8;
hblocks = 1920/8;

% singlebilder
% diffc_r = gather(conv2([1 2 1]/2,[1 2 1]/2, imggray ,'same'));
% cr = estimateModCorners(diffc_r,50./100,7,10);

% differenzbilder
diffc_r = gather(conv2([1 2 1]/2,[1 2 1]/2, diff(:,:,1),'same'));

cr = estimateModCorners(diffc_r,1/2,5,10);

%% plot results
[y,i] = sort(cr(2,:));
x = cr(1,i);
[x(1:2),i] = sort(x(1:2));
y(1:2) = y(i);
[x(4:-1:3),i] = sort(x(3:4));
y(3:4) = y(5-i);

% einzelbilder
figure, imshow(diff(:,:,1),[])

% differenzbilder
%figure, imshow(diff(:,:,1),[])

hold on
plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)

toc;