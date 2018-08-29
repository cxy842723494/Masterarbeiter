clean;
img =  imread('windmill.png');

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

% figure,imshow(img),hold on; grid on;

[height,width,~]=size(img);

for i = 200:200:height
    img(i,:,:)=255;
end

for j = 200:200:width
    img(:,j,:)=255;
end

figure,imshow(img);

%%
%       p = imread('windmill.png'); 
%       [mm,nn,~] = size(p); 
%       x = 0:200:nn; 
%       y = 0:200:mm; 
%       M = meshgrid(x,y); 
%       N = meshgrid(y,x); 
%       imshow(p);
%       hold on
%       plot(x,N,'y'); 
%       plot(M,y,'y');