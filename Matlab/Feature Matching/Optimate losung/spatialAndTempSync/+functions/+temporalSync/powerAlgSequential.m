function [ result, nextFrames ] = powerAlgSequential(y_gpu, u_gpu, v_gpu, nextFrames, nbPicturesTotal, nbFields, subsamplingFactor, result)

% Nb of Lines and coloumns per image
% nbLines_y = size(y_gpu,1);
nbLines_v = size(v_gpu,1);

%% Here it starts
% windowHeight_y = floor( nbLines_y / nbFields);
windowHeight_v = floor( nbLines_v / nbFields);
nbWindows = ceil(nbLines_v/windowHeight_v);

diffImageNb = size(result,2) + 1;

if diffImageNb >1
    minNextFrame = min(nextFrames);
else
    minNextFrame = 1;
end

% Iteration über alle Windows main loop
for i = 1 : nbWindows
    if (diffImageNb == 4 && i == 1)
        a = 3;
    end
    % Define the current Window j (vertical image direction) sample points
%     window_j_y = (i-1)*windowHeight_y+1 : i*windowHeight_y;
    window_j_v = (i-1)*windowHeight_v+1 : i*windowHeight_v;
    if i == nbWindows
%         window_j_y = (i-1)*windowHeight_y+1 : nbLines_y; 
        window_j_v = (i-1)*windowHeight_v+1 : nbLines_v;
    end
    
    % Calculate the base corresponding Frame
    nextFrame = nextFrames(i);
    nextFrameThisIteration = nextFrame - minNextFrame + 1;
    
    if diffImageNb == 1
        % First search must be bidirectional
        mapping = [-2 -1 1 2];
        
        % Phase Sync between the windows
        if i>1
            diffToPrev = result(1).differences(:,i-1)-nextFrame;
            %             if isequal(diffToPrev,[1 2]')
            if sum(diffToPrev) > 2
                nextFrame = nextFrame + 1;
                nextFrameThisIteration = nextFrame - minNextFrame + 1;
            elseif sum(diffToPrev) < -2
                nextFrame = nextFrame - 1;
                nextFrameThisIteration = nextFrame - minNextFrame + 1;
            end
        end
    else
        mapping = [1 2];
    end
    
    powerRatios_base = calcPowerRatios(nextFrameThisIteration, mapping,y_gpu, u_gpu, v_gpu);
    correspondingFrame_base = calcMatchingFrameThroughPowerRatios(powerRatios_base);

    % Search for better combination
    if diffImageNb == 1 || correspondingFrame_base ~= 1 % first search
        [res, correspondingFrame] = ...
            competitionSearch(powerRatios_base, correspondingFrame_base, nextFrameThisIteration, u_gpu, v_gpu);
    else % not first search AND base = 1
        correspondingFrame = correspondingFrame_base;
        res = [nextFrame; nextFrame+1];
    end
    result(diffImageNb).differences(:, i) = res;
    nextFrame_old = nextFrame;
    nextFrame = res(2) + 1; % max(res) + 1;
    
    % Check, if next Frame is right! (früher viele nicht so special cases)
    if res(2)-res(1) == 1 && sum(res-nextFrame_old) < 3  
        if res(2) + 1 < nbPicturesTotal-1 
            nextFrameToCheckThisIteration = nextFrame - minNextFrame + 1;
            powerRatios = calcPowerRatios(nextFrameToCheckThisIteration, [-2 1 2],y_gpu, u_gpu, v_gpu);
            correspondingFrameChroma = calcMatchingFrameThroughPowerRatios(powerRatios);
            
            if correspondingFrameChroma == -2
                nextFrame = nextFrame + 1;
            end
        end
    end
    
    nextFrames(i) = nextFrame;
end

    function [res, correspondingFrame, corrCoeffChroma_min] = ...
            competitionSearch(corrCoeffs_base, correspondingFrame_base, nextFrameThisIteration, u_gpu, v_gpu)
        % Search for better combination
        map = mapping == correspondingFrame_base;
        competitionFrame = nextFrameThisIteration + 1 - 2 * mod(find(map),2);
        competitionCheckDiff = nextFrameThisIteration+correspondingFrame_base-competitionFrame;
        if competitionFrame == 0
           a = 3; 
        end
%         corrCoeffs2 = calcCorrCoeffs(competitionFrame, competitionCheckDiff, v_bp_gpu, y_lp_gpu);
%         [correspondingFrame, corrCoeffChroma_min] = calcMatchingFrame([corrCoeffs_base(map,:); corrCoeffs2]);
%         [correspondingFrame, corrCoeffs2] = calcPowerRatios(competitionFrame, competitionCheckDiff, v_bp_gpu, y_lp_gpu);
        powerRatios2 = calcPowerRatios(competitionFrame, competitionCheckDiff,y_gpu, u_gpu, v_gpu);
        correspondingFrame = calcMatchingFrameThroughPowerRatios([ corrCoeffs_base(map,:); powerRatios2]);
        
        if correspondingFrame == correspondingFrame_base
            res = sort([nextFrame; nextFrame + correspondingFrame_base]);
        else
            idx = nextFrame + 1 - 2 * mod(find(map),2);
            res = sort([idx; idx + competitionCheckDiff]);
        end
    end

    function [powerRatios] = calcPowerRatios(frameNb, FramesToCheck, y, u, v)
        if i==10 && diffImageNb == 1
           a = 3; 
        end
        L = length(FramesToCheck);
        powerRatios = zeros(L,4);
        powerRatios(:, 1) = FramesToCheck;
        for k = 1 : L
            try
            diffImage_y = (y(window_j_v(1:subsamplingFactor:end), 1:subsamplingFactor:end, frameNb) - ...
                y(window_j_v(1:subsamplingFactor:end), (1:subsamplingFactor:end), frameNb+powerRatios(k, 1)));
            diffImage_u = (u(window_j_v(1:subsamplingFactor:end), 1:subsamplingFactor:end, frameNb) - ...
                u(window_j_v(1:subsamplingFactor:end), (1:subsamplingFactor:end), frameNb+powerRatios(k, 1)));
%             diffImage_v = (v(window_j_v(1:subsamplingFactor:end), 1:subsamplingFactor:end, frameNb) - ...
%                 v(window_j_v(1:subsamplingFactor:end), (1:subsamplingFactor:end), frameNb+powerRatios(k, 1)));
%             diffImage(abs(diffImage)<5) = 0;
%             diffSquare = diffImage.^2;
            diffAbs_y = abs(diffImage_y);
            diffAbs_u = abs(diffImage_u);
%             diffAbs_v = abs(diffImage_v);
              
            pow_y = mean2(diffAbs_y);   
            pow_u = mean2(diffAbs_u);
%             pow_v = mean2(diffAbs_v);
            
%             diffAbs_y_scaled = mat2gray(diffAbs_y);            
%             diffAbs_u_scaled = mat2gray(diffAbs_u);
%             diffAbs_v_scaled = mat2gray(diffAbs_v);
            
%             pow_y_scaled = mean2(diffAbs_y_scaled);            
%             pow_u_scaled = mean2(diffAbs_u_scaled);
%             pow_v_scaled = mean2(diffAbs_v_scaled);

            catch
               error('calc PowerRatio fehlgeschlagen');
            end
            try
                powerRatios(k,2) = gather(pow_u)^2/gather(pow_y);
                powerRatios(k,3) = gather(pow_u);
                powerRatios(k,4) = gather(pow_y);
                
            catch
                a = 3;
            end
        end
    end


    function [correspondingFrame] = calcMatchingFrameThroughPowerRatios(powerRatios)
        [maxi, posMaxi] = max(powerRatios(:,2));
        correspondingFrame = powerRatios(posMaxi, 1); 
    end


end

