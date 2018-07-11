function centerJ = crossCheckHorizontal(bw, startJ, centerI, ...
                                        maxCount, originalStateCountTotal)
% Like crossCheckVertical, and in fact is basically identical,
% except it reads horizontally instead of vertically. This is used to
% cross-cross check a vertical cross check and locate the real center
% of the finder pattern

centerJ = nan;

maxI = size(bw, 2);
stateCount = zeros(1, 5);

% Starting counting up from center
j = startJ;
while (j >= 1 && bw(centerI, j))
    stateCount(3) = stateCount(3) + 1;
    j = j - 1;
end
if j <= 0
    return;
end
while (j >= 1 && ~bw(centerI, j) && stateCount(2) <= maxCount)
    stateCount(2) = stateCount(2) + 1;
    j = j - 1;
end
% If already too many modules in this state or ran off the edge:
if (j <= 0 || stateCount(2) > maxCount)
    return;
end
while (j >= 1 && bw(centerI, j) && stateCount(1) <= maxCount)
    stateCount(1) = stateCount(1) + 1;
    j = j - 1;
end
if (stateCount(1) > maxCount)
    return;
end

% Now also count down from center
j = startJ + 1;
while (j <= maxI && bw(centerI, j))
    stateCount(3) = stateCount(3) + 1;
    j = j + 1;
end
if (j > maxI)
    return;
end
while (j <= maxI && ~bw(centerI, j) && stateCount(4) < maxCount)
    stateCount(4) = stateCount(4) + 1;
    j = j + 1;
end
if (j > maxI || stateCount(4) >= maxCount)
    return;
end
while (j <= maxI && bw(centerI, j) && stateCount(5) < maxCount)
    stateCount(5) = stateCount(5) + 1;
    j = j + 1;
end
if (stateCount(5) >= maxCount)
    return;
end

% If we found a finder-pattern-like section, but its size is more than 40%
% different than the original, assume it's a false positive
stateCountTotal = sum(stateCount);
if (5 * abs(stateCountTotal - originalStateCountTotal) >= ...
      originalStateCountTotal)
    return;
end

if foundPatternCross(stateCount) 
    centerJ = centerFromEnd(stateCount, j);
end