
clean;
% load('diffc_Uin.mat') 
% handles.Img=diffc_U.*255;

load('diffc_V');
handles.Img = diffc_V;

% [m,n] = size(handles.Img);
% when image is rgb forum, do step rgb2gray.

%monophologie_open oder close
% MN=[3,3];
% SE1=strel('rectangle',MN); 
% handles.norImg = imerode(handles.Img,SE1);
% handles.bw = bwmorph(handles.bw,'close');
% Bw=bwareaopen(handles.bw1,50,4);% delete some area which the size is smaller than 50

%% binariesierung _ local bina or globale bina
handles.Bw = imbinarize(handles.Img); 
handles.Bw1= not(handles.Bw);

figure,imshow(handles.Bw);
figure,imshow(handles.Bw1);
% handles.Bw1= 1-handles.Bw;% bw image, i.e 1 is object and 0 background
%% morphological operation_open oder close

%  handles.morpho = imopen(handles.Bw,ones(10));
%  figure,imshow(handles.morpho);
%  handles.morpho1 = imopen(handles.Bw1,ones(10));
%  figure,imshow(handles.morpho1);
%  handles.morpho = handles.morpho|handles.morpho1;         %   anpassing for die real time,not pass for idealo situation
%  figure,imshow(handles.morpho);

handles.morpho = imclose(handles.Bw,ones(10));              %   the result is different with first
handles.morpho = imopen(handles.morpho,ones(10));           %   dilate and then erode 
figure,imshow(handles.morpho);  
% handles.morpho = imdilate(handles.Bw,ones(10));           % close operation 
% handles.morpho = imerode(handles.morpho,ones(10));
% figure,imshow(handles.morpho);
% handles.morpho = imerode(handles.morpho,ones(10));        % open operation 
% handles.morpho = imdilate(handles.morpho,ones(10));
% figure,imshow(handles.morpho);

handles.morpho1 = imclose(handles.Bw1,ones(10));
handles.morpho1 = imopen(handles.morpho1,ones(10));
figure,imshow(handles.morpho1);
% handles.morpho1 = imdilate(handles.Bw1,ones(10));         % close operation 
% handles.morpho1 = imerode(handles.morpho1,ones(10));
% figure,imshow(handles.morpho1);
% handles.morpho1 = imerode(handles.morpho1,ones(10));      % open operation 
% handles.morpho1 = imdilate(handles.morpho1,ones(10));
% figure,imshow(handles.morpho1);

handles.morpho = handles.morpho&not(handles.morpho1);       %%  and & to or  | is also good
figure,imshow(handles.morpho);


%% edge detection
%handles.edge = edge(handles.norImg,'canny');

%%  counter detection 
tic;
[B,L,N,A] = bwboundaries(handles.morpho);
toc;
%S = regionprops(L, 'Area');            % compute how many pixels in each area 
STATS = regionprops(L, 'all');
[m,n] = size(STATS);                        % compute the number of object area
j = 1;
K = L;
for i =1:m
    if ( STATS(i,1).Area>300)
[rows,cols] = size(STATS(i,1).ConvexImage); % compute the wide and height of each area
 if(abs(double(rows/cols)-1)<0.15)          % find some area which wide equal to height? ?
Area = STATS(i,1).Area;
if(abs(double(Area/rows/cols)-1)<0.15)      % find some area which wide equal to height and area equal to wide multiply by height
    data1(j,1) = i;                         % assume index(j,1) equal to i
    data1(j,2) = STATS(i,1).Centroid(1);    % assume index(j,2) equal to the centroid coordinates in X axis
    data1(j,3) = STATS(i,1).Centroid(2);    % assume index(j,3) equal to the centroid coordinates in Y axis
j=j+1;
end
end

end
end
data1

%according the characteristics of finder pattern of 1:1:3:1:1 to position
%QR code area
[m,n]=size(L); %compute wide and height of L 
result = zeros(m,n);% create a black image, the wide and height is equal to L
 
for i = 1:4
 [r,c] = find(L==data1(i,1)); % find the rows and columns of each square, then we can know the four points coordinates for any square 
result(r(:),c(:))=data1(i,1);% position and show this three squares in the black image
end
[r1,c1] = size(STATS(data1(1,1),1).ConvexImage);% compute the size of three square
[r2,c2] = size(STATS(data1(2,1),1).ConvexImage);
[r3,c3] = size(STATS(data1(3,1),1).ConvexImage);
handles.x1 = data1(1,3)-r1*7/6;%compute the edge coordinates of finder pattern. 
handles.y1 = data1(1,2)-c1*7/6;%because of finder pattern is a 7 units of 1:1:3:1:1 square
handles.x2 = data1(2,3)+r3*7/6;%so the distance from centroid to edge is 3.5 units. the r,c is the size of small square in finder pattern
handles.y2 = data1(3,2)+c2*7/6;%r,c are all 3 units, so r*3.5/3 is the true distance value from centroid to edge
 
QR = handles.Img(handles.x1:handles.x2,handles.y1:handles.y2,:);%according the edge coordinates of finder pattern to segment the QR code 

figure;imshow(handles.Img);title('original image');
% figure;imshow(handles.grayImg);title('gray image');
figure;imshow(handles.Bw1);title('binary image'); hold on;
% %   Overlay Region Boundaries on Image and Annotate with Region Numbers
% colors=['b' 'g' 'r' 'c' 'm' 'y'];
% for k=1:length(B),
%   boundary = B{k};
%   cidx = mod(k,length(colors))+1;
%   plot(boundary(:,2), boundary(:,1),...
%        colors(cidx),'LineWidth',2);
% 
%   %randomize text position for better visibility
%   rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
%   col = boundary(rndRow,2); row = boundary(rndRow,1);
%   h = text(col+1, row-1, num2str(L(row,col)));
%   set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
% end

% figure;imshow(handles.edge);title('edge detection');
figure;imshow(result);title('position image');
figure;imshow(QR);title('result image');
%%  Overlay Region Boundaries on Image
% [B,L] = bwboundaries(handles.bw1,'noholes');
% contour1 = bwboundaries(handles.bw1);
% % contour2 = bwboundaries(Bw,8);
%  imshow(label2rgb(L, @jet, [.5 .5 .5]))
% 
% hold on
% 
% for k = 1:length(contour1)
%    boundary = contour1{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end

 %% Overlay Region Boundaries on Image and Annotate with Region Numbers
%  [B,L,N,A] = bwboundaries(Bw);
%  
%  imshow(Bw); hold on;
% colors=['b' 'g' 'r' 'c' 'm' 'y'];
% for k=1:length(B),
%   boundary = B{k};
%   cidx = mod(k,length(colors))+1;
%   plot(boundary(:,2), boundary(:,1),...
%        colors(cidx),'LineWidth',2);
% 
%   %randomize text position for better visibility
%   rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
%   col = boundary(rndRow,2); row = boundary(rndRow,1);
%   h = text(col+1, row-1, num2str(L(row,col)));
%   set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
% end

%% Display Object Boundaries in Red and Hole Boundaries in Green

% Calculate boundaries.

% [B,L,N] = bwboundaries(Bw);
% %Display object boundaries in red and hole boundaries in green.
% 
%  imshow(Bw); hold on;
% for k=1:length(B),
%    boundary = B{k};
%    if(k > N)
%      plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
%    else
%      plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
%    end
% end

%% Display Parent Boundaries in Red and Holes in Green
% [B,L,N,A] = bwboundaries(Bw); 
% figure; imshow(Bw); hold on; 
% % Loop through object boundaries  
% % for k = 1:N 
% %     % Boundary k is the parent of a hole if the k-th column 
% %     % of the adjacency matrix A contains a non-zero element 
% %     if (nnz(A(:,k)) > 0) 
% %         boundary = B{k}; 
% %         plot(boundary(:,2),... 
% %             boundary(:,1),'r','LineWidth',2); 
% %         % Loop through the children of boundary k 
% %         for l = find(A(:,k))' 
% %             boundary = B{l}; 
% %             plot(boundary(:,2),... 
% %                 boundary(:,1),'g','LineWidth',2); 
% %         end 
% %     end 
% % end
% 
% 
% 
% % Actual number of pixels in the region
% STATS = regionprops(L,'Area');
%  s1=cell2mat(struct2cell(STATS));
%  
%   % Smallest rectangle containing the region
% BOX = regionprops(L,'BoundingBox');  
% b1=cell2mat(struct2cell(BOX));
% 
% 
% for i = 1:max(L(:))
% boundary = B{i};
% 
%  if ( s1(i) <1500); %6500
%      continue;
%  end
%  
% Width =  b1(4.*i-1);
% Hight =  b1(4.*i);
%  rate = Width / Hight;
%  
% if ( 1.25> rate > 0.85&&Width < size1(1)./4 && Hight < size1(2)./4)
%     
%     plot(boundary(:,2), boundary(:,1), 'b','LineWidth',2);
%     
% end
% 
% 
% end





