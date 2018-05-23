clear
close all
clc

addpath D:\SVN_Porjekt\VLC\MobileDecoder\functions

%%
fn = 'YUV_2017_07_24_16_41_19_667.yuv';
[Y, U, V] = readYUV(fn);
% im = imread('mlw1K.jpg');
% ycbcr = rgb2ycbcr(im);
% Y = ycbcr(:,:,1);
figure, imshow(Y, [])

%%
% bw = getBlackMatrix(Y);
% figure, imshow(bw)

Y = Y / 255;
% Y = imsharpen(Y);
level = graythresh(Y);
bw = not(im2bw(Y, level));

offset = 0;
sizeH = 128;
sizeW = 256;

Y_topleft    = Y(offset+1:sizeH+offset, offset+1:sizeW+offset);
Y_topright   = Y(offset+1:sizeH+offset, end-sizeW-offset+1:end-offset);
Y_bottomleft = Y(end-sizeH-offset+1:end-offset, offset+1:sizeW+offset);
figure,
subplot(2,2,1)
imshow(Y_topleft)
subplot(2,2,2)
imshow(Y_topright)
subplot(2,2,3)
imshow(Y_bottomleft)

figure
subplot(3,2,1)
plot(diff(Y_topleft.'))
subplot(3,2,2)
plot(diff(Y_topleft))
subplot(3,2,3)
plot(diff(Y_topright.'))
subplot(3,2,4)
plot(diff(Y_topright))
subplot(3,2,5)
plot(diff(Y_bottomleft.'))
subplot(3,2,6)
plot(diff(Y_bottomleft))

% 20%
data = diff(Y_topleft.').';
% for k = 1 : size(data, 1)
%     datak = data(k, :);
%     datak(abs(datak - mean(datak)) <= 0.2) = 0;
%     data(k, :) = datak;
% end
data_topleft = [];
for k = 1 : size(data, 1)
    datak = data(k, :);
    if (sum(abs(datak - mean(datak)) > 0.2) >= 6)
        datak(abs(datak - mean(datak)) <= 0.2) = 0;
        data_topleft = [data_topleft; datak];
    end
end

%%
% diff_h = diff(Y_topleft.');
% diff_v = diff(Y_topleft);

% figure,
% for k = 1 : size(Y_topleft, 1)
%     diffh = diff(Y_topleft(k, :));
%     plot(diffh)
% %     [pks,locs] = findpeaks(diffh);
%     findpeaks(diffh)
% end

% 
% figure, plot(diff_h)
% figure, plot(diff_v)
