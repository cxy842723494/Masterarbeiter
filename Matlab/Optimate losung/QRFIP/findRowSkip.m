function rowSkip = findRowSkip(possibleCenters)
% number of rows we could safely skip during scanning, based on the first
% two finder patterns that have been located. In some cases their position
% will allow us to infer that the third pattern must lie below a certain
% point farther down in the image

rowSkip = 0;
if (numel(possibleCenters) <= 1)
    return;
end

firstConfirmedCenter = 0;