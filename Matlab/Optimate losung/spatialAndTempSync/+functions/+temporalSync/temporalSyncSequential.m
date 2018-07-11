function [result, diffImages ] = temporalSyncSequential( Y, U, V )
% BIS JETZT OHNE RESULT CORRECTION, klappt bei OLED - Google Pixel
% Übertragungsstrecke erstmal ganz gut, Untersuchung für bewegte Bilder
% muss folgen (wenn Joern 4k Videos ans laufen gebracht hat)

% Parameters to set
nbWindows = 10;
Y_threshold = 0.8;

% fil_bp = fir1(64, [0.1 0.15]);
% fil_lp = fir1(64, 0.1);
fil_lp_1 = fir1(64, 0.15);
fil_lp_2 = fir1(64, 0.1);

% Copy images to gpu
V_gpu = gpuArray(single(V));
Y_gpu = gpuArray(single(Y));

% Bandpass on v to filter out the image content
% Lowpass on y to filter out the data pattern
v_bp_gpu = imfilter(V_gpu, fil_lp_1'*fil_lp_1,'same') -  imfilter(V_gpu, fil_lp_2'*fil_lp_2,'same');
y_lp_gpu = imfilter(Y_gpu, fil_lp_2'*fil_lp_2,'same');
% v_bp_gpu = V_gpu;
% y_lp_gpu = Y_gpu;
nbPicturesTotal = size(Y,3);
finished = false;
nextFrames = 3*ones(1,nbWindows);

Y_threshold = 0.8;

nbDiffImagesFound = 0;
while 1
    if nbDiffImagesFound == 0
        % First iteration, pass images 1:5
        firstFrameNb = 1;
        lastFrameNb = 7;
        result = [];
    else
        if max(nextFrames) > nbPicturesTotal - 2
            break;
        else
            firstFrameNb = min(nextFrames);
            lastFrameNb = min(max(nextFrames) + 4, size(Y,3));
        end
    end
    [result, nextFrames] = functions.temporalSync.corrAlgSequential(y_lp_gpu(:,:,firstFrameNb:lastFrameNb),...
        v_bp_gpu(:,:,firstFrameNb:lastFrameNb), nextFrames, nbPicturesTotal, nbWindows, Y_threshold, result);
    nbDiffImagesFound = nbDiffImagesFound + 1;
end


% result = functions.temporalSync.resultCorrection(result);

s.numDiff = length(result);

diffImages_ = functions.temporalSync.createDiffImages(cat(4,V,U), result);
% functions.temporalSync.plotDiffImages(diffImages_(:,:,:,1), result); 
diffImages = permute(diffImages_, [1, 2, 4, 3]);
diffImages(:,:,3,:) = diffImages(:,:,2,:);


end

