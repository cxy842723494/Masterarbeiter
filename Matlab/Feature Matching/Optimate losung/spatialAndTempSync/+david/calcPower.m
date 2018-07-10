function [ P_R, P_G, P_B ] = calcPower( Sweeps )
%CALCPOWER Summary of this function goes here
%   Detailed explanation goes here
sweep_R = double(Sweeps(2:2:end,1:2:end,:));
sweep_G = double(Sweeps(1:2:end, 1:2:end,:));
sweep_B = double(Sweeps(1:2:end,2:2:end,:));

% Calc. difference images
diff_R = zeros(1080,1920, size(Sweeps,3)/2);
diff_G = zeros(1080,1920, size(Sweeps,3)/2);
diff_B = zeros(1080,1920, size(Sweeps,3)/2);

for i=1:2:size(Sweeps,3)
    diff_R(:,:,ceil(i/2)) = double(sweep_R(:,:,i))-double(sweep_R(:,:,i+1));
    diff_G(:,:,ceil(i/2)) = double(sweep_G(:,:,i))-double(sweep_G(:,:,i+1));
    diff_B(:,:,ceil(i/2)) = double(sweep_B(:,:,i))-double(sweep_B(:,:,i+1));
end
% diff_Y = 0.2126*diff_R + 0.7152*diff_G + 0.0722*diff_B;

P_R = zeros(1,size(diff_R,3));
P_G = zeros(1,size(diff_G,3));
P_B = zeros(1,size(diff_B,3));
% P_Y = zeros(1,size(diff_Y,3));

P_R(1:length(P_R)) = sum(sum(diff_R.^2,1),2);
P_G(1:length(P_G)) = sum(sum(diff_G.^2,1),2);
P_B(1:length(P_B)) = sum(sum(diff_B.^2,1),2);
% P_Y(1:length(P_Y)) = sum(sum(diff_Y.^2,1),2);

end

