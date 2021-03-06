function [ img ] = addQrFinderPattern( img, patternSize )
%ADDQRFINDERPATTERN Summary of this function goes here
%   Detailed explanation goes here

% qr_base= [
%     1 1 1 1 1 1 1 1 1;
%     1 -1 -1 -1 -1 -1 -1 -1 1;
%     1 -1 1 1 1 1 1 -1 1;
%     1 -1 1 -1 -1 -1 1 -1 1;
%     1 -1 1 -1 -1 -1 1 -1 1;
%     1 -1 1 -1 -1 -1 1 -1 1;
%     1 -1 1 1 1 1 1 -1 1;
%     1 -1 -1 -1 -1 -1 -1 -1 1;
%     1 1 1 1 1 1 1 1 1]; % Pattern with ration 1:1:1:3:1:1:1 in all direction;

qr_base= [
    1 1 1 1 1 1 1 1 1;
    1 0 0 0 0 0 0 0 1;
    1 0 1 1 1 1 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 1 1 1 1 0 1;
    1 0 0 0 0 0 0 0 1;
    1 1 1 1 1 1 1 1 1];

% qr_base = [
%        1 1 1 1 1 1 1 ;
%        1 0 0 0 0 0 1 ;
%        1 0 1 1 1 0 1 ;
%        1 0 1 1 1 0 1 ;
%        1 0 1 1 1 0 1 ;
%        1 0 0 0 0 0 1 ;
%        1 1 1 1 1 1 1 ; ]; % Pattern (noraml qr_code) with ratio 1:1:3:1:1 in all direction;


%  qr_base = [
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 1 1 1 1;
%      1 1 0 0 0 0 1 1;
%      1 1 0 0 0 0 1 1;
%      1 1 0 0 0 0 1 1;
%      1 1 0 0 0 0 1 1;
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 1 1 1 1]; % Pattern with ratio 1:2:1 in all direction;
 
% qr_base = [
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 1 1 1 1;
%      1 1 1 1 0 0 0 0;
%      1 1 1 1 0 0 0 0;
%      1 1 1 1 0 0 0 0;
%      1 1 1 1 0 0 0 0]; % Pattern with one empty corner 
 

qr = imresize(qr_base.*6, patternSize, 'nearest');  % qr_base.*15
% qr3 = cat(3,qr,qr,qr);
v = size(qr,1);
h = size(qr,2);

% Pattern at the corner
img(1:v,         1:h,        :) = qr;  
img(end-v+1:end, 1:h,        :) = qr;
img(1:v,         end-h+1:end,:) = qr;
img(end-v+1:end, end-h+1:end,:) = qr;

%Pattern move sth to the mittel of the image
% img(11:v+10,         11:h+10,        :) = qr;
% img(end-v-10+1:end-10, 11:h+10,        :) = qr;
% img(11:v+10,         end-h-10+1:end-10,:) = qr;
% img(end-v-10+1:end-10, end-h-10+1:end-10,:) = qr;

% img(1:v,         1:h,        :) = qr;
% img(end-v+1:end, 1:h,        :) = rot90(qr,1);
% img(end-v+1:end, end-h+1:end,:) = rot90(qr,2);
% img(1:v,         end-h+1:end,:) = rot90(qr,3); % Pattern with one corner 

end

