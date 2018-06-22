clean;
% parameter: f,thetaz,thetay,thetax,ts,td,wd
% input: 2 set of corresponding points after sift und RANSAC x,y

% load the image
fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
[yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);


Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;
% figure, imshow(Igray1);
% figure, imshow(Igray2);
% feature detection
points1 = detectSURFFeatures(Igray1);
points2 = detectSURFFeatures(Igray2);

[features1, valid_points1] = extractFeatures(Igray1, points1);
[features2, valid_points2] = extractFeatures(Igray2, points2);
% match the point
indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
% figure; showMatchedFeatures(Igray1,Igray2,matchedPoints1,matchedPoints2);title('Candidate matched points (including outliers)');

% discard outliers with RANSAC
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','DistanceThreshold',0.1);
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

%% p0 parameter nur theta: 
% p0=[0.5 0.5 0.5];
% dp=[0.01 0.01 0.01 ]; % 0,11 grad
% term_dp=[0.001 0.001 0.001 ]; % 0.005 grad
% frame_size = size(Igray1);
% [p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size);
% x=1; 

%% p0 parameter include theta and focal length: 
% p0=[-1 1 1 3180];  %-1500  3180
% dp=[0.1 0.1 0.1 1]; % 0,11 grad
% term_dp=[0.001 0.001 0.001 0.2]; % 0.005 grad
% frame_size = size(Igray1);
% [p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size);
% x=1;

%% p0 parameter include theta shift and focal length: 
p0=[0 0 0 0 0 0];  %-1500  3180
dp=[0.1 0.1 0.1 1 1 1]; % 0,11 grad
term_dp=[0.0001 0.0001 0.0001 0.0001 0.0001 0.0001]; % 0.005 grad
frame_size = size(Igray1);
[p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size);
x=1;


% err += sqrt(dot(dxy, dxy));
% 
% err /= num_pts;