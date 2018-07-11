function startCamera(stream)
    if nargin < 1 || isempty(stream)
        stream = true;
    end
    david.EVTC('O');
    david.EVTC('Set','OffsetY',0);
    david.EVTC('Set','OffsetX',0);
    david.EVTC('Set','Width',3840);
    david.EVTC('Set','Height',2160);
    david.EVTC('Set','FrameRate',60);
    david.EVTC('Set','Exposure',2500);
    david.EVTC('Set','OffsetY',456);
    david.EVTC('Set','OffsetX',128);
    if stream
        david.EVTC('StreamFR');
    end
end

