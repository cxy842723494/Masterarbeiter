function [Pmean]=bounding_box_centroid(P)    
% centroid use the bounding-box centroid
    [rectx,recty] = minboundrect(P(:,1),P(:,2),'a');
    rect(:,1) = rectx;
    rect(:,2) = recty;
    rectn = rect(1:4,1);
    rectn(:,2) = rect(1:4,2);
    Pmean = mean(rectn);
    
%     figure,imshow(Img),hold on;
%     plot(rectn(:,1),rectn(:,2), 'r', 'LineWidth', 2);
%     plot([rectn(4,1) rectn(1,1)],[rectn(4,2) rectn(1,2)], 'r', 'LineWidth', 2);
%     plot(Pmean(:,1),Pmean(:,2), 'r.');