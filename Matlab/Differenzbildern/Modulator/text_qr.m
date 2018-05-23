close all;
clear ;
clc;
 
load('diffc_V.mat') 
handles.SrcImg=diffc_V.*255;
% handles.SrcImg=imread('QRcode1.jpg');% open the image
handles.grayImg = rgb2gray(handles.SrcImg);% change RGB image to gray image.
[m,n]=size(handles.grayImg);
handles.norImg= zeros(m,n);
handles.norImg = 255*(handles.grayImg(:,:)>120);
MN=[3,3];
SE1=strel('rectangle',MN); 
handles.norImg = imerode(handles.norImg,SE1);

handles.edge = edge(handles.norImg,'canny');
handles.bw=imbinarize(handles.grayImg);
handles.bw = bwmorph(handles.bw,'close');
handles.bw1=1-handles.bw;% bw image 

Bw=bwareaopen(handles.bw1,50,4);% delete some area which the size is smaller than 50 
L = bwlabel(Bw,4);% label every area for 1,2,3........n
S = regionprops(L, 'Area');% compute how many pixels in each area 
STATS = regionprops(L, 'all');
[m,n] = size(STATS);% compute the number of object area
j = 1;
K = L;
for i =1:m
[rows,cols] = size(STATS(i,1).ConvexImage);%compute the wide and height of each area
 if(abs(double(rows/cols)-1)<0.15)% find some area which wide equal to height? ?
Area = STATS(i,1).Area;
if(abs(double(Area/rows/cols)-1)<0.15)%find some area which wide equal to height and area equal to wide multiply by height
    index(j,1) = i;% assume index(j,1) equal to i
    index(j,2) = STATS(i,1).Centroid(1);%assume index(j,2) equal to the centroid coordinates in X axis
    index(j,3) = STATS(i,1).Centroid(2);%assume index(j,3) equal to the centroid coordinates in Y axis
j=j+1;
end

end
end
 
index
 
%according the characteristics of finder pattern of 1:1:3:1:1 to position
%QR code area
[m,n]=size(L); %compute wide and height of L 
result = zeros(m,n);% create a black image, the wide and height is equal to L
 
for i = 1:3
 [r,c] = find(L==index(i,1)); % find the rows and columns of each square, then we can know the four points coordinates for any square 
result(r(:),c(:))=index(i,1);% position and show this three squares in the black image
end
[r1,c1] = size(STATS(index(1,1),1).ConvexImage);% compute the size of three square
[r2,c2] = size(STATS(index(2,1),1).ConvexImage);
[r3,c3] = size(STATS(index(3,1),1).ConvexImage);
handles.x1 = index(1,3)-r1*7/6;%compute the edge coordinates of finder pattern. 
handles.y1 = index(1,2)-c1*7/6;%because of finder pattern is a 7 units of 1:1:3:1:1 square
handles.x2 = index(2,3)+r3*7/6;%so the distance from centroid to edge is 3.5 units. the r,c is the size of small square in finder pattern
handles.y2 = index(3,2)+c2*7/6;%r,c are all 3 units, so r*3.5/3 is the true distance value from centroid to edge
 
QR = handles.SrcImg(handles.x1:handles.x2,handles.y1:handles.y2,:);%according the edge coordinates of finder pattern to segment the QR code 
 
 
 
figure;imshow(handles.SrcImg);title('original image');
figure;imshow(handles.grayImg);title('gray image');
figure;imshow(handles.bw);title('binary image');
figure;imshow(handles.edge);title('edge detection');
figure;imshow(handles.bw1);title('binary negative image');
figure;imshow(result);title('position image');
figure;imshow(QR);title('result image');