function [result, diffImages, Y, U, V ] = temporalSyncSequential2( Y, U, V )
% BIS JETZT OHNE RESULT CORRECTION, klappt bei OLED - Google Pixel
% ?bertragungsstrecke erstmal ganz gut, Untersuchung f?r bewegte Bilder
% muss folgen (wenn Joern 4k Videos ans laufen gebracht hat)

% Parameters to set
nbWindows = 10;
% Y_threshold = 0.8;
% V_threshold = 0.1;
subSamplingFactor = 1; % Subsampling per x and y dimension

% fil_bp = fir1(64, [0.1 0.15]);
% fil_lp = fir1(64, 0.1);
fil_lp_1 = fir1(64, 0.1);
fil_lp_2 = fir1(64, 0.04);
fil_bp = fir1(64, [0.04 0.1]);

% Copy images to gpu
U_gpu = gpuArray(single(U));
V_gpu = gpuArray(single(V));
Y_gpu = 255*gpuArray(single(imresize(Y,0.5)));


% Bandpass on v to filter out the image content
% Lowpass on y to filter out the data pattern
% v_bp_gpu = imfilter(V_gpu, fil_lp_1'*fil_lp_1,'same') -  imfilter(V_gpu, fil_lp_2'*fil_lp_2,'same');
% v_bp_gpu = imfilter(V_gpu, fil_bp'*fil_bp,'same');
% y_lp_gpu = imfilter(Y_gpu, fil_lp_2'*fil_lp_2,'same');

nbPicturesTotal = size(Y,3);
nextFrames = 4*ones(1,nbWindows);

nbDiffImagesFound = 0;
while 1
    if nbDiffImagesFound == 0
        % First iteration, pass images 1:5
        firstFrameNb = 1;
        lastFrameNb = 9;
        result = [];
    else
        if max(nextFrames) > nbPicturesTotal - 2
            break;
        else
            firstFrameNb = min(nextFrames);
            lastFrameNb = min(max(nextFrames) + 5,nbPicturesTotal);
        end
    end
%     [result, nextFrames] = functions.temporalSync.corrAlgSequential2(y_lp_gpu(:,:,firstFrameNb:lastFrameNb),...
%         v_bp_gpu(:,:,firstFrameNb:lastFrameNb), nextFrames, nbPicturesTotal, nbWindows, Y_threshold, V_threshold, result);
    [result, nextFrames] = functions.temporalSync.powerAlgSequential(Y_gpu(:,:,firstFrameNb:lastFrameNb), ...
        U_gpu(:,:,firstFrameNb:lastFrameNb), V_gpu(:,:,firstFrameNb:lastFrameNb),...
        nextFrames, nbPicturesTotal, nbWindows, subSamplingFactor, result);

    nbDiffImagesFound = nbDiffImagesFound + 1;
end


% result = functions.temporalSync.resultCorrection(result);

s.numDiff = length(result);

diffImages_ = functions.temporalSync.createDiffImages(cat(4,V,U), result);
[Y, U, V] = functions.temporalSync.createSingleImages(Y,U,V, result);

% for i = 1:size(addedImages_,3)
%     addedImages(:,:,i) = imresize(addedImages_(:,:,i),0.5);
% end

% temporalSync.plotDiffImages(diffImages_(:,:,:,1), result); 
diffImages = permute(diffImages_, [1, 2, 4, 3]);
diffImages(:,:,3,:) = diffImages(:,:,2,:);



end

