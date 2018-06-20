%% Use the Least Median of Squares Method to Find Inliers
%
%% 
% Load the putatively matched points.
load stereoPointPairs
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','DistanceThreshold',0.1);
inlierPts1 = matchedPoints1(inliers,:);
inlierPts2 = matchedPoints2(inliers,:);
%%
% Load the stereo images.
I1 = imread('viprectification_deskLeft.png');
I2 = imread('viprectification_deskRight.png');
%%
% Show the putatively matched points.
figure;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');
%%
% Show the inlier points.
figure;
showMatchedFeatures(I1, I2, matchedPoints1(inliers,:),matchedPoints2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');

inlier1 = matchedPoints1(inliers,:);
inlier2 = matchedPoints2(inliers,:);
fLMedS_cpp = projective2d(fLMedS);
I2new = imwarp(I2, fLMedS,'OutputView', imref2d(size(I1)));