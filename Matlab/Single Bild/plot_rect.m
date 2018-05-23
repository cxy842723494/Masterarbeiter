function plot_rect(Img,v)

%     rect(:,1) = rectx;
%     rect(:,2) = recty;
%     rectn = rect(1:4,1);
%     rectn(:,2) = rect(1:4,2);   
%     cr = rectn.';
    cr = v.';
    [y,i] = sort(cr(2,:));
    x = cr(1,i);
    [x(1:2),i] = sort(x(1:2));
    y(1:2) = y(i);
    [x(4:-1:3),i] = sort(x(3:4));
    y(3:4) = y(5-i);

    figure, imshow(Img,[]),hold on;

    plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
    plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
    plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
    plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)
    
    
%     plot(rect(1,1),rect(1,2),'b.');
%     plot(rect(2,1),rect(2,2),'b.');
%     plot(rect(3,1),rect(3,2),'b.');
%     plot(rect(4,1),rect(4,2),'b.');

end
