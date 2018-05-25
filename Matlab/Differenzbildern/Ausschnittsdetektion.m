% close all;
clean;
 %% read YUV images and calculate differential images
% for k = 1:2
%     [filename,filepath] = uigetfile('*.*','Select the image');
%     if isequal(filename,0)||isequal(filepath,0)
%         return;
%     else
%         filefullpath = [filepath,filename];
%     end
% %     img = imread(filefullpath);
% %     fn(:,:,:,k) = img;
%     [yuv(k).Y, yuv(k).U, yuv(k).V] = readYUV(filefullpath);
%     
% end

% fn1 = 'YUV_2018_04_20_09_34_44_823.yuv';
% fn2 = 'YUV_2018_04_20_09_34_44_795.yuv';


% [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
% [yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);
% 
% tic;
% diff(:,:,1) = yuv(1).V - yuv(2).V;
% % figure, imshow(diff(:,:,1),[])
% diff(:,:,3) = yuv(1).U - yuv(2).U;
target = 'ohne registration';
% target = 'mit registration';
switch target
    case 'ohne registration'
        load('diffc_Uo1.mat');
        diff = diffc_Uo;
        figure,subplot(1,2,1),imshow(diff,[]),title('ohne registration'),hold on;
        subplot(1,2,2),histogram(diff),title('ohne registration');
    case 'mit registration'
        load('diffc_U1.mat');
        diff = imcrop(diffc_U,[10 10 1899 1059]);
        figure,subplot(1,2,1),imshow(diff,[]),title('mit registration'),hold on;
        subplot(1,2,2),histogram(diff),title('mit registration');
end
% A = abs(diff)>std(double(diff(:)));
% A = imcrop(diff,[95 95 149 149]);
% B = imcrop(diff,[1537 112 149 149]);
% C = imcrop(diff,[180 858 149 149]);
% D = imcrop(diff,[1499 822 149 149]);

% A = imcrop(diff,[435 194 74 74]);
% B = imcrop(diff,[1318 211 74 74]);
% C = imcrop(diff,[450 653 74 74]);
% D = imcrop(diff,[1292 671 74 74]);
figure,histogram(A);figure,imshow(B,[]);

threshold = graythresh(diff);

threshold = mean2(diff);

graythresh(E);
BW = AdaptiveThreshold(diff,80,80);
fun = @(block_struct) imbinarize(block_struct.data);
BW = blockproc(diff,[80 80],fun); 
BW = imbinarize(diff,4);
BW = imbinarize(abs(diff),6);
BW = imbinarize(A,'adaptive');%,'adaptive'
BW = imbinarize(abs(A),'adaptive');%,'adaptive'
figure,imshow(BW),[],title('Sensitivity 0.2');
Mopho = imopen(BW,ones(6));
Mopho = imclose(BW,ones(6));
figure,imshow(Mopho),title('mophologi');
 otsuthresh(diff)
[counts,x] = imhist(diff);
figure,stem(x,counts)
T = otsuthresh(counts);

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

% toc;