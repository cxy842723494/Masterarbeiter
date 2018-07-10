function center = centerFromEnd(stateCount, endIdx)
% Given a count of black/white/black/white/black pixels just seen
% and an end position, figures the location of the center of this run
center = (endIdx - stateCount(5) - stateCount(4)) - stateCount(3)/2;
