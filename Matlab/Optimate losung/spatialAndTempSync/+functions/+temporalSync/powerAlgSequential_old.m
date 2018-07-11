function [ result, nextFrames ] = powerAlgSequential_old(y_gpu, v_gpu, nextFrames, nbPicturesTotal, nbFields, result )

% Nb of Lines and coloumns per image
nbLines_y = size(y_gpu,1);
nbLines_v = size(v_gpu,1);

%% Here it starts
windowHeight_y = floor( nbLines_y / nbFields);
windowHeight_v = floor( nbLines_v / nbFields);
nbWindows = ceil(nbLines_y/windowHeight_y);

diffImageNb = size(result,2) + 1;

if diffImageNb >1
    minNextFrame = min(nextFrames);
else
    minNextFrame = 1;
end

% Iteration über alle Windows main loop
for i = 1 : nbWindows
    
    % Define the current Window j (vertical image direction) sample points
    window_j_y = (i-1)*windowHeight_y+1 : i*windowHeight_y;
    window_j_v = (i-1)*windowHeight_v+1 : i*windowHeight_v;
    if i == nbWindows
        window_j_y = (i-1)*windowHeight_y+1 : nbLines_y; 
        window_j_v = (i-1)*windowHeight_v+1 : nbLines_v;
    end
    
    % Calculate the base corresponding Frame
    nextFrame = nextFrames(i);
    nextFrameThisIteration = nextFrame - minNextFrame + 1;
    
    if diffImageNb == 1
        % First search must be bidirectional
        mapping = [-2 -1 1 2];
    else
        mapping = [1 2];
    end
    
    if (i == 2)
        a = 3;
    end
    powerRatios_base = calcPowerRatios(nextFrameThisIteration, mapping, v_gpu, y_gpu);
    correspondingFrame_base = calcMatchingFrameThroughPowerRatios(powerRatios_base);

    % Search for better combination
    if nextFrame == 3 || correspondingFrame_base ~= 1 % first search
        [res, correspondingFrame] = ...
            competitionSearch(powerRatios_base, correspondingFrame_base, nextFrameThisIteration, v_gpu, y_gpu);
    else % not first search AND base = 1
        correspondingFrame = correspondingFrame_base;
        res = [nextFrame; nextFrame+1];
    end
    result(diffImageNb).differences(:, i) = res;
    nextFrame = res(2) + 1; % max(res) + 1;
    
    % special case:
    if correspondingFrame_base == 1 && correspondingFrame == 1
        % Check, whether +2 likes us more then it likes +3 or +4,
        % then next Frame is +3 (if there are still enough recordings)
        if nextFrame < nbPicturesTotal-1
%             corrCoeffs = calcCorrCoeffs(nextFrameThisIteration+2, [-2 1 2], v_gpu);
%             correspondingFrameChroma = calcMatchingFrame(corrCoeffs);
            powerRatios = calcPowerRatios(nextFrameThisIteration+2, [-2 1 2], v_gpu, y_gpu);
            correspondingFrameChroma = calcMatchingFrameThroughPowerRatios(powerRatios);
            if correspondingFrameChroma == -2
%                 if (corrCoeffs(2,2) - corrCoeffs(1,2)) > V_threshold
                    nextFrame = nextFrame + 1;
%                 end
            end
        end
    end
    
    nextFrames(i) = nextFrame;
end

    function [res, correspondingFrame, corrCoeffChroma_min] = ...
            competitionSearch(corrCoeffs_base, correspondingFrame_base, nextFrameThisIteration, v_bp_gpu, y_lp_gpu)
        % Search for better combination
        map = mapping == correspondingFrame_base;
        competitionFrame = nextFrameThisIteration + 1 - 2 * mod(find(map),2);
        competitionCheckDiff = nextFrameThisIteration+correspondingFrame_base-competitionFrame;
%         corrCoeffs2 = calcCorrCoeffs(competitionFrame, competitionCheckDiff, v_bp_gpu, y_lp_gpu);
%         [correspondingFrame, corrCoeffChroma_min] = calcMatchingFrame([corrCoeffs_base(map,:); corrCoeffs2]);
%         [correspondingFrame, corrCoeffs2] = calcPowerRatios(competitionFrame, competitionCheckDiff, v_bp_gpu, y_lp_gpu);
        powerRatios2 = calcPowerRatios(competitionFrame, competitionCheckDiff, v_bp_gpu, y_lp_gpu);
        correspondingFrame = calcMatchingFrameThroughPowerRatios([ corrCoeffs_base(map,:); powerRatios2]);
        
        if correspondingFrame == correspondingFrame_base
            res = sort([nextFrame; nextFrame + correspondingFrame_base]);
        else
            idx = nextFrame + 1 - 2 * mod(find(map),2);
            res = sort([idx; idx + competitionCheckDiff]);
        end
    end

    function [corrCoeffs] = calcCorrCoeffs(frameNb, FramesToCheck, varargin)
        L = length(FramesToCheck);
        corrCoeffs = zeros(L, 3);
        corrCoeffs(:, 1) = FramesToCheck;
        v = varargin{1};
        if length(varargin) == 2
            y = varargin{2};
            for k = 1 : L
                corrCoeffs(k, 2:3) = [gather(corr2(v(window_j_v, :, frameNb), v(window_j_v, :, frameNb+corrCoeffs(k, 1)))) ...
                    gather(corr2(y(window_j_y, :, frameNb), y(window_j_y, :, frameNb+corrCoeffs(k, 1))))];
            end
        elseif length(varargin) == 1
            for k = 1 : L
                corrCoeffs(k, 2) = gather(corr2(v(window_j_v, :, frameNb), v(window_j_v, :, frameNb+corrCoeffs(k, 1))));
            end
        end
    end

    function [correspondingFrame, corrCoeff] = calcMatchingFrame(corrCoeffs)
        % - A function to calculate the matching Frame, which is most likely the
        % corresponding to the current Frame (nextFrame), based on the
        % previously calculated corrCoeffs
        % - if corrCoeffs contains only one corrCoeff per corresponding frame
        % (size(corrCoeffs,2) == 2 ) we assume this is the U or V information
        % - otherwise it contains U or V and Y-information and we have to double
        % check it as described in the ppt. slides
        [~, maxIdx] = max((1-Y_threshold)*corrCoeffs(:,3)-corrCoeffs(:,2));
        correspondingFrame = corrCoeffs(maxIdx,1);
        corrCoeff = corrCoeffs(maxIdx, 2);
    end
    function [powerRatios] = calcPowerRatios(frameNb, FramesToCheck, v, y)
        L = length(FramesToCheck);
        powerRatios = zeros(L,2);
        powerRatios(:, 1) = FramesToCheck;
        for k = 1 : L
            %             powerRatios(k,2) = gather(mean2(  (  v(window_j_v, :, frameNb) - v(window_j_v, :, frameNb+powerRatios(k, 1))).^2) ./...
            %                 mean2(    (   y(window_j_y, :, frameNb) - y(window_j_y, :, frameNb+powerRatios(k, 1)) ).^2));
            if frameNb+powerRatios(k, 1) < frameNb
%                 powerRatios(k,2) = powerRatios(k,2) + ...
%                     gather ( corr2( v(window_j_v, :, frameNb+powerRatios(k, 1)),...
%                     v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb))) + ...
%                                         gather ( corr2( v(window_j_v, :, frameNb),...
%                     v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))  )   );
%                 powerRatios(k,2) = powerRatios(k,2) + ...
%                     gather ( corr2( v(window_j_v, :, frameNb+powerRatios(k, 1)),...
%                     (v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)).*...
%                     (v(window_j_v, :, frameNb+powerRatios(k, 1)) +   v(window_j_v, :, frameNb)) ));

%                 powerRatios(k,2) = powerRatios(k,2) + ...
%                     gather ( mean2( (v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)) ./ ...
%                     (v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))  ) ) );
                diffSquare = (v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)).^2;
                maxDiffSquare = max(max(diffSquare));
                powerRatios(k,2) = gather(   ((mean2(diffSquare)).^3)./maxDiffSquare   );
%                  powerRatios(k,2) = gather(mean2((v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)).^2));
            else
%                 powerRatios(k,2) = powerRatios(k,2) + ...
%                     gather ( corr2( v(window_j_v, :, frameNb),...
%                     v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))  )   ) + ...
%                     gather ( corr2( v(window_j_v, :, frameNb+powerRatios(k, 1)),...
%                     v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)));
%                 powerRatios(k,2) = powerRatios(k,2) + ...
%                     gather ( corr2( v(window_j_v, :, frameNb),...
%                     (v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))).*...
%                     (v(window_j_v, :, frameNb) +   v(window_j_v, :, frameNb+powerRatios(k, 1))) ));
%                 
%                    a = (v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))) ./ ...
%                     (v(window_j_v, :, frameNb+powerRatios(k, 1)) -   v(window_j_v, :, frameNb)  ) ;
%                 
%                    powerRatios(k,2) = powerRatios(k,2) + ... 
                diffSquare = (v(window_j_v, :, frameNb) -   v(window_j_v, :, frameNb+powerRatios(k, 1))).^2;
                maxDiffSquare = max(max(diffSquare));
                powerRatios(k,2) = gather(   ((mean2(diffSquare)).^3)./maxDiffSquare   );
            end
        end
        %      [maxi, posMaxi] = max(powerRatios(:,2));
        %      correspondingFrame = powerRatios(posMaxi, 1);
    end


    function [correspondingFrame] = calcMatchingFrameThroughPowerRatios(powerRatios)
        [maxi, posMaxi] = max(powerRatios(:,2));
        correspondingFrame = powerRatios(posMaxi, 1); 
    end


end

