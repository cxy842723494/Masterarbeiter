function [BW,maskedImage] = imagebinariesierung(X)
%segmentImage Segment image using auto-generated code from imageSegmenter App
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter App. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 11-Jul-2018
%----------------------------------------------------


% Normalize input data to range in [0,1].
Xmin = min(X(:));
Xmax = max(X(:));
if isequal(Xmax,Xmin)
    X = 0*X;
else
    X = (X - Xmin) ./ (Xmax - Xmin);
end

% Threshold image - adaptive threshold
% BW = imbinarize(X, 'adaptive', 'Sensitivity', 0.500000, 'ForegroundPolarity', 'bright');
BW = imbinarize(X);
% Active contour
% iterations = 5;
% BW = activecontour(X, BW, iterations, 'edge');
% figure,imshow(BW),title('Binarisierung');
%% Close mask with square
width = 2; %5
se = strel('square', width);
BW = imclose(BW, se);

% Open mask with square
width = 2;% 5
se = strel('square', width);
BW = imopen(BW, se);
figure,imshow(BW),title('Morphologisch');
%% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

