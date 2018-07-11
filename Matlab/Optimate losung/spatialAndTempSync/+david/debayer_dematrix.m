function [picout] = debayer_dematrix(picin,mode,mosaic,dematrix)
%DEBAYER Summary of this function goes here
%   Detailed explanation goes here
if nargin<4 || isempty(dematrix);
    dematrix = false;
end
if nargin<3 || isempty(mosaic);
    r =[1 2];
    g1=[1 1];
    g2=[2 2];
    b =[2 1];
else
    r = mosaic(1,:);
    g1 = mosaic(2,:);
    g2 = mosaic(3,:);
    b = mosaic(4,:);
end
if nargin < 2 || isempty(mode);
    mode = 'sep';
end
sizex = size(picin,2);
sizey = size(picin,1);
switch(mode)
    case {'splitgreen','filtsplit'}
        picout = zeros(sizey,sizex,4,'single','gpuArray');
    otherwise
        picout = zeros(sizey,sizex,3,'single','gpuArray');
end
picout(r(1):2:end,r(2):2:end,1) = picin(r(1):2:end,r(2):2:end);
picout(b(1):2:end,b(2):2:end,3) = picin(b(1):2:end,b(2):2:end);
picout(g1(1):2:end,g1(2):2:end,2) = picin(g1(1):2:end,g1(2):2:end);
if size(picout,3) == 4
    picout(g2(1):2:end,g2(2):2:end,4) = picin(g2(1):2:end,g2(2):2:end);
else
    picout(g2(1):2:end,g2(2):2:end,2) = picin(g2(1):2:end,g2(2):2:end);
end
switch(mode)
    case 'boost'
        picout(:,:,1) = 2*picout(:,:,1);
        picout(:,:,3) = 2*picout(:,:,3);
    case 'nyquist'
        david.offsetfilter;
        picout(:,:,1) = conv2(picout(:,:,1),filt2d,'same');
        picout(:,:,3) = conv2(picout(:,:,3),filt2d,'same');
        picout(:,:,2) = conv2(picout(:,:,2),filtrot,'same');
    case 'filtsplit'
        david.offsetfilter;
        picout(:,:,1) = conv2(picout(:,:,1),filt2d,'same')*2;
        picout(:,:,3) = conv2(picout(:,:,3),filt2d,'same')*2;
        picout(:,:,2) = conv2(picout(:,:,2),filt2d,'same')+...
                        conv2(picout(:,:,4),filt2d,'same');
        picout(:,:,4) = [];
    otherwise
end
if and(dematrix,size(picout,3) == 3)
    %crossmat = [0.733736650452691 0.136531919669467 0.0528998592182492;...
    %            0.193681907863996 0.673520443447011 0.244811499871862;...
    %            0.0725814416833126 0.189947636883523 0.702288640909889];
%     crossmat = gpuArray([0.687276701980502 0.138702954861420 0.0858199774429931;...
%                 0.228231131335952 0.681527070492196 0.286673413278307;...
%                 0.0844921666835460 0.179769974646383 0.627506609278700]);
%             toc;
    decrossmatt = gpuArray(single([2.10619784527816 -0.283304900499487 0.0331859701091483
                                  -0.320478721018310 1.52717132545571 -0.397659227239187;
                                  -0.00288238622323776 -0.358340278314899 1.36336821422134].'));
    picout = reshape(reshape(picout,[],3)*decrossmatt,sizey,sizex,3);
end
end

