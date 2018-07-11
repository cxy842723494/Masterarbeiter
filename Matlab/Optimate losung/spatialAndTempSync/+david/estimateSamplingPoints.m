function [X,Y] = estimateSamplingPoints(borders,hblocks,vblocks)
    % This one is a bit rough, since it assumes perfect edge detection and
    % no depth distortion
    %% First, clean up inputs - we accept either a struct or a 2x4 matrix.
    if size(borders,2) == 4
        borders = struct('xleft',borders(:,1),'xright',borders(:,2),...
                         'yleft',borders(:,3),'yright',borders(:,4));
    end
    %% And vblocks are not mandatory
    if nargin < 3 || isempty(vblocks)
        vblocks = length(borders.xleft);
    end
    %% And now, try some linear interpolation between the provided edges.
    X = zeros(hblocks,vblocks);
    Y = zeros(hblocks,vblocks);
    for k=1:vblocks
        % Assuming the outer edges of the modulated region are also the
        % outer edges of the outermost blocks, we need to introduce an
        % offset of 0.5 blocks to sample at the block center. To do this,
        % we sample twice per block and discard the ones on the edges.
        temp = linspace(borders.xleft(k),borders.xright(k),hblocks*2+1);
        X(:,k) = temp(2:2:end);
        temp = linspace(borders.yleft(k),borders.yright(k),hblocks*2+1);
        Y(:,k) = temp(2:2:end);
    end
end