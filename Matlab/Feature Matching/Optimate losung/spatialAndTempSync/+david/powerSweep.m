function [phase_0_center nbDiffPicsFor2Pi] = powerSweep(sweepFreq,plain_width)
    if nargin<2 || isempty(plain_width)
        plain_width=12;
    end
    if nargin<1 || isempty(sweepFreq)
        sweepFreq = 61;
    end
    % Assume base freq 60 Hz
    numFrames = 60/abs(sweepFreq-60)*2; % Might be more precise than this
    nbDiffPicsFor2Pi = numFrames/2;
    Sweeps = david.EVTC('Sweep',sweepFreq,numFrames);  
    SweepsGPU = gpuArray(Sweeps);

    diff_B = single(SweepsGPU(2:2:end, 1:2:end,1:2:end)) - single(SweepsGPU(2:2:end, 1:2:end,2:2:end));
%     diff_G = single(SweepsGPU(1:2:end, 1:2:end,1:2:end)) - single(SweepsGPU(1:2:end, 1:2:end,2:2:end));
    diff_B_2 = single(SweepsGPU(2:2:end, 1:2:end,2:2:end-1)) - single(SweepsGPU(2:2:end, 1:2:end, 3:2:end));

    P_B = zeros(1,size(diff_B,3),'single', 'gpuArray');
    P_B_2 = zeros(1,size(diff_B,3)-1,'single', 'gpuArray');
%     P_G = zeros(1,size(diff_G,3),'single', 'gpuArray');

    P_B(1:length(P_B)) = sum(sum(diff_B.^2,1),2);
    P_B_2(1:length(P_B_2)) = sum(sum(diff_B_2.^2,1),2);
%     P_G(1:length(P_G)) = sum(sum(diff_G.^2,1),2);
   
    
    [P_B_ext, plain, phase_opp_1] = david.findPlain(P_B, plain_width);
    % calc position of phase_zero_2
    if phase_opp_1 + plain_width > length(P_B_ext) - (nbDiffPicsFor2Pi/2 + 5)
        phase_opp_2 = phase_opp_1 - nbDiffPicsFor2Pi/2;
    else
        phase_opp_2 = phase_opp_1 + nbDiffPicsFor2Pi/2;
    end
       
    phase_opp_1_raw = gather(phase_opp_1) - plain_width;
    phase_opp_1_center = phase_opp_1_raw + round(plain_width/2);
    
    phase_opp_2_raw = gather(phase_opp_2) - plain_width;
    phase_opp_2_center = phase_opp_2_raw + round(plain_width/2);
    
    % Compare phases to find nearest
    if abs(phase_opp_1_center - (nbDiffPicsFor2Pi/2)) > abs(phase_opp_2_center - (nbDiffPicsFor2Pi/2))
        %phase_opp_1_center
        phase_0_center = phase_opp_1_center;
    else
        %phase_opp_2_center
        phase_0_center = phase_opp_2_center;
    end

%     phase_0 = phase_opp_1;
%     phase_0_raw = gather(phase_0) - plain_width;
%     phase_0_center = phase_0_raw + round(plain_width/2);

    if phase_0_center > nbDiffPicsFor2Pi
        phase_0_center = phase_0_center - nbDiffPicsFor2Pi; 
    elseif phase_0_center < 0
        phase_0_center = phase_0_center + nbDiffPicsFor2Pi;
    end
    
    
%{
    %% Plot for development 1
    figure;
  
    plot(P_B);
    figure;
    plot(P_B_2);
    figure; 
    plot([P_B(1:30) P_B_2(2:31)]);
%}
%     figure;
%     plot(P_B_ext);
% 
%     ax = gca;
%     line([plain_width plain_width],[ax.YLim(1),ax.YLim(2)], 'Color', [.7 .7 .7], 'Linestyle', '--');
%     line([nbDiffPicsFor2Pi+plain_width nbDiffPicsFor2Pi+plain_width],[ax.YLim(1),ax.YLim(2)], 'Linewidth', 2, 'Color', [.7 .7 .7], 'Linestyle', '--');
% 
%     line([phase_0 phase_0],[ax.YLim(1),ax.YLim(2)], 'Linewidth', 2, 'Color', [0 .7 0], 'Linestyle', '--');
%     line([phase_0 + plain_width phase_0 + plain_width],[ax.YLim(1),ax.YLim(2)],'Linewidth', 2,  'Color', [0 .7 0], 'Linestyle', '--');
% 
% 
%     line([phase_opp_2 phase_opp_2],[ax.YLim(1),ax.YLim(2)], 'Linewidth', 2, 'Color', [.7 0 0], 'Linestyle', '--');
%     line([phase_opp_2 + plain_width phase_opp_2 + plain_width],[ax.YLim(1),ax.YLim(2)],'Linewidth', 2,  'Color', [.7 0 0], 'Linestyle', '--');
%     figure; plot(P_B);
end

