function stopCamera(stream)
    if nargin < 1 || isempty(stream)
        stream = true;
    end
    if stream
        david.EVTC('StreamFRClose');
    end
    david.EVTC('C');
end