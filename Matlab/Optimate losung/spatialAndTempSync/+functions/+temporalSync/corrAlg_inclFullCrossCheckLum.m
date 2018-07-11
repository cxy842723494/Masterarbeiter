function [result, v_gpu, v_bp_gpu, y_lp_gpu, windowHeight] = corrAlg_inclFullCrossCheckLum(y, u, v, fil_lp_1, fil_lp_2, nbFields)

v_gpu = imresize(gpuArray(single(v)),2,'cubic');
y_gpu = gpuArray(single(y));

% nb of images, Lines/coloumns per image
nbPictures = size(y_gpu,3)
nbLines = size(y_gpu,1);
nbCol = size(y_gpu,2);

filterSize = size(fil_lp_1,2);

% u_bp_gpu = single(zeros(size(u_gpu,1), size(u_gpu,2)-2*filterSize, 'gpuArray'));
v_bp_gpu = single(zeros(size(v_gpu,1), size(v_gpu,2)-2*filterSize, 'gpuArray'));
y_lp_gpu = single(zeros(size(y_gpu,1), size(y_gpu,2)-2*filterSize, 'gpuArray'));

fil_lp_1_gpu = gpuArray(fil_lp_1);
fil_lp_2_gpu = gpuArray(fil_lp_2);

for i=1:nbPictures
   v_bp_gpu(:,:,i) = functions.temporalSync.bandpassFilterImage(v_gpu(:,:,i),fil_lp_1_gpu, fil_lp_2_gpu);
   
   % Lowpass-filter the y image or not:
   y_lp_gpu(:,:,i) = functions.temporalSync.lowpassFilterImage(y_gpu(:,:,i), fil_lp_2_gpu);
%    y_lp_gpu(:,:,i) = y_gpu(:,filterSize+1:end-filterSize,i);
end

%% Here it starts
windowHeight = floor( nbLines / nbFields);
nbWindows = ceil(nbLines/windowHeight);
lastWindowHeight = mod(nbLines,windowHeight);

nbPictures = size(y,3);

table(3).differenceIn = zeros(2, nbWindows);

nextFrame = 3;
diffImagesFound = 0;

% result.differences stores the number of the recorded images, which are
% most likely the best recoreded frames for building the difference-images
% result.corrCoeffs stores the most strong negative
% corrlelation-coefficient and (NOT ANYMORE CORRECTLY!!!) the difference to number 2 (which provides
% information about the significance of the decision)
result = [];

windowIds = [ fliplr(1:floor(nbWindows/2)), floor(nbWindows/2)+1:nbWindows ]; 
% Iteration über alle Windows (äußere Schleife)
for i = 1:nbWindows
    windowId_tmp = windowIds(i);

    % Iteration über alle Bilder (innere Schleife)
    while nextFrame < nbPictures-1 
        if nextFrame == 3 && windowId_tmp == 1
            a = 3;
        end
        if i == nbWindows && lastWindowHeight > 0
            window_y = (windowId_tmp-1)*windowHeight+1:(windowId_tmp-1)*windowHeight + lastWindowHeight;
        else
            window_y = (windowId_tmp-1)*windowHeight+1:windowId_tmp*windowHeight;
        end
        if nextFrame == 3
            % First search must be bidirectional
            corrCoeffs_base = calcCorrCoeffs(nextFrame, [1 1 1 1], v_bp_gpu, y_lp_gpu);
            [correspondingFrame_base, corrCoeffChroma_min_base, delta_base] = calcMatchingFrame(corrCoeffs_base);
            
%             % exception at the beginning:
%             if correspondingFrame_base == 2
%                 % If this is the case at the beginning, results 2-1 is
%                 % always also a solution!
%                correspondingFrame_base = -2;  
%                corrCoeffChroma_min_base = 1;
%             end
        else
            corrCoeffs_base = calcCorrCoeffs(nextFrame, [0 0 1 1], v_bp_gpu, y_lp_gpu);
            [correspondingFrame_base, corrCoeffChroma_min_base, delta_base] = calcMatchingFrame(corrCoeffs_base);
        end
        diffImagesFound = diffImagesFound + 1; 
        
        % We have the base-result, now search, if there is maybe a better combination
        switch correspondingFrame_base
            case -2
                corrCoeffs = calcCorrCoeffs(nextFrame - 1, [0 1 0 0], v_bp_gpu, y_lp_gpu);
                [correspondingFrame, corrCoeffChroma_min, delta] =...
                    calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
                if correspondingFrame == -1
                    result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame-2, nextFrame-1]'; % result = 1-2;
                    result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
                else % correspondingFrame == -2
                    result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame-2, nextFrame]'; % result = 1-3;
                    result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
                end
                nextFrame = nextFrame + 1;    
            case -1 
                corrCoeffs = calcCorrCoeffs(nextFrame + 1, [1 0 0 0], v_bp_gpu, y_lp_gpu);
                [correspondingFrame, corrCoeffChroma_min, delta] =...
                    calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
                if correspondingFrame == -2
                        result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame-1, nextFrame+1]'; % result = 2-4;
                        result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';
                        
                        nextFrame = nextFrame + 2;
                else % correspondingFrame == -1
                    result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame-1, nextFrame]'; % result = 2-3;
                    result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';

                    nextFrame = nextFrame + 1;
                end
                               
            case 1
                if nextFrame == 3
                    corrCoeffs = calcCorrCoeffs(nextFrame - 1, [0 0 0 1], v_bp_gpu, y_lp_gpu);
                [correspondingFrame, corrCoeffChroma_min, delta] =...
                    calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
                else
                    correspondingFrame = correspondingFrame_base;
                    corrCoeffChroma_min = corrCoeffChroma_min_base;
                end
                    if  correspondingFrame == 2
                        result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame-1, nextFrame+1]'; % result = 2-4;
                        result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';

                        nextFrame = nextFrame + 2;
                    else
                        result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame, nextFrame+1]'; % result = 3-4;
                        result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';

                        nextFrame = nextFrame + 2; 

                        % Check, whether +2 likes us more then it likes +3 or +4, then next Frame is +3
                        if nextFrame < nbPictures-1 
                            corrCoeffs = calcCorrCoeffs(nextFrame, [1 0 1 1], v_bp_gpu);
                            [correspondingFrameChroma, corrCoeffChroma_min, delta] = calcMatchingFrame(corrCoeffs);

                        if correspondingFrameChroma == -2
                            corrCoeffs = calcCorrCoeffs(nextFrame, [1 0 1 0], v_bp_gpu);
                            if ( 1 - (corrCoeffs(1,2)/corrCoeffs(2,2)) < 0.5 )
                                nextFrame = nextFrame + 1;
                            end
                        end
                        end
                    end
                
            case 2
                corrCoeffs = calcCorrCoeffs(nextFrame + 1, [0 0 1 0], v_bp_gpu, y_lp_gpu);
                [correspondingFrame, corrCoeffChroma_min, delta] =...
                    calcMatchingFrame([corrCoeffs_base(corrCoeffs_base(:,1) == correspondingFrame_base,:); corrCoeffs]);
                if  correspondingFrame == 1
                    result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame+1, nextFrame+2]'; % result = 4-5;
                    result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min, corrCoeffChroma_min_base-corrCoeffChroma_min]';

                    nextFrame = nextFrame + 3;
                else
                    result(diffImagesFound).differences_v(:, windowId_tmp) = [nextFrame, nextFrame+2]'; % result = 3-5;
                    result(diffImagesFound).corrCoeffs_v(:,windowId_tmp) = [corrCoeffChroma_min_base, min(delta_base, corrCoeffChroma_min-corrCoeffChroma_min_base)]';
                    
                    nextFrame = nextFrame + 3;
                end
        end
    end

    nextFrame = 3;
    diffImagesFound = 0;
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
                        gather(corr2(frameSet1(window_y, :, frameNb), frameSet1(window_y, :, frameNb+mapping(i)))),...
                        gather(corr2(frameSet2(window_y, :, frameNb), frameSet2(window_y, :, frameNb+mapping(i))))];
                else
                    corrCoeffs = [corrCoeffs; mapping(i),...
                        gather(corr2(frameSet1(window_y, :, frameNb), frameSet1(window_y, :, frameNb+mapping(i))))];
                 end
            catch
                display(frameNb);
%                 display(FramesToCheck);
                display(window_y);
            end
        end
    end
end

function [correspondingFrame, corrCoeff, diffToSecond] = calcMatchingFrame(corrCoeffs)
    % - A function to calculate the matching Frame, which is most likely the
    % corresponding to the current Frame (nextFrame), based on the
    % previously calculated corrCoeffs
    % - if corrCoeffs contains only one corrCoeff per corresponding frame
    % (size(corrCoeffs,2) == 2 ) we assume this is the U/V information
    % - otherwise it contains U/V and Y-information and we have to double
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
            if (1-corrCoeffs(minIndex, 3)/corrCoeffLuma_max) > 0.5
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








