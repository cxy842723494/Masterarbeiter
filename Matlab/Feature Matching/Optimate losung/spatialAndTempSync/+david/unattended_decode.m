function [bitbufferz] = unattended_decode(pics,fast,hblocks, vblocks,done,bitbufferz)
    if nargin<2 || isempty(fast)
        fast = false;
    end
    cpar = david.getUndistortPoints;
    Ndi = floor(size(pics,3)/2);
    if nargin<5 || isempty(done)
        done = zeros(1,Ndi);
        bitbufferz = [];
    end
    for index = 1:Ndi
        if done(index)
            continue
        end
        diffc_col = david.bayer2undcoldiffgpu(pics(:,:,2*index-[1 0]),cpar);
        diffc_col(:,:,2) = 0;
%         rgb2yuvT = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5000; 0.5000 -0.4542 -0.0458];
%         y = rgb2yuvT(1,1) * diffc_col(:,:,1) + rgb2yuvT(1,2) * diffc_col(:,:,2) + rgb2yuvT(1,3) * diffc_col(:,:,3);
%         u = rgb2yuvT(2,1) * diffc_col(:,:,1) + rgb2yuvT(2,2) * diffc_col(:,:,2) + rgb2yuvT(2,3) * diffc_col(:,:,3);
%         v = rgb2yuvT(3,1) * diffc_col(:,:,1) + rgb2yuvT(3,2) * diffc_col(:,:,2) + rgb2yuvT(3,3) * diffc_col(:,:,3);
%         diffc_col(:,:,1) = v;
%         diffc_col(:,:,2) = y;
%         diffc_col(:,:,3) = u;
        if ~fast || index == 1
            [Xzr,Yzr,blocksized,blocksizev, diffc_col]...
                = david.spatialSync(diffc_col,hblocks,vblocks);
            %disp(size(Xzr));
        end
%         diffc_col(:,:,1) = v;
%         diffc_col(:,:,2) = y;
%         diffc_col(:,:,3) = u;
        try
            [bitsz,numberz] = david.decodeFrame(diffc_col,Xzr,Yzr);
            try
                bitbufferz(:,:,numberz) = bitsz;
                disp(numberz);
                %All_X(:,:,index) = Xzr;
                %All_Y(:,:,index) = Yzr;
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

