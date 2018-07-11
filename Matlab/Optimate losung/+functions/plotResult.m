 function [] = plotResult(cr)
    cr = cr.';
    [y,i] = sort(cr(2,:));
    x = cr(1,i);
    [x(1:2),i] = sort(x(1:2));
    y(1:2) = y(i);
    [x(4:-1:3),i] = sort(x(3:4));
    y(3:4) = y(5-i);
    
    plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
    plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
    plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
    plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)
    
end 