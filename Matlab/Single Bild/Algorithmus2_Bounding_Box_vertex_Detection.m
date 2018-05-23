    clean;
%     close all;
%% Input a candidate shape

    Img = imread('2-0.png');    
    Img = rgb2gray(Img);
    Img = imbinarize(Img);
    % figure,imshow(Img);

    [B,L] = bwboundaries(Img);
    
    imshow(Img); hold on;
    colors=['b' 'g' 'r' 'c' 'm' 'y'];
    for k=1:length(B)
      boundary = B{k};
      cidx = mod(k,length(colors))+1;
      plot(boundary(:,2), boundary(:,1),...
           colors(cidx),'LineWidth',2);
    
      % randomize text position for better visibility
      rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
      col = boundary(rndRow,2); row = boundary(rndRow,1);
      h = text(col+1, row-1, num2str(L(row,col)));
      set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
    end
    P = B{2,1};                                 % choose a candidate shape

 %% Algorithm.2 Bounding-Box Vertex Detection

    % input: a candidate shape P = {pi} i=1,2....n. , a n*2 matrix
    % output: v1,v2,v3 and v4
    % change the coordinate, the first column means x, the 2.colume means y    
    P1(:,1) = P(:,2);
    P1(:,2) = P(:,1);
    P =P1;     
    
    % Step 1. computer the centroid c(P)
    xmin = min(P(:,1));
    xmax = max(P(:,1));
    
    ymin = min(P(:,2));
    ymax = max(P(:,2));
    
    
    % 4 corner
    %   v2         v3  
    %  
    %
    %   
    %   v1         v4

    v1 = [xmin,ymax];
    v2 = [xmin,ymin];
    v3 = [xmax,ymin];
    v4 = [xmax,ymax];
    
    v = [v1;v2;v3;v4];
    centrP = [(xmin+xmax)/2,(ymin+ymax)/2];
    figure, imshow(Img,[]),hold on;
    plot(centrP(1,1),centrP(1,2),'r.')
    
    % Step 2. Centralization
    n = size(P,1);
    Pc = P - ones(n,1)*centrP;  
    plot(Pc(:,1),Pc(:,2),'r','LineWidth',2)
    
    [rectx,recty,area,perimeter] = minboundrect(P(:,1),P(:,2),'a');
    rect(:,1) = rectx;
    rect(:,2) = recty;
    rectn = rect(1:4,1);
    rectn(:,2) = rect(1:4,2);  
    
    % Step 3. Search theta to minimize area of the bounding box of PcUtheta
    Rectnc = rectn - ones(4,1)*centrP;
    A = Rectnc'*Rectnc;
    [V,D] = eig(A);
    [U1,D1,V1] = svd(A);
    
    % Step 4. rotate the centralized points
    Pcr = Pc*U1;
    Pcr = round(Pcr);
    plot(Pcr(:,1),Pcr(:,2));
    
    % Step 5-6 the bounding box of PcUtheta
    Rectncr = Rectnc*U1;
    plot(Rectncr(:,1),Rectncr(:,2), 'b', 'LineWidth', 2);
    plot([Rectncr(4,1) Rectncr(1,1)],[Rectncr(4,2) Rectncr(1,2)], 'b', 'LineWidth', 2);

    
    % Step 7. unrotate and uncentralized
    Rectreturn = Rectncr/U1 + ones(4,1)*centrP;
    figure,imshow(Img),hold on;
    plot(Rectreturn(:,1),Rectreturn(:,2),'g', 'LineWidth', 2);  
    plot([Rectreturn(4,1) Rectreturn(1,1)],[Rectreturn(4,2) Rectreturn(1,2)], 'g', 'LineWidth', 2);