function res = haveMultiplyConfirmedCenters(possibleCenters)
% true if we have found at least 3 finder patterns that have been detected
% at least times each, and, the estimated module size of the candidates
% is "pretty similar"
res = false;
confirmedCount = 0;
totalModuleSize = 0;
maxC = numel(possibleCenters);
for k = 1 : maxC
    pattern = possibleCenters(k);
    if (pattern.count >= CENTER_QUORUM)
        confirmedCount = confirmedCount + 1;
        totalModuleSize = totalModuleSize + pattern.estimatedModuleSize;
    end
end
if (confirmedCount < 3)
    return;
end

% OK, we have at least 3 confirmed centers, but, it's possible that one is
% a "false positive" and that we need to keep looking. We detect this by
% asking if the estimated module sizes vary too much. We arbitrarily say
% that when the total deviation from average exceeds 5% of the total module
% size estimates, it's too much.
average = totalModuleSize / maxC;
totalDeviation = 0;
for k = 1 : maxC
    pattern = possibleCenters(k);
    totalDeviation = totalDeviation + ...
        abs(pattern.estimatedModuleSize - average);
end

if (totalDeviation <= 0.05 * totalModuleSize)
    res = true;
end