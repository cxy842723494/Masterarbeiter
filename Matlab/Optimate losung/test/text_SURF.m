%% text for SURF Algorithmus

I1 = imread('IMG_0349.jpg');
I2 = imread('IMG_0348.jpg');
figure, imshowpair(I1,I2,'montage');

Igray1 = rgb2gray(I1);
Igray2 = rgb2gray(I2);

points1 = detectSURFFeatures(Igray1);
points2 = detectSURFFeatures(Igray2);

imshow(I1); hold on;
plot(points1.selectStrongest(1200));

[features1, valid_points1] = extractFeatures(Igray1, points1);
[features2, valid_points2] = extractFeatures(Igray2, points2);
% match the point
indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
figure; showMatchedFeatures(I1,I2,matchedPoints1.selectStrongest(600),matchedPoints2.selectStrongest(600),'montage');title('Candidate matched points (including outliers)');

[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','DistanceThreshold',0.08);
inlierPts1 = matchedPoints1(inliers,:);
inlierPts2 = matchedPoints2(inliers,:);

figure;
showMatchedFeatures(I1, I2, inlierPts1,inlierPts2,'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');