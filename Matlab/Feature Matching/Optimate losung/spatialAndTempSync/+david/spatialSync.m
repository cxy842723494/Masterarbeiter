function [Xz,Yz,blocksized,blocksizev, diffframe_g] = spatialSync(diffframe_g, hblocks, vblocks)
    diffc_r = gather(conv2([1],[1],diffframe_g(:,:,1),'same'));
%     diffc_r2 = gather(diffframe_g(:,:,1));

%     cr = david.estimateModCorners(diffc_r,1/2,7,10);

    % warpratio = 0.95, uv full hd
%     cr = [1920-48 1920-48 48 48;
%         1080-27 27 27 1080-27];
    % warpratio = 0.9, uv half full hd
%     cr = [(1920-96)/2 (1920-96)/2 96/2 96/2;
%           (1080-54)/2 54/2 54/2 (1080-54)/2];

    % warpratio = 0.9, uv full hd
    cr = [(1920-96) (1920-96) 96 96;
           (1080-54) 54 54 (1080-54)];

%     cr = [25 25 1873 1873;
%           14 1057 14 1057];
        
        %test start
%         diffc_b = gather(conv2([1 2 1]/2,[1 2 1]/2,diffframe_g(:,:,3),'same'));
%         xx = [cr(1,3) cr(1,2) cr(1,4) cr(1,1)];
%         yy = [cr(2,3) cr(2,2) cr(2,4) cr(2,1)];
%         wd = cr(1,2)-cr(1,3);
%         hd = wd/3840*2160;
%         u = [cr(1,3) cr(1,3)+wd cr(1,3) cr(1,3)+wd];
%         v = [cr(2,3) cr(2,3) cr(2,3)+hd cr(2,3)+hd];
%         Hmatrix = calcTransformMatrix(u, v, xx, yy);
%         Xq = zeros(size(diffc_r));
%         Yq = zeros(size(diffc_r));
%         for r = 1 : size(diffc_r, 1)
%             for c = 1 : size(diffc_r, 2)
%                 srcCoord = Hmatrix * [c r 1].';
%                 srcCoord = srcCoord / srcCoord(end);
%                 Xq(r, c) = srcCoord(1);
%                 Yq(r, c) = srcCoord(2);
%             end
%         end
%         diffc_r_c = interp2(diffc_r, Xq, Yq);
%         diffc_b_c = interp2(diffc_b, Xq, Yq);
%         wc = u(2)-u(1);
%         hc = v(3)-v(1);
%         bsH = wc/hblocks;
%         bsV = hc/vblocks;
%         Xqc = linspace(u(1)+bsH/2, u(2)-bsH/2, hblocks);
%         Yqc = linspace(v(1)+bsV/2, v(3)-bsV/2, vblocks);
%         [Xqc,Yqc] = meshgrid(Xqc,Yqc);
%         sampleR = interp2(diffc_r_c, Xqc, Yqc);
%         sampleB = interp2(diffc_b_c, Xqc, Yqc);
%         figure, scatter(sampleR(:), sampleB(:))
%         
%         diffframe_g(:,:,1) = diffc_r_c;
%         diffframe_g(:,:,3) = diffc_b_c;
%         test end
        
    er = david.estimateEdgePoints(cr,vblocks);
    [Xz,Yz,blocksized,blocksizev]...
        = david.findSamplingPoints_zone(diffc_r,er,[10000 5000], hblocks, vblocks);
   figure; imagesc(diffc_r); hold on; plot(Xz, Yz, 'xr');
end

