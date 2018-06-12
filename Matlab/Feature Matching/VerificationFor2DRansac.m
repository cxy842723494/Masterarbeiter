clean;

Img1= imread('IMG_0363.jpg');
Img2= imread('IMG_0364.jpg');

Igray1 = rgb2gray(Img1);
Igray2 = rgb2gray(Img2);
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

 figure, imshow(MOVINGREG.RegisteredImage-Igray2);
