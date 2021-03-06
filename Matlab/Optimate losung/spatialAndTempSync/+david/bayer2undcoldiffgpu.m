function [diffframe_g] = bayer2undcoldiffgpu(frames,cpar)
    diff = single(frames(:,:,1))-single(frames(:,:,2));
    diffc = david.debayer_dematrix(diff,'boost',[2 1;1 1;2 2;1 2],true);
    diffframe_g = cat(3,...
        interp2(diffc(:,:,1),cpar.Yq,cpar.Xq),...
        interp2(diffc(:,:,2),cpar.Yq,cpar.Xq),...
        interp2(diffc(:,:,3),cpar.Yq,cpar.Xq));
end

