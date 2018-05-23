function [Bw]= AdaptiveThreshold(im,blockw,blockh)
    % this function is a simple local binariesung von christina. 

% fun = @(block_struct) abs(block_struct.data)>std(double(block_struct.data(:)))*adaptthresh(block_struct.data);
% Bw = blockproc(im,[blockw blockh],fun); 

fun = @(block_struct) abs(block_struct.data)>std(double(block_struct.data(:)))*graythresh(block_struct.data);
Bw = blockproc(im,[blockw blockh],fun); 

end
