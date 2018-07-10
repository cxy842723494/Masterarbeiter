function temporalSync(sweepFreq,plain_width)
%     [P,N] = powerSweep(sweepFreq,plain_width);
    [P,N] = david.powerSweep_halfNbFrames(sweepFreq,plain_width);
    david.phaseShift(P,N,sweepFreq);
end

