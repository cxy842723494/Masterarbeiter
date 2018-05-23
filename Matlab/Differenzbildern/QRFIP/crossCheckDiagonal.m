function result = crossCheckDiagonal(bw, startI, centerJ, ...
                                maxCount, originalStateCountTotal)
% After a verticcal and horizontal scan finds a potential finder pattern,
% this method "cross-cross-cross-checks" by scanning down diagonally
% through the center of the possible finder pattern to see if the same
% proportion is detected.
%
% startI: row where a finder pattern was detected
% centerJ: center of the section that appears to cross a finder pattern
% maxCount: maximum reasonable number of modules that should be observed in
% any reading state, based on the results of the horizontal scan
% originalStateCountTotal: the original state count total
% result: true if proportions are withing expected limits

result = false;
stateCount = zeros(1, 5);

% Starting counting up, left from center finding black center mass
i = 1;
while (startI >= i && centerJ >= i && bw(startI-i+1, centerJ-i+1))
    stateCount(3) = stateCount(3) + 1;
    i = i + 1;
end
if (startI < i || centerJ < i)
    return;
end

% Continue up, left finding white space
while (startI >= i && centerJ >= i && ~bw(startI-i+1, centerJ-i+1) && ...
       stateCount(2) <= maxCount)
    stateCount(2) = stateCount(2) + 1;
    i = i + 1;
end
% If already too many modules in this state or ran off the edge
if (startI < i || centerJ < i || stateCount(2) > maxCount)
    return;
end

% Continue up, left finding black border
while (startI >= i && centerJ >= i && bw(startI-i+1, centerJ-i+1) && ...
       stateCount(1) <= maxCount)
    stateCount(1) = stateCount(1) + 1;
    i = i + 1;
end
if (stateCount(1) > maxCount)
    return;
end

maxI = size(bw, 1);
maxJ = size(bw, 2);

% Now also count down, right from center
i = 1;
while (startI + i <= maxI && centerJ + i <= maxJ && ...
       bw(startI + i, centerJ + i))
   stateCount(3) = stateCount(3) + 1;
   i = i + 1;
end
% Ran off the edge?
if (startI + i > maxI || centerJ + i > maxJ)
    return;
end

while (startI + i <= maxI && centerJ + i <= maxJ && ...
       ~bw(startI + i, centerJ + i) && stateCount(4) < maxCount)
   stateCount(4) = stateCount(4) + 1;
   i = i + 1;
end
% Ran off the edge?
if (startI + i > maxI || centerJ + i > maxJ || stateCount(4) >= maxCount)
    return;
end
   
while (startI + i <= maxI && centerJ + i <= maxJ && ...
       bw(startI + i, centerJ + i) && stateCount(5) < maxCount)
   stateCount(5) = stateCount(5) + 1;
   i = i + 1;
end
% Ran off the edge?
if (stateCount(5) >= maxCount)
    return;
end

% plot([centerJ-sum(stateCount(1:2))-stateCount(3)/2 centerJ+sum(stateCount(4:5))+stateCount(3)/2], ...
%     [startI-sum(stateCount(1:2))-stateCount(3)/2 startI+sum(stateCount(4:5))+stateCount(3)/2], ...
%      'r','LineWidth',2)
 
% If we found a finder-pattern-like section, but its size is more than 100%
% different than the original, assume it's a false positive
stateCountTotal = sum(stateCount);
if (abs(stateCountTotal - originalStateCountTotal) < ...
        2 * originalStateCountTotal) && foundPatternCross(stateCount) 
    result = true;
else
    disp('false positive')
end