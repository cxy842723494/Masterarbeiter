function [bitbufferz, sampledDataPatterns, sampleGrid, diffImageOrder] = unattended_decode_yuv(diffs,fast, hblocks, vblocks, done,bitbufferz)
    if nargin<2 || isempty(fast)
        fast = false;
    end
%     cpar = david.getUndistortPointsNexus5;
%     cpar = david.getUndistortPointsiPhone6sPlus;
%     Ndi = floor(size(pics,3)/2);
    Ndi = floor(size(diffs,4));
    if nargin<5 || isempty(done)
        done = zeros(1,Ndi);
        bitbufferz = [];
    end
    sampledDataPatterns = [];
    sampleGrid = [];
    diffImageOrder = [];
    for index = 1:Ndi
        if done(index)
            continue
        end
%         diffc_col = david.bayer2undcoldiffgpu(pics(:,:,2*index-[1 0]),cpar);
    
%         diffc_col = cat(3,...
%                         interp2(diffs(:,:,1,index),cpar.Xq,cpar.Yq),...
%                         interp2(diffs(:,:,2,index),cpar.Xq,cpar.Yq),...
%                         interp2(diffs(:,:,3,index),cpar.Xq,cpar.Yq));
%     
% %         diffc_col = diffc_col(470:2250, 60:3210, :);
%         diffc_col(isnan(diffc_col)) = 0;
        diffc_col = diffs(:,:,:,index);
        diffc_col = gpuArray(diffc_col);
        if ~fast || index == 1
            [Xzr,Yzr,blocksized,blocksizev]...
                = david.spatialSync(diffc_col,hblocks, vblocks);
            %disp(size(Xzr));
        end
        try
            % we set filterf = 1 to avoid blurring the u, v images
            [bitsz, picsampledzb, picsampledzr, numberz] = david.decodeFrame_Dec17(diffc_col,Xzr,Yzr,1);
            try
                bitbufferz(:,:,numberz) = bitsz;
                disp(numberz);
                %All_X(:,:,index) = Xzr;
                %All_Y(:,:,index) = Yzr;
                
                % Also store the received 2d data pattern in order to
                % locate the errors during the transmission
                sampledDataPatterns(:,:,numberz,1) = heaviside(picsampledzb');
                sampledDataPatterns(:,:,numberz,2) = heaviside(picsampledzr');
                
                sampleGrid(:,:,numberz,1) = Xzr;
                sampleGrid(:,:,numberz,2) = Yzr;
                
                % Store the diff Image order
                diffImageOrder(numberz) = index;
            catch e
                fprintf('Size mismatch in Frame %d\n',numberz);
                disp(e)
            end
        catch e
            disp(e);
            disp('Defective Frame');
        end
    end
    %save AllXY All_X All_Y   
end

