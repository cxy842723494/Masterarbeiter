    clean;
%     close all;
%% Input a candidate shape

%     Img = imread('3.png');
    Img = imread('Unbenannt.jpg');
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
    P = B{3,1};                                 % choose a candidate shape


%% Algorithm.1 Removal of Outer Outliers

    % input: a candidate shape, a n*2 matrix
    % change the coordinate, the first column means x, the 2.colume means y    
    P1(:,1) = P(:,2);
    P1(:,2) = P(:,1);
    P =P1;                  

    n = size(P,1);  % caculate the number of the point in the candidate shape

    % find the Smallest rectangle of the candidate shape (regionprops)
    [rectx,recty,area,perimeter] = minboundrect(P(:,1),P(:,2),'a');
    rect(:,1) = rectx;
    rect(:,2) = recty;
    rectn = rect(1:4,1);
    rectn(:,2) = rect(1:4,2);
    
    figure,imshow(Img),hold on;
    plot(rectn(:,1),rectn(:,2), 'r', 'LineWidth', 2);
    plot([rectn(4,1) rectn(1,1)],[rectn(4,2) rectn(1,2)], 'r', 'LineWidth', 2);

    % use the smallest rectangle to make a rotate    
    all = zeros(1,2);
    for i = 1:2
        for j = 1:4
            all(i) = all(i) + rectn(j,i);
        end
    end
    rectnmean = all.*1/4;                       % 1.mean of P, a 1*2 matrix
    mean(rectn);
    Rectnc = rectn - ones(4,1)*rectnmean;       % 2.centralization
    A = Rectnc'*Rectnc;                         % 3.convariance , v-vector
    [U,D,V] = svd(A);                           % 4.svd-Singularly Valuable Decomposition
%     [V1,D1] = eig(A);                         % when Rectnc*V1 vertikal projection
%     [U2,D2,V2] = svd(Rectnc);
    Rectncr = Rectnc*U;    %V                   % 5.rotate centralized points (anticlokwise with original point)
    Rectncr = round(Rectncr);

    plot(Rectncr(:,1),Rectncr(:,2), 'b', 'LineWidth', 2);
    plot([Rectncr(4,1) Rectncr(1,1)],[Rectncr(4,2) Rectncr(1,2)], 'b', 'LineWidth', 2);
    
    % rotate the original image
    Pc = P - ones(n,1)*rectnmean; 
    plot(Pc(:,1),Pc(:,2));
    Pcr = Pc*U;  
    Pcr = round(Pcr);
    plot(Pcr(:,1),Pcr(:,2));
    
    % through shift x,y pixels to take off the negative value
    xmin=min(Pcr(:,1)); 
    ymin=min(Pcr(:,2));  

    Pcr1(:,1) = Pcr(:,1)-xmin+1;
    Pcr1(:,2) = Pcr(:,2)-ymin+1;
    plot(Pcr1(:,1),Pcr1(:,2));
    
    % 6.construct the projection of the object in horizontale richtung (h)
    Img1 = ones(max(Pcr1(:,2)),max(Pcr1(:,1)));
    figure,imshow(Img1);
    num = size(Pcr1,1);

    for i=1:num

        Img1(Pcr1(i,2),Pcr1(i,1)) = 0;

    end
    Img1 = logical(Img1);
    figure,imshow(Img1);

    [a,b] = size(Img1);
    h = a-sum(Img1,1);

    
%     h = zeros(1,b);
%     for i = 1:b
%         for j = 1:a
%             if Img(j,i)==0
%                 h(i) = h(i)+1;
%             end
%         end
%     end



    figure,bar(h),title('h');

    % 7.absolute derivation of h
    hdiff = zeros(1,b-1);
    for k=1:b-1
        
        hdiff(k) = abs(h(k+1)-h(k));

    end
    bar(hdiff),title('hdiff');    
    
    % step 8, compute j1,j2,j3,j4
    m=max(hdiff(1,:));                                  
    index=find(hdiff(1,:)==m);
    while numel(index)<4
       m=m-1; 
       index1=find(hdiff(1,:)==m);
       index = cat(2,index,index1);
    end
%     max_array=hdiff(1,index);
%     index = index(1:4);
    
    % step 9,10 
    jmin = min(index);
    jmax = max(index);
 
    % step 11    
    index1=find(Pcr1(:,1)<jmax & Pcr1(:,1)>jmin);
    
    Pnew = Pcr1(index1,:);
    
    
%     figure,imshow(Img1),hold on;
%     plot(Pnew(:,1),Pnew(:,2));        

    Pnew(:,1) = Pnew(:,1)+xmin-1;
    Pnew(:,2) = Pnew(:,2)+ymin-1;
%     plot(Pnew(:,1),Pnew(:,2));
    
    % Step 12        
    m = size(Pnew,1);                   
    
    % Step 13 recover
    Preturn = Pnew/U + ones(m,1)*rectnmean;
    figure,imshow(Img),hold on;
    plot(Preturn(:,1),Preturn(:,2));   









