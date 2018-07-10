function result = foundPatternCross(stateCount)
% return true if the proprotions of the counts is close enough to
% the 1/1/3/1/1 ratios used by finder patterns to be considered a match
result = false;
totalModuleSize = 0;
for k = 1 : 5
    count = stateCount(k);
    if count == 0
        return
    end
    totalModuleSize = totalModuleSize + count;
end
if totalModuleSize < 7
    return
end
moduleSize = totalModuleSize / 7;
% Allow less than 50% variance from 1-1-3-1-1 proportions
% maxVariance = moduleSize / 2;
maxVariance = moduleSize / 1.6; 
result = (abs(moduleSize   - stateCount(1)) <   maxVariance) && ...
    (abs(moduleSize   - stateCount(2)) <   maxVariance) && ...
    (abs(3*moduleSize - stateCount(3)) < 3*maxVariance) && ...
    (abs(moduleSize   - stateCount(4)) <   maxVariance) && ...
    (abs(moduleSize   - stateCount(5)) <   maxVariance);
end