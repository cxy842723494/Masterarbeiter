function [ imagesOut ] = createDiffImages( images, result)
nbLines = size(images,1);
nbCol = size(images,2);
nbChannels = [];
if length(size(images)) == 4
    nbChannels = size(images,4);
else
    nbChannels = 1;
end
nbWindows = size(result(1).differences,2);
window_Height = floor( nbLines / nbWindows);

nbDiffImages = size(result,2);
if nbChannels == 1
    imagesOut = zeros(nbLines, nbCol, nbDiffImages, 'gpuArray');
else
    imagesOut = zeros(nbLines, nbCol, nbDiffImages, nbChannels, 'gpuArray');
end
%      display (nbDiffImages)
for currentDiffImage = 1:nbDiffImages % Diff-Image (outer) loop
    if currentDiffImage==3
       a = 3; 
    end
    ResultEqualForAllWindows = diff(result(currentDiffImage).differences,1, 2);
    if numel(ResultEqualForAllWindows(ResultEqualForAllWindows~=0)) == 0
        image_pos = result(currentDiffImage).differences(1,1);
        image_neg = result(currentDiffImage).differences(2,1);
        imagesOut(:,:, currentDiffImage,:) = images(:, :, image_pos, :)-...
            images(:, :, image_neg, :);
        
%         imagesOut(:,:,:,currentSingleImage) = images(:,:,:,image_pos);
%         imagesOut(:,:,:,currentSingleImage+1) = images(:,:,:,image_neg);
    else
        for windowId_ = 1:nbWindows % Window (inner) loop
            window_y = (windowId_-1)*window_Height+1:windowId_*window_Height;
            try
                image_pos = result(currentDiffImage).differences(1,windowId_);
                image_neg = result(currentDiffImage).differences(2,windowId_);
                imagesOut(window_y,:, currentDiffImage,:) = images(window_y, :, image_pos, :)-...
                    images(window_y, :, image_neg, :);
            catch
                display(windowId_)
                display(currentDiffImage)
                if (result(currentDiffImage).differences(1,windowId_)) == 0
                    imagesOut(window_y, :, currentDiffImage) = zeros(length(window_y), nbCol);
                    %                   display...  TODO: Ausgeben, wo die null steht
                end
            end
        end
    end
end
end

