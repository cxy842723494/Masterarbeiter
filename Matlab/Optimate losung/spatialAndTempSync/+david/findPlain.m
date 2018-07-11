function [P_B_ext, std_dev, phase_zero ] = findPlain( P_B, width )
diff = P_B(end) - P_B(1);
P_B_ext = [P_B(end-width+1:end)-diff P_B P_B(1:width)+diff];
% Calculate standard deviation
nbSamplePoints = length(P_B_ext);
windows_width = width;
steps = nbSamplePoints-windows_width+1;
std_dev = zeros(steps,1,'gpuArray');
for i=1:steps;
    std_dev(i) = sum(std(P_B_ext(i:i+windows_width-1)));  
end

% find Minimum
% phase_zero = find(std_dev==min(std_dev),1);
[~, phase_zero] = min(std_dev);
std_dev = std_dev/max(std_dev);
end

