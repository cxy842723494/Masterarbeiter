function [res, possibleCenters] = ...
    handlePossibleCenter(bw, possibleCenters, stateCount, i, j)
% This is called when a horizontal scan finds a possible alignment pattern.
% It will cross check with a vertical scan, and if successful, will, ah,
% cross-cross-check with another horizontal scan. This is needed primarily
% to locate the real horizontal center of the pattern in cases of extreme
% skew. And then we cross-cross-cross check with another diagonal scan.
%
% Each additional find is more evidence that the location is in fact a
% finder pattern center
%
% possibleCenters: FinderPattern object which stores the possible centers 
% of finder patterns
% stateCount: reading state module counts from horizontal scan
% i: row where finder pattern may be found
% j: end of possible finder pattern in row
% return true if a finder pattern candidate was found this time

res = false;

stateCountTotal = sum(stateCount);
centerJ = centerFromEnd(stateCount, j);
centerI = crossCheckVertical(bw, i, floor(centerJ), ...
    stateCount(3), stateCountTotal);
if (~isnan(centerI))
    % Re-cross check
    centerJ = crossCheckHorizontal(bw, floor(centerJ), floor(centerI), ...
        stateCount(3), stateCountTotal);
%     if (~isnan(centerJ) && ...
%         crossCheckDiagonal(bw, floor(centerI), floor(centerJ), ...
%             stateCount(3), stateCountTotal))
     if (~isnan(centerJ))
        estimatedModuleSize = stateCountTotal / 7;
        found = false;
        for index = 1 : numel(possibleCenters)
            center = possibleCenters(index);
            % Look for about the same center and module size
            if (aboutEquals(center, estimatedModuleSize, centerI, centerJ))
                possibleCenters(index) = combineEstimate(center, ...
                    centerI, centerJ, estimatedModuleSize);
                found = true;
                break;
            end
        end
        if (~found)
            point = ...
                FinderPattern(centerJ, centerI, estimatedModuleSize, 1);
            possibleCenters = [possibleCenters point];
        end
        res = true;
    end
end