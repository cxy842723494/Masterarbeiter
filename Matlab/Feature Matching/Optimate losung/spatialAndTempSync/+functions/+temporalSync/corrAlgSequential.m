function [ result, nextFrames ] = corrAlgSequential(y_lp_gpu, v_bp_gpu, nextFrames, nbPicturesTotal, nbFields, Y_threshold, result )

% Nb of Lines and coloumns per image
nbLines_y = size(y_lp_gpu,1);
nbLines_v = size(v_bp_gpu,1);
nbCol_y = size(y_lp_gpu,2);

%% Here it starts
windowHeight_y = floor( nbLines_y / nbFields);
windowHeight_v = floor( nbLines_v / nbFields);
nbWindows = ceil(nbLines_y/windowHeight_y);
lastWindowHeight_y = mod(nbLines_y, windowHeight_y);
lastWindowHeight_v = mod(nbLines_v, windowHeight_v);


diffImageNb = size(result,2) + 1;

if diffImageNb >1
    minNextFrame = min(nextFrames);
else 
    minNextFrame = 1;
end
windowIds = [ fliplr(1:floor(nbWindows/2)), floor(nbWindows/2)+1:nbWindows ]; 
% Iteration über alle Windows
for i = 1:nbWindows
    
    % Define the current Window j (vertical image direction) sample points
    windowId_tmp = windowIds(i);
    if i == nbWindows && lastWindowHeight_y > 0
        window_j_y = (windowId_tmp-1)*windowHeight+1:(windowId_tmp-1)*windowHeight + lastWindowHeight;
    else
        window_j_y = (windowId_tmp-1)*windowHeight_y+1:windowId_tmp*windowHeight_y;
        window_j_v = (windowId_tmp-1)*windowHeight_v+1:windowId_tmp*windowHeight_v;
    end
    
    % Debugging
    if windowId_tmp == 2 
    end
    
    % Calculate the base corresponding Frame 
    nextFrame = nextFrames(windowId_tmp);
    nextFrameThisIteration = nextFrame - minNextFrame + 1;
    if diffImageNb == 1
        % First search must be bidirectional
        corrCoeffs_base = calcCorrCoeffs(nextFrameThisIteration, [1 1 1 1], v_bp_gpu, y_lp_gpu);
        [correspondingFrame_base, corrCoeffChroma_min_base, delta_base] = calcMatchingFrame(corrCoeffs_base);
    else
        corrCoeffs_base = calcCorrCoeffs(nextFrameThisIteration, [0 0 1 1], v_bp_gpu, y_lp_gpu);
        [correspondingFrame_base, corrCoeffChroma_min_base, delta_base] = calcMatchingFrame(corrCoeffs_base);
    end
    
    % We have the base-result, now search, if there is maybe a better combination
    switch correspondingFrame_base
        case -2
            corrCoeffs = calcCorrCoeffs(nextFrameThisIteration - 1, [0 1 0 0], v_bp_gpu, y_lp_gpu);
            [correspondingFrame, corrCoeffChroma_min, delta] =...
                calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
            if correspondingFrame == -1
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrameThisIteration-2, nextFrameThisIteration-1]'; % result = 1-2;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
            else % correspondingFrame == -2
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrameThisIteration-2, nextFrameThisIteration]'; % result = 1-3;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
            end
            nextFrameThisIteration = nextFrameThisIteration + 1;
        case -1
            corrCoeffs = calcCorrCoeffs(nextFrameThisIteration + 1, [1 0 0 0], v_bp_gpu, y_lp_gpu);
            [correspondingFrame, corrCoeffChroma_min, delta] =...
                calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
            if correspondingFrame == -2
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame-1, nextFrame+1]'; % result = 2-4;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
                
                nextFrame = nextFrame + 2;
            else % correspondingFrame == -1
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame-1, nextFrame]'; % result = 2-3;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
                
                nextFrame = nextFrame + 1;
            end
            
        case 1
            if nextFrame == 3
                corrCoeffs = calcCorrCoeffs(nextFrameThisIteration - 1, [0 0 0 1], v_bp_gpu, y_lp_gpu);
                [correspondingFrame, corrCoeffChroma_min, delta] =...
                    calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
            else
                correspondingFrame = correspondingFrame_base;
                corrCoeffChroma_min = corrCoeffChroma_min_base;
            end
            if  correspondingFrame == 2
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame-1, nextFrame+1]'; % result = 2-4;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
                
                nextFrame = nextFrame + 2;
            else
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame, nextFrame+1]'; % result = 3-4;
%                 result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
                
                nextFrameThisIteration = nextFrameThisIteration + 2;
                nextFrame = nextFrame + 2;
                
                % Check, whether +2 likes us more then it likes +3 or +4,
                % then next Frame is +3 (if there are still enough recordings)
                if nextFrame < nbPicturesTotal-1
                    corrCoeffs = calcCorrCoeffs(nextFrameThisIteration, [1 0 1 1], v_bp_gpu);
                    [correspondingFrameChroma, corrCoeffChroma_min, delta] = calcMatchingFrame(corrCoeffs);
                    
                    if correspondingFrameChroma == -2
                        corrCoeffs = calcCorrCoeffs(nextFrameThisIteration, [1 0 1 0], v_bp_gpu);
                        if ( 1 - (corrCoeffs(1,2)/corrCoeffs(2,2)) < Y_threshold )
                            nextFrame = nextFrame + 1;
                        end
                    end
                end
            end
            
        case 2
            corrCoeffs = calcCorrCoeffs(nextFrameThisIteration + 1, [0 0 1 0], v_bp_gpu, y_lp_gpu);
            [correspondingFrame, corrCoeffChroma_min, delta] =...
                calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
            if  correspondingFrame == 1
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame+1, nextFrame+2]'; % result = 4-5;
                result(diffImageNb).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
                
                nextFrame = nextFrame + 3;
            else
                result(diffImageNb).differences(:, windowId_tmp) = [nextFrame, nextFrame+2]'; % result = 3-5;
                result(diffImageNb).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
                
                nextFrame = nextFrame + 3;
            end
    end
    nextFrames(windowId_tmp) = nextFrame;
end



function [corrCoeffs] = calcCorrCoeffs(frameNb, FramesToCheck, varargin)
    % nargin should be one or two:
    %   - if one: varargin: U- or V-component, e.g. v_bp_gpu 
    %   - if two: varargin: U- or V-component and Y component, r.g. v_bp_gpu and y_gpu
    % "FramesToCheck" must be a 1x4 vector with 1s or 0s to define, if the
    % correlation to the images with numbers (relative to frameNb[-2 -1 +1 +2] shall be
    % computed! 
    % function returns the correlation coefficients in the form:
    % [correspondingFrame {-2,-1,1,2}, corrCoeff_U/V, corrCoeff_Y (optional)]
    if length(varargin) < 1
        error('Mindestens ein Frame-Set muss übergeben werden!')
    end
    mapping = [-2 -1 1 2];
    corrCoeffs = []; 
    for i=1:4
        if FramesToCheck(i) == 1
            try
                frameSet1 = varargin{1};
                if length(varargin) == 2
                    frameSet2 = varargin{2};
                    corrCoeffs = [corrCoeffs; mapping(i),...
                        gather(corr2(frameSet1(window_j_v, :, frameNb), frameSet1(window_j_v, :, frameNb+mapping(i)))),...
                        gather(corr2(frameSet2(window_j_y, :, frameNb), frameSet2(window_j_y, :, frameNb+mapping(i))))];
                else
                    corrCoeffs = [corrCoeffs; mapping(i),...
                    gather(corr2(frameSet1(window_j_v, :, frameNb), frameSet1(window_j_v, :, frameNb+mapping(i))))];
                 end
            catch
                error('CalcCorrCoeffs');
                display(frameNb);
%                 display(FramesToCheck);
%                 display(window_y);
            end
        end
    end

end

function [correspondingFrame, corrCoeff, diffToSecond] = calcMatchingFrame(corrCoeffs)
    % - A function to calculate the matching Frame, which is most likely the
    % corresponding to the current Frame (nextFrame), based on the
    % previously calculated corrCoeffs
    % - if corrCoeffs contains only one corrCoeff per corresponding frame
    % (size(corrCoeffs,2) == 2 ) we assume this is the U or V information
    % - otherwise it contains U or V and Y-information and we have to double
    % check it as described in the ppt. slides
    
    if nextFrame == 3 && windowId_tmp == 1
    end
    resultIndex = [];
    diffToSecond = -1;
    [corrCoeffChroma_min, minIndex] = min(corrCoeffs(:,2));
    correspondingFrameChroma = corrCoeffs(minIndex,1);
    if size(corrCoeffs,2) == 2 % Only chroma information available
        correspondingFrame = correspondingFrameChroma;
        corrCoeff = corrCoeffChroma_min; 
        resultIndex = minIndex;
    else  % ==3, analyse chroma and luma information
        [corrCoeffLuma_max, maxIndex] = max(corrCoeffs(:,3));
        correspondingFrameLuma = corrCoeffs(maxIndex,1);

        match = minIndex == maxIndex; % Do the Chroma and Luma Information match?

        if match
            correspondingFrame = correspondingFrameChroma;
            corrCoeff = corrCoeffChroma_min;
            resultIndex = minIndex;
        else
            % Calculate, how safe the luma information is
            if (1-corrCoeffs(minIndex, 3)/corrCoeffLuma_max) > Y_threshold
                % Luma info is safe => trust
                correspondingFrame = correspondingFrameLuma;
                corrCoeff = corrCoeffs(maxIndex, 2);
                resultIndex = maxIndex;
            else
                % not safe, trust chroma
                correspondingFrame = correspondingFrameChroma;
                corrCoeff = corrCoeffChroma_min;
                resultIndex = minIndex;
            end
        end
    end
    if size(corrCoeffs,1) > 1
    corrCoeffs_remaining = corrCoeffs;
    corrCoeffs_remaining(resultIndex,:) = [];
    diffToSecond = min(corrCoeffs_remaining(:,2)) - corrCoeffs(resultIndex, 2);
    else
        diffToSecond = -1;
    end
end

end

