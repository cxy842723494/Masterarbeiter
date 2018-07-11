function patternInfo = selectBestPattern(possibleCenters)

startSize = numel(possibleCenters);
if (startSize < 1)
    error('Could not find enough finder patterns')
end
    
% select best pattern
counts = zeros(1, startSize);
for k = 1 : startSize
    counts(k) = possibleCenters(k).count;
end

[~, idx] = max(counts);

patternInfo = possibleCenters(idx);