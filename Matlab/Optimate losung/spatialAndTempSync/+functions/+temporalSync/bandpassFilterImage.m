function [ image_filtered ] = bandpassFilterImage( image, fil_lp_1, fil_lp_2 )
%BANDPASSFILTERIMAGE Summary of this function goes here
%   Detailed explanation goes here
filterSize = size(fil_lp_1,2);
% image_filtered = imfilter(image, fil_lp_1'*fil_lp_1) - imfilter(image, fil_lp_2'*fil_lp_2);
image_filtered_1 = conv2(fil_lp_1, fil_lp_1, image, 'same');
image_filtered_2 = conv2(fil_lp_2, fil_lp_2, image, 'same'); 
image_filtered = image_filtered_1 - image_filtered_2;
% image_filtered = filter2(fil_lp_1'*fil_lp_1, image) - filter2(fil_lp_2'*fil_lp_2, image);
image_filtered = image_filtered(:,filterSize+1:end-filterSize);
end

