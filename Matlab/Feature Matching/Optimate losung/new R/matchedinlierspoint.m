function [pts1h,pts2h] = matchedinlierspoint(Igray1,Igray2)


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
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','DistanceThreshold',0.08);
inlierPts1 = matchedPoints1(inliers,:);
inlierPts2 = matchedPoints2(inliers,:);

figure;
showMatchedFeatures(Igray1, Igray2, inlierPts1,inlierPts2,'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');

integerClass = 'int32';
outputClass = 'double';

nPts = cast(size(inlierPts1, 1), integerClass);

pts1h = coder.nullcopy(zeros(3, nPts, outputClass));
pts2h = coder.nullcopy(zeros(3, nPts, outputClass));

pts1h(3, :)   = 1;
pts2h(3, :)   = 1;

pts1h(1:2, :) = inlierPts1.Location';
pts2h(1:2, :) = inlierPts2.Location';