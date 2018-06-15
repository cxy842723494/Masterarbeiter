%% Use the Least Median of Squares Method to Find Inliers
%
%% 
% Load the putatively matched points.
load stereoPointPairs
inlierPts1 = matchedPoints1(knownInliers,:);
inlierPts2 = matchedPoints2(knownInliers,:);
[fLMedS, inliers] = estimateFundamentalMatrix(inlierPts1,inlierPts2,'Method','Norm8Point')
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


fLMedS_cpp = projective2d(fLMedS);
I2new = imwarp(I2, fLMedS,'OutputView', imref2d(size(I1)));