function phaseShift(phase_0_center, nbDiffPicsFor2Pi, sweepFreq)
%phase_0_center
inverseSweepFreq = 2*60-sweepFreq;
offset = 3;
if phase_0_center > offset + 1 && phase_0_center < nbDiffPicsFor2Pi + offset - 2
    if phase_0_center >= offset && phase_0_center < nbDiffPicsFor2Pi/2 + offset
        david.EVTC('Sweep',sweepFreq,2*phase_0_center - offset);
    elseif phase_0_center >= nbDiffPicsFor2Pi/2 + offset
        david.EVTC('Sweep',inverseSweepFreq,2*(nbDiffPicsFor2Pi-phase_0_center) + offset);
    elseif phase_0_center < offset
        david.EVTC('Sweep',inverseSweepFreq,2*phase_0_center);
    end
end
end

