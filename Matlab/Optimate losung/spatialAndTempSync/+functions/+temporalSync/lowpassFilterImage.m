function [ image_filtered ] = lowpassFilterImage( image, fil_lp)
%BANDPASSFILTERIMAGE Summary of this function goes here
%   Detailed explanation goes here
image_filtered = conv2(fil_lp, fil_lp, image, 'same');
% image_filtered = image;
filterSize = size(fil_lp,2);
image_filtered = image_filtered(:,filterSize+1:end-filterSize);
end

