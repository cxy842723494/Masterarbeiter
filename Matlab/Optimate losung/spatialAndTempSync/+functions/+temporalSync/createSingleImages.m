function [ Yout, Uout, Vout ] = createSingleImages( Y, U, V, result)
nbLinesUV = size(U,1);
nbLinesY = size(Y,1);
% nbCol = size(images,2);
% nbChannels = [];

nbWindows = size(result(1).differences,2);
window_HeightUV = floor( nbLinesUV / nbWindows);
window_HeightY = floor( nbLinesY / nbWindows);

nbImages = size(result,2) * 2;


Yout = zeros(size(Y,1), size(Y,2),nbImages, 'gpuArray');
Uout = zeros(size(U,1), size(U,2),nbImages, 'gpuArray');
Vout = zeros(size(V,1), size(V,2),nbImages, 'gpuArray');

%      display (nbDiffImages)
for currentDiffImage = 1:nbImages/2 % Diff-Image (outer) loop
    ResultEqualForAllWindows = diff(result(currentDiffImage).differences,1, 2);
    if numel(ResultEqualForAllWindows(ResultEqualForAllWindows~=0)) == 0
        image_pos = result(currentDiffImage).differences(1,1);
        image_neg = result(currentDiffImage).differences(2,1);
        Yout(:,:, 2*currentDiffImage-1) = Y(:, :, image_pos);
        Yout(:,:, 2*currentDiffImage) = Y(:, :, image_neg);
        Uout(:,:, 2*currentDiffImage-1) = U(:, :, image_pos);
        Uout(:,:, 2*currentDiffImage) = U(:, :, image_neg);
        Vout(:,:, 2*currentDiffImage-1) = V(:, :, image_pos);
        Vout(:,:, 2*currentDiffImage) = V(:, :, image_neg);
        
%         imagesOut(:,:,:,currentSingleImage) = images(:,:,:,image_pos);
%         imagesOut(:,:,:,currentSingleImage+1) = images(:,:,:,image_neg);
    else
        for windowId_ = 1:nbWindows % Window (inner) loop
            window_y = (windowId_-1)*window_HeightY+1:windowId_*window_HeightY;
            window_uv = (windowId_-1)*window_HeightUV+1:windowId_*window_HeightUV;
            try
                image_pos = result(currentDiffImage).differences(1,windowId_);
                image_neg = result(currentDiffImage).differences(2,windowId_);
%                 imagesOut(window_y,:, 2*currentDiffImage-1,:) = images(window_y, :, image_pos, :);
%                 imagesOut(window_y,:, 2*currentDiffImage,:) = images(window_y, :, image_neg, :);
                Yout(window_y,:, 2*currentDiffImage-1) = Y(window_y, :, image_pos);
                Yout(window_y,:, 2*currentDiffImage) = Y(window_y, :, image_neg);
                Uout(window_uv,:, 2*currentDiffImage-1) = U(window_uv, :, image_pos);
                Uout(window_uv,:, 2*currentDiffImage) = U(window_uv, :, image_neg);
                Vout(window_uv,:, 2*currentDiffImage-1) = V(window_uv, :, image_pos);
                Vout(window_uv,:, 2*currentDiffImage) = V(window_uv, :, image_neg);
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

