s.imgPath = 'input';
s.tSync = 'up'; % 'rs'
s.displayRes = [1920 1080];

% s.numDiff = 6;
s.blockSize = 4;

if ~exist('Y', 'var')
    %% Read Images
    [Y, U, V] = functions.readYUVfolder(s.imgPath);
    
    %% Detect QR Pattern and Warp Images
%     [Y, U, V] = detectFIPandWarp(Y, U, V);

end

%% Transform to RGB
% 
% load('functions/BT709_l.mat');
% Trgb2yuv = rgb2yuvT;
% Tyuv2rgb = inv(Trgb2yuv);
% 
% R = zeros(size(V));
% B = zeros(size(U));
% G = zeros(size(U));
% for i=1:size(V,3)
%     R(:,:,i) = Tyuv2rgb(1,1) * Y(:,:,i) + Tyuv2rgb(1,2) * U(:,:,i) + Tyuv2rgb(1,3) * V(:,:,i);
%     G(:,:,i) = Tyuv2rgb(2,1) * Y(:,:,i) + Tyuv2rgb(2,2) * U(:,:,i) + Tyuv2rgb(2,3) * V(:,:,i);
%     B(:,:,i) = Tyuv2rgb(3,1) * Y(:,:,i) + Tyuv2rgb(3,2) * U(:,:,i) + Tyuv2rgb(3,3) * V(:,:,i);
% end
% R = R.^(1/2.4);
% B = B.^(1/2.4);
%% Temporal Sync
[result, diffImages, Y, U, V] = functions.temporalSync.temporalSyncSequential2(Y, U, V);

% diffImages = imfilter(diffImages, circshift(hadamard(4),1));
functions.temporalSync.plotDiffImages(diffImages(:,:,1,:), result); 

