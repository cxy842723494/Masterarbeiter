% compute transformation projects from the matrices
T = maketform('projective',p0');


% determine the spatial extents of the images and the transformed images
[u,v] = meshgrid((1:size(Igray1,2)),(1:size(Igray1,1)));
uhat = H*[u(:)';v(:)';ones(1,numel(u))];
uhat = bsxfun(@rdivide,uhat,uhat(3,:));
uprimehat = Hprime*[u(:)';v(:)';ones(1,numel(u))];
uprimehat = bsxfun(@rdivide,uprimehat,uprimehat(3,:));
% image extents
min_u = min(u(:));
max_u = max(u(:));
min_v = min(v(:));
max_v = max(v(:));
% maximum area containing the whole transformed images
min_x_total = min(min(uhat(1,:)),min(uprimehat(1,:)));
max_x_total = max(max(uhat(1,:)),max(uprimehat(1,:)));
min_y_total = min(min(uhat(2,:)),min(uprimehat(2,:)));
max_y_total = max(max(uhat(2,:)),max(uprimehat(2,:)));
% minimum area contraining the overlap of the images
min_x_overlap = max(min(uhat(1,:)),min(uprimehat(1,:)));
max_x_overlap = min(max(uhat(1,:)),max(uprimehat(1,:)));
min_y_overlap = max(min(uhat(2,:)),min(uprimehat(2,:)));
max_y_overlap = min(max(uhat(2,:)),max(uprimehat(2,:)));
clear uhat uprimehat u v
% transform the images
I1rect_total = imtransform(I1,T,'XData',[min_x_total max_x_total],...
    'YData',[min_y_total max_y_total],'UData',[min_u max_u],...
    'VData',[min_v max_v],'XYScale',[1 1]);
I2rect_total = imtransform(I2,Tprime,'XData',[min_x_total max_x_total],...
    'YData',[min_y_total max_y_total],'UData',[min_u max_u],...
    'VData',[min_v max_v],'XYScale',[1 1]);
I1rect_overlap = imtransform(I1,T,'XData',[min_x_overlap max_x_overlap],...
    'YData',[min_y_overlap max_y_overlap],'UData',[min_u max_u],...
    'VData',[min_v max_v],'XYScale',[1 1]);
I2rect_overlap = imtransform(I2,Tprime,'XData',[min_x_overlap max_x_overlap],...
    'YData',[min_y_overlap max_y_overlap],'UData',[min_u max_u],...
    'VData',[min_v max_v],'XYScale',[1 1]);