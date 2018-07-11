function cpar = getUndistortPoints
    cpar = load('+david/cameraParametersEVTZeiss.mat');
    Q = vision.internal.calibration.ImageTransformer;
    Q.update(ones(2160,3840,'single'),cpar.param.IntrinsicMatrix,...
                                    cpar.param.RadialDistortion,...
                                    cpar.param.TangentialDistortion,...
                                    'same',[1 3840],[1 2160]);
    cpar.Xq = Q.XmapSingle;
    cpar.Yq = Q.YmapSingle;
    clear Q;
end

