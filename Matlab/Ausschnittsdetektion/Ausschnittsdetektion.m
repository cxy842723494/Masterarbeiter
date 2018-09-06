clear
clc
%% read YUV images and calculate differential images
fn1 = 'yuv_1_bs8_2.yuv';
fn2 = 'yuv_2_bs8_2.yuv';

[yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
[yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);

% img = yuv2rgb(yuv(1).Y,yuv(1).U,yuv(1).V);
% grayimg = rgb2gray(img);
diff(:,:,1) = yuv(1).V - yuv(2).V;
figure, imshow(diff(:,:,1),[]);
figure, histogram(diff(:,:,1));
% % diff(:,:,3) = yuv(1).U - yuv(2).U;
% diffc_r = yuv(1).U - yuv(2).U;



diffc_r  = diffplus;
%% corner detection
% vblocks = 1080/8;
% hblocks = 1920/8;

% einzelbilder
% diffc_r = gather(conv2([1 2 1]/2,[1 2 1]/2, yuv(1).U ,'same'));
cr = estimateModCorners(diffc_r,50/100,7,10);
figure, imshow(diffc_r,[]);

% differenzbilder
%diffc_r = gather(conv2([1 2 1]/2,[1 2 1]/2, diff(:,:,1),'same'));
%cr = estimateModCorners(diffc_r,1/2,7,10);

%% plot results
[y,i] = sort(cr(2,:));
x = cr(1,i);
[x(1:2),i] = sort(x(1:2));
y(1:2) = y(i);
[x(4:-1:3),i] = sort(x(3:4));
y(3:4) = y(5-i);

% einzelbilder
% figure, imshow(yuv(1).U,[]);
figure, imshow(diffc_r,[]);
% differenzbilder
%figure, imshow(diff(:,:,1),[])
%figure, imshow(diffplus,[])
hold on
plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)

% plot(cr(1,1),cr(2,1), 'r.');
% plot(cr(1,2),cr(2,2), 'r.');
% plot(cr(1,3),cr(2,3), 'r.');
% plot(cr(1,4),cr(2,4), 'r.');
% 
% plot(cr(1,1),cr(2,1), 'g.');
% plot(cr(1,2),cr(2,2), 'g.');
% plot(cr(1,3),cr(2,3), 'g.');
% plot(cr(1,4),cr(2,4), 'g.');


ux = [1,1920, 1920, 1];
vx = [1,1, 1080, 1080];

[tformY, ~, ~] = estimateGeometricTransform(...
    [x; y].', [ux; vx].', 'projective');
 diffc_rw = imwarp(diffc_r, tformY, 'OutputView', imref2d(size(diffc_r)));
 figure, imshow(diffc_rw,[]);
