clean;

% Img1= imread('IMG_0353.jpg');
% Img2= imread('IMG_0352.jpg');
% 
% Igray1 = rgb2gray(Img1);
% Igray2 = rgb2gray(Img2);

% fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
% fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
% fn1 ='YUV_2018_06_20_17_14_00_264.yuv';
% fn2 ='YUV_2018_06_20_17_14_00_259.yuv';

fn1 ='YUV_2018_05_30_11_20_24_001.yuv'; % real test
% fn2 ='YUV_2018_05_30_11_20_23_967.yuv';
fn2 ='YUV_2018_05_30_11_20_24_400.yuv';
% fn1 ='YUV_2018_06_26_17_27_29_610.yuv';
% fn2 ='YUV_2018_06_26_17_26_59_679.yuv';

% fn1 ='YUV_2018_06_06_12_54_25_357.yuv';
% fn2 ='YUV_2018_06_06_12_54_25_344.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
[yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);
Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;

figure, imshow(Igray1);
figure, imshow(Igray2);



% MOVINGREG = registerImagestext1(Igray1,Igray2);
points1 = detectSURFFeatures(Igray1);
points2 = detectSURFFeatures(Igray2);

[features1, valid_points1] = extractFeatures(Igray1, points1);
[features2, valid_points2] = extractFeatures(Igray2, points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
figure; showMatchedFeatures(Igray1,Igray2,matchedPoints1,matchedPoints2);title('Candidate matched points (including outliers)');

[tform,inlierpoints1,inlierpoints2] = estimateGeometricTransform(...
matchedPoints1,matchedPoints2,'projective');
figure; showMatchedFeatures(Igray1,Igray2,inlierpoints1,inlierpoints2);
title('Matched inlier points');

%%
 MOVINGREG.Transformation = tform;
 MOVINGREG.RegisteredImage = imwarp(Igray1, imref2d(size(Igray1)), tform, 'OutputView', imref2d(size(Igray2)), 'SmoothEdges', true);
 figure, imshow(MOVINGREG.RegisteredImage);

 figure, imshowpair(MOVINGREG.RegisteredImage,Igray2);
figure, imshowpair(Igray1,Igray2);