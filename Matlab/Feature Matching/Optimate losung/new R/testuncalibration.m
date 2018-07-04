clean;
% parameter: f,thetaz,thetay,thetax,ts,td,wd
% input: 2 set of corresponding points after sift und RANSAC x,y

%% load the image
fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
% fn1 ='YUV_2018_06_26_17_27_29_610.yuv';
% fn2 ='YUV_2018_06_26_17_26_59_679.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
[yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);
Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;

%  load('image.mat');
%  Img1 = A; Img2 = B;
 
% rotation test
% Img1 = imread('IMG_0385.JPG');Img2 = imread('IMG_0384.JPG'); %  c.a. y-achse 7 grad
%  Img1 = imread('IMG_0390.JPG');Img2 = imread('IMG_0391.JPG'); %  c.a. y-achse 14 grad
% Img1 = imread('IMG_0386.JPG');Img2 = imread('IMG_0387.JPG'); %  c.a. x-achse 6 grad 
% Img1 = imread('IMG_0388.JPG');Img2 = imread('IMG_0389.JPG'); %  c.a. x-achse 9 grad 
% Translation test
% Img1 = imread('IMG_0392.JPG');Img2 = imread('IMG_0393.JPG'); %  c.a. x-achse 9 grad 

% Igray1 = rgb2gray(Img1);
% Igray2 = rgb2gray(Img2);
frame_size = size(Igray1);
figure, imshow(Igray1);
figure, imshow(Igray2);
figure, imshowpair(Igray1,Igray2);

% for i=1:5
%% feature detection
points1 = detectSURFFeatures(Igray1);
points2 = detectSURFFeatures(Igray2);

[features1, valid_points1] = extractFeatures(Igray1, points1);
[features2, valid_points2] = extractFeatures(Igray2, points2);
% match the point
indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
figure; showMatchedFeatures(Igray1,Igray2,matchedPoints1,matchedPoints2);title('Candidate matched points (including outliers)');

% discard outliers with RANSAC
% [fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','Norm8Point');
% inlierPts1 = matchedPoints1(inliers,:);
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','DistanceThreshold',0.08);
inlierPts1 = matchedPoints1(inliers,:);
inlierPts2 = matchedPoints2(inliers,:);
% clear fLMedS;
figure;
showMatchedFeatures(Igray1, Igray2, inlierPts1,inlierPts2,'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');

% fLMedS = estimateFundamentalMatrix(inlierPts1,inlierPts2,'Method','Norm8Point');


[t1, t2] = estimateUncalibratedRectification(fLMedS,inlierPts1,...
    inlierPts2,size(Igray2));
[I1Rect,I2Rect] = rectifyStereoImages(Igray1,Igray2,t1,t2);

figure;
imshow(stereoAnaglyph(I1Rect,I2Rect));