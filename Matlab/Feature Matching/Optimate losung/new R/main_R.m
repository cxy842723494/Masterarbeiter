clean;
% parameter: f,thetaz,thetay,thetax,ts,td,wd
% input: 2 set of corresponding points after sift und RANSAC x,y

%% load the image
fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
% fn1 ='YUV_2018_06_26_17_27_29_610.yuv';
% fn2 ='YUV_2018_06_26_17_26_59_679.yuv';

% fn1 ='YUV_2018_06_06_12_54_25_357.yuv';
% fn2 ='YUV_2018_06_06_12_54_25_344.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
[yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);
Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;

%  load('image.mat');
%  Img1 = A; Img2 = B;
 
% rotation test
% Img1 = imread('IMG_0385.JPG');Img2 = imread('IMG_0384.JPG'); %  c.a. y-achse 7 grad
%  Img1 = imread('IMG_0390.JPG');Img2 = imread('IMG_0391.JPG'); %  c.a. y-achse 14 grad
% Img1 = imread('IMG_0386.JPG');Img2 = imread('IMG_0387.JPG'); %  c.a. x-achse 6 grad 
% Img1 = imread('IMG_0388.JPG');Img2 = imread('IMG_0389.JPG'); %  c.a. x-achse 9 grad 
% Translation test
% Img1 = imread('IMG_0392.JPG');Img2 = imread('IMG_0393.JPG'); %  c.a. x-achse 9 grad 

% Igray1 = rgb2gray(Img1);
% Igray2 = rgb2gray(Img2);
frame_size = size(Igray1);
% figure, imshow(Igray1);
% figure, imshow(Igray2);
% figure, imshowpair(Igray1,Igray2);

% for i=1:5
%% feature detection
[pts1h,pts2h] = matchedinlierspoint(Igray1,Igray2);

%% Algorithmus
State =0;          % 0:test nur Rotation 
                        % 1:test Rotation and Focal length
                        % 2:test Rotation, Translation and Focal length
                        % 3:test Rotation mit seperate Translation       
switch State
    case 0        
        [p0,J,W] = J_Rotation(pts1h, pts2h,State,frame_size);
    case 1
        [p0,J,W] = J_Rotation_focal(pts1h,pts2h,State,frame_size);
    case 2
        [p0,J,W] = J_Rotation_Translation(pts1h, pts2h,State,frame_size);
    case 3
        [p0,J,W] = J_Rotation_Translation_seprate(pts1h, pts2h,State,frame_size);
                   
end

% P0(i,:) = p0; J0(i) = J;
% end

% index = find(J0==min(J0));
% J = J0(index);
% p0 = P0(index,:);

%% Auswert
% auswert(p0,pts1h,pts2h,frame_size,State,Igray1) 

%%
% T = maketform('projective',W');
% [u,v] = meshgrid((1:size(Igray2,2)),(1:size(Igray2,1)));
% uhat = W*[u(:)';v(:)';ones(1,numel(u))];%;ones(1,numel(u))
% uhat = bsxfun(@rdivide,uhat,uhat(3,:));
% % image extents
% min_u = min(u(:));
% max_u = max(u(:));
% min_v = min(v(:));
% max_v = max(v(:));
% % maximum area containing the whole transformed images
% min_x_total = min(min(uhat(1,:)));
% max_x_total = max(max(uhat(1,:)));
% min_y_total = min(min(uhat(2,:)));
% max_y_total = max(max(uhat(2,:)));
% % minimum area contraining the overlap of the images
% min_x_overlap = max(min(uhat(1,:)));
% max_x_overlap = min(max(uhat(1,:)));
% min_y_overlap = max(min(uhat(2,:)));
% max_y_overlap = min(max(uhat(2,:)));
% 
% I2rect_total = imtransform(Igray2,T,'XData',[min_x_total max_x_total],...
%     'YData',[min_y_total max_y_total],'UData',[min_u max_u],...
%     'VData',[min_v max_v],'XYScale',[1 1]); 
% figure;imshow(I2rect_total,[]);
% I2rect_overlap = imtransform(Igray2,T,'XData',[min_x_overlap max_x_overlap],...
%     'YData',[min_y_overlap max_y_overlap],'UData',[min_u max_u],...
%     'VData',[min_v max_v],'XYScale',[1 1]);
% figure;imshow(I2rect_overlap,[]);
% figure;imshowpair(Igray1,I2rect_overlap);

% imref2d,imterp2
% I2new = imwarp(Igray2,H);
[m,n] = size(Igray1); 
I2new_matrix = ones(m,n);  
invW = W^-1;
invW = invW/invW(end); 
T1 = invW;
T = T1;
% T2 = [1,0,0;0,1,0;-m/2,-n/2,1];  %x?y??????  
% T3 = [1,0,0;0,1,0;m/2,n/2,1];    %x?y????  
% T = T2*T1*T3; 
for i=1300:m  
    for j=1500:n  
        p = T^-1*[i,j,1].';
        p = p/p(3);
        if (p(1)>0)&&(p(2)>0)
%         if (p(1)<=m)&&(p(1)>0)&&(p(2)<=n)&&(p(2)>0) 
        I2new_matrix(i,j) = Igray2(i,j);   
        else   
        I2new_matrix(i,j) = 0;     
        end  
    end  
end  
% figure;imshow(I2,[]);  
figure;imshow(I2new_matrix);  
figure;imshowpair(Igray1,I2new_matrix);  
figure;imshowpair(Igray1,Igray2); hold on;
%% P0 parameter include Rotation 
function [p0,J,W] = J_Rotation(pts1h, pts2h, State,frame_size)
p0=[0 0 0];
dp=[2 2 2 ]; % mit 0.1 grad verändern 
term_dp=[0.001 0.001 0.001 ]; % threshold 0.001 grad
[p0,J,W] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size,State);
end

%% P0 parameter include Rotation and Focal length: 
function [p0,J,W] = J_Rotation_focal(pts1h, pts2h, State,frame_size)
p0=[0 0 0 -3270];  % 3200 or -3200
dp=[2 2 2 5]; % mit 0.1 grad verändern and focal length mit 1 pixel
term_dp=[0.001 0.001 0.001 0.001]; % 
[p0,J,W] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation Translation und Focal length:
function [p0,J,W] = J_Rotation_Translation(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 0.01 0.01 0.01]; % % mit 0.1 grad verändern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.000001 0.000001 0.000001]; % 
[p0,J,W] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation und seprate Translation:
function [p0,J,W] = J_Rotation_Translation_seprate(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 1 1]; % mit 0.1 grad verändern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.001 0.001]; % 
[p0,J,W] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

