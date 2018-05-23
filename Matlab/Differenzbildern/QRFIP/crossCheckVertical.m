function centerI = crossCheckVertical(bw, startI, centerJ, ...
    maxCount, originalStateCountTotal)
% After a horizontal scan finds a potential finder pattern, this method
% "cross-checks" by scanning down vertically through the center of the
% possible finder pattern to see if the same proportion is detected.
%
% startI: row where a finder pattern was detected
% centerJ: center of the section that appears to cross a finder pattern
% maxCount: maximum reasonable number of modules that should be
% observed in any reading state, based on the results of the horizontal
% scan
% centerVert: vertical center of finder pattern or NaN if not found

centerI = nan;

maxI = size(bw, 1);
stateCount = zeros(1, 5);

% Starting counting up from center
i = startI;
while (i >= 1 && bw(i, centerJ))
    stateCount(3) = stateCount(3) + 1;
    i = i - 1;
end
if i <= 0
    return;
end
while (i >= 1 && ~bw(i, centerJ) && stateCount(2) <= maxCount)
    stateCount(2) = stateCount(2) + 1;
    i = i - 1;
end
% If already too many modules in this state or ran off the edge:
if (i <= 0 || stateCount(2) > maxCount)
    return;
end
while (i >= 1 && bw(i, centerJ) && stateCount(1) <= maxCount)
    stateCount(1) = stateCount(1) + 1;
    i = i - 1;
end
if (stateCount(1) > maxCount)
    return;
end

% Now also count down from center
i = startI + 1;
while (i <= maxI && bw(i, centerJ))
    stateCount(3) = stateCount(3) + 1;
    i = i + 1;
end
if (i > maxI)
    return;
end
while (i <= maxI && ~bw(i, centerJ) && stateCount(4) < maxCount)
    stateCount(4) = stateCount(4) + 1;
    i = i + 1;
end
if (i > maxI || stateCount(4) >= maxCount)
    return;
end
while (i <= maxI && bw(i, centerJ) && stateCount(5) < maxCount)
    stateCount(5) = stateCount(5) + 1;
    i = i + 1;
end
if (stateCount(5) >= maxCount)
    return;
end

% If we found a finder-pattern-like section, but its size is more than 40%
% different than the original, assume it's a false positive
stateCountTotal = sum(stateCount);
if (5 * abs(stateCountTotal - originalStateCountTotal) >= ...
        2 * originalStateCountTotal)
    return;
end

if foundPatternCross(stateCount) 
    centerI = centerFromEnd(stateCount, i);
    
%     plot([centerJ centerJ], [centerI-sum(stateCount(1:2))-stateCount(3)/2 centerI+sum(stateCount(4:5))+stateCount(3)/2], ...
%      'r','LineWidth',2)
end

