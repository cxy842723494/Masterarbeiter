function patternInfo = FinderPatternFinder(bw, tryHarder)

% figure, imshow(bw); hold on

MIN_SKIP = 1; %3; % 1 pixel/module times 3 modules/center
MAX_MODULES = 57; % support up to version 10

maxI = size(bw, 1);
maxJ = size(bw, 2);

possibleCenters = []; % Array of FinderPattern objects
hasSkipped = false;
% We are looking for black/white/black/white/black modules in
% 1:1:3:1:1 ratio, this tracks the number of such modules seen so far

% Let's assume that the maximum version QR Code we support takes up 1/4 the
% height of the image, and then account for the center being 3 modules in
% size. This gives the smallest number of pixels the center could be, so
% skip this often. When trying harder, look for all QR versions regardless
% of how dense they are.
iSkip = floor((3 * maxI) / (4 * MAX_MODULES));
if (iSkip < MIN_SKIP || tryHarder)
    iSkip = MIN_SKIP;
end

done = false;
stateCount = zeros(1, 5);
for i = iSkip : iSkip : maxI
    if done
        break;
    end
    stateCount = zeros(1, 5);
    currentState = 0;
    for j = 1 : maxJ
        if bw(i, j) % Black pixel
%             if (bitand(currentState, 1) == 1) % Counting white pixels
            if (mod(currentState, 2) == 1)
                currentState = currentState + 1;
            end
            stateCount(currentState+1) = stateCount(currentState+1) + 1;
        else % White pixel
%             if (bitand(currentState, 1) == 0) % Counting black pixels
            if (mod(currentState, 2) == 0)
                if (currentState == 4) % A winner?
                    if foundPatternCross(stateCount) % Yes
%                         plot(j, i, 'r.','MarkerSize',10)
%                         plot([j-sum(stateCount) j], [i i], 'r','LineWidth',2)
                        [confirmed, possibleCenters] = ...
                            handlePossibleCenter(bw, possibleCenters, ...
                            stateCount, i, j);
                        if (confirmed)
                            % Start examining every other line. Checking
                            % each line turned out to be too expensive
                            % and didn't imrpove performance
                            iSkip = 2;
                            if (hasSkipped)
                                done = haveMultiplyConfirmedCenter(...
                                    possibleCenters);
                            else
%                                 rowSkip = findRowSkip();
                                rowSkip = 0;
                                if (rowSkip > stateCount(3))
                                    % Skip rows between row of lower
                                    % confirmed center and top of presumed
                                    % third confirmed center but back up a
                                    % bit to get a full chance of detecting
                                    % it, entire width of center of finder
                                    % pattern
                                    
                                    % Skip by rowSkip, but back off by
                                    % stateCount(3) (size of last center of
                                    % pattern we saw) to be conservative,
                                    % and also back off by iSkip which is
                                    % about to be re-added
                                    i = i + rowSkip - ...
                                        stateCount(3) - iSkip;
                                    j = maxJ - 1;
                                end
                            end
                        else
                            stateCount(1) = stateCount(3);
                            stateCount(2) = stateCount(4);
                            stateCount(3) = stateCount(5);
                            stateCount(4) = 1;
                            stateCount(5) = 0;
                            currentState = 3;
                            continue;
                        end
                    
                        % Clear state to start looking again
                        currentState = 0;
                        stateCount = zeros(1, 5);
                    else % No, shift counts back by two
                        stateCount(1) = stateCount(3);
                        stateCount(2) = stateCount(4);
                        stateCount(3) = stateCount(5);
                        stateCount(4) = 1;
                        stateCount(5) = 0;
                        currentState = 3;
                    end
                else
                    currentState = currentState + 1;
                    stateCount(currentState + 1) = ...
                        stateCount(currentState + 1) + 1;
                end
            else % Counting white pixels
                stateCount(currentState + 1) = ...
                    stateCount(currentState + 1) + 1;
            end
        end
    end
end

if (foundPatternCross(stateCount))
    [confirmed, possibleCenters] = ...
        handlePossibleCenter(bw, possibleCenters, stateCount, i, j);
    if (confirmed)
        iSkip = stateCount(1);
        if (hasSkipped)
            % Found a third one
            done = haveMultiplyConfirmedCenters(possibleCenters);
        end
    end
end

patternInfo = selectBestPattern(possibleCenters);
% patternInfo = possibleCenters;

