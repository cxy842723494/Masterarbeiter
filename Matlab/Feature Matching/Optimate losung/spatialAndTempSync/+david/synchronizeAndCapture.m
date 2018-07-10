function [pics] = synchronizeAndCapture(frames,sweepFreq)
    if nargin<2 || isempty(sweepFreq)
        sweepFreq = 61;
    end
    david.startCamera;
    david.temporalSync(sweepFreq,12);
    pics = david.EVTC('Sweep',60,frames);
    david.stopCamera;
    dp1 = int16(pics(:,:,1))-int16(pics(:,:,2));
    dp2 = int16(pics(:,:,2))-int16(pics(:,:,3));
    isSecond = david.phase180(dp1,dp2);
    pics = pics(:,:,1+isSecond:end);
end

