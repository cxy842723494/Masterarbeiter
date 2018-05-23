%% Code to find Scale and Rotation of Altered Image
tform = movingRegBRISK.Transformation;

tformInv = invert(tform);
Tinv = tformInv.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss+sc*sc);
theta_recovered = atan2(ss,sc)*180/pi;

figure,imshow(movingRegBRISK.RegisteredImage);

        [tformY, ~, ~] = estimateGeometricTransform(...
        [FIPx; FIPy].', [ux; vx].', 'projective');
    Yw(:,:,k) = imwarp(Y(:,:,k), tformY, 'OutputView', imref2d(size(Y(:,:,k))));
    
    [tformUV, ~, ~] = estimateGeometricTransform(...
        [FIPx/2; FIPy/2].', [ux/2; vx/2].', 'projective');
    Uw(:,:,k) = imwarp(U(:,:,k), tformUV, ...
        'OutputView', imref2d(size(U(:,:,k))));
    Vw(:,:,k) = imwarp(V(:,:,k), tformUV, ...
        'OutputView', imref2d(size(V(:,:,k))));
