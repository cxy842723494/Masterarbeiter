function borders = estimateEdgePoints(corners,vblocks,rotate)
    % Find the starting points on the left and right edges - initial
    % guesses for the data rows
    %%
    if nargin<3 || isempty(rotate)
        rotate = false;
    end
    %% First, order corners suitably: counterclockwise, starting at the top
    %  left. Note: the top/bottom axis may be mirrored compared to
    %  conventional viewing.
    if ~rotate
        [x,i] = sort(corners(1,:));
        y = corners(2,i);
        [y(1:2),i] = sort(y(1:2));
        x(1:2) = x(i);
        [y(4:-1:3),i] = sort(y(3:4));
        x(3:4) = x(5-i);
    else
        [y,i] = sort(corners(2,:));
        x = corners(1,i);
        [x(1:2),i] = sort(x(1:2));
        y(1:2) = y(i);
        [x(4:-1:3),i] = sort(x(3:4));
        y(3:4) = y(5-i);
    end
    %% Find row endpoints by linear interpolation.
    %  Assuming the outer edges of the modulated region are also the outer
    %  edges of the outermost blocks, we need to introduce an offset of 0.5
    %  blocks to sample at the block center. To do this, we sample twice
    %  per block and discard the ones on the edges.
    xleft = linspace(x(1),x(2),vblocks*2+1);
    borders.xleft = xleft(2:2:end);
    xright = linspace(x(4),x(3),vblocks*2+1);
    borders.xright = xright(2:2:end);
    yleft = linspace(y(1),y(2),vblocks*2+1);
    borders.yleft = yleft(2:2:end);
    yright = linspace(y(4),y(3),vblocks*2+1);
    borders.yright = yright(2:2:end);
end

