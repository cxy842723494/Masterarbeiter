

% rotation test
% Img1 = imread('IMG_0385.JPG');Img2 = imread('IMG_0384.JPG'); %  c.a. y-achse 7 grad
%  Img1 = imread('IMG_0390.JPG');Img2 = imread('IMG_0391.JPG'); %  c.a. y-achse 14 grad
% Img1 = imread('IMG_0386.JPG');Img2 = imread('IMG_0387.JPG'); %  c.a. x-achse 6 grad 
% Img1 = imread('IMG_0388.JPG');Img2 = imread('IMG_0389.JPG'); %  c.a. x-achse 9 grad 
% Translation test
% Img1 = imread('IMG_0392.JPG');Img2 = imread('IMG_0393.JPG'); %  c.a. x-achse 9 grad 

% Igray1 = rgb2gray(Img1);
% Igray2 = rgb2gray(Img2);

%% feature detection
% for i=1:5
[pts1h,pts2h] = matchedinlierspoint(Igray1,Igray2);

%% Algorithmus
State =2;          % 0:test nur Rotation 
                        % 1:test Rotation and Focal length
                        % 2:test Rotation, Translation and Focal length
                        % 3:test Rotation mit seperate Translation       
        switch State
            case 0        
                [p0,J,W,J0] = J_Rotation(pts1h, pts2h,State,frame_size);
            case 1
                [p0,J,W,J0] = J_Rotation_focal(pts1h,pts2h,State,frame_size);
            case 2
                [p0,J,W,J0] = J_Rotation_Translation(pts1h, pts2h,State,frame_size);
            case 3
                [p0,J,W,J0] = J_Rotation_Translation_seprate(pts1h, pts2h,State,frame_size);

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

%% State 0
if State == 0
invW = W^-1;
invW = invW/invW(end); 
for i=1:frame_size(1)     
    for j=1:frame_size(2)  
        p2 = invW*[j,i,1].';
        p2 = p2/p2(3);
        p2_1(i,j) = p2(1);
        p2_2(i,j)=  p2(2);  

    end 
   
end  

end
%% State 2
if State == 2
    invW = W^-1;

for m=1:frame_size(1)          
    for n=1:frame_size(2)       
        p2 = invW*[n,m,1,1].';
        p2 = p2/p2(3);
        p2_1(m,n) = p2(1);
        p2_2(m,n)=  p2(2);  

    end 
   
end 
end

%%
p2new = interp2(Igray2,p2_1,p2_2);        
% figure;imshowpair(Igray1,p2new);
p2new = interp2(Igray2ori,p2_1,p2_2);    
% figure;imshowpair(Igray1ori,p2new);
% p2new = interp2(Igray2,p2_1,p2_2,'nearest');        
% figure;imshowpair(Igray1,p2new); 
% clear p2_1 p2_2 p2new


%% U-teil differenzbild
Y2new(:,:,j) = interp2(yuv(2).Y,p2_1,p2_2);  
U2new(:,:,j) = interp2(yuv(2).U,p2_1,p2_2);  
% figure;imshow(yuv(j).U/255);
% figure;imshow(yuv(1).U/255);
% figure;imshow(U2new(:,:,j)/255);

diff_U(:,:,j-1) = yuv(i).U - U2new(:,:,j);
% diff_U0 = diff_U(:,:,1)+diff_U(:,:,3)+diff_U(:,:,5);
% figure;imshow(diff_U),title('new diff');
diff_U_origin(:,:,j-1) = yuv(i).U - yuv(2).U;
% figure;imshow(diff_U_origin),title('origin diff');
%% V-teil differenzbild
V2new(:,:,j) = interp2(yuv(2).V,p2_1,p2_2);  
% figure;imshow(yuv(j).U/255);
% figure;imshow(yuv(1).U/255);
% figure;imshow(U2new(:,:,j)/255);

diff_V(:,:,j-1) = yuv(i).V - V2new(:,:,j);
% diff_U0 = diff_U(:,:,1)+diff_U(:,:,3)+diff_U(:,:,5);
% figure;imshow(diff_U),title('new diff');
diff_V_origin(:,:,j-1) = yuv(i).V - yuv(2).V;
% figure;imshow(diff_U_origin),title('origin diff');
  end
%  imwrite(E,[[cd,'\difftrans\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png'])

%%
% implay(mat2gray(gather(diff_U(:,:,:))))
% implay(mat2gray(gather(diff_U_origin(:,:,:))))
% implay(mat2gray(gather(U2new(:,:,:))))

%% P0 parameter include Rotation 
function [p0,J,W,J0] = J_Rotation(pts1h, pts2h, State,frame_size)
p0=[0 0 0];
dp=[2 2 2 ]; % mit 0.1 grad ver�ndern 
term_dp=[0.001 0.001 0.001 ]; % threshold 0.001 grad
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size,State);
end

%% P0 parameter include Rotation and Focal length: 
function [p0,J,W,J0] = J_Rotation_focal(pts1h, pts2h, State,frame_size)
p0=[0 0 0 -3270];  % 3200 or -3200
dp=[2 2 2 5]; % mit 0.1 grad ver�ndern and focal length mit 1 pixel
term_dp=[0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation Translation und Focal length:
function [p0,J,W,J0] = J_Rotation_Translation(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 0.01 0.01 0.01]; % % mit 0.1 grad ver�ndern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.000001 0.000001 0.000001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation und seprate Translation:
function [p0,J,W,J0] = J_Rotation_Translation_seprate(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 1 1]; % mit 0.1 grad ver�ndern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end
