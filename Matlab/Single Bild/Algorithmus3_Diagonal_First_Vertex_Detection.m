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
    
    % change the coordinate, the first column means x, the 2.colume means y    
    P1(:,1) = P(:,2);
    P1(:,2) = P(:,1);
    P =P1;     
    %% Algorithm.3 Diagonal_First_Vertex_Detection

    % input: a candidate shape P = {pi} i=1,2....n. , a n*2 matrix
    % output: v1,v2,v3 and v4, if yes, no otherweise
    
    % Step 1. computer v1,v2 by equation 9. 
    D = pdist(P);
    Z = squareform(D);
    m = max(D);    
    [x, y]=find(Z==max(D));
    index = [x(1,1),x(2,1)];
    
    v = [P(index,1),P(index,2)];
    v1 = v(1,:);
    v2 = v(2,:);   
    
    % Step 2. compute the third vertex v3
    % two criterion, first criterion, minimization of the dot production of normalized
    % v1p and v2p
    tic;
    A1 = minimizationdotproduction(v1,v2,P);
    index1 = find(A1==max(A1));
    v3 = [P(index1,1),P(index1,2)];
    toc;
    % second criterion, maximization of the sum of distances from a point p to v1 and
    % v2
    tic;
    A1 = maximizationdistances(v1,v2,P);
    index1 = find(A1==max(A1));
    v3 = [P(index1,1),P(index1,2)];
    toc;
    figure,imshow(Img),hold on;
    plot(v1(1,1),v1(1,2),'r.');
    plot(v2(1,1),v2(1,2),'r.');
    plot(v3(1,1),v3(1,2),'r.');   
    
    % Step 3. compute the fouth vertex v4
    % compute the centroid of the rectangle by v1 and v2, geometry property
    C = (v1+v2)/2;
    
    v4 = v3+2*(C-v3);
    
    % plot result
    v = [v1;v2;v3;v4];
    plot_rect(Img,v);
    