% this part of fuction is to estimate the image registration, 
% i.e von hand held camera images to restruction image,
% to provide the hande shake by catching the images

%£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥£¥
% input: camera images von the folder
% output: durch the restructuring images to generate the differenzbild

function [diff_U_origin] = imageRegistration(Igray1,Igray2,yuv)

frame_size = size(Igray1);
% U2new = ones(frame_size(1),frame_size(2)); 
% figure, imshow(Igray1);
% figure, imshow(Igray2);
% figure, imshowpair(Igray1,Igray2);

%% feature detection
% for i=1:5
[pts1h,pts2h] = matchedinlierspoint(Igray1,Igray2);

%% Algorithmus
% parameter: f,thetaz,thetay,thetax,ts,td,wd
% input: 2 set of corresponding points after sift und RANSAC x,y

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
% p2new = interp2(Igray2,p2_1,p2_2);        
% figure;imshowpair(Igray1,p2new);
% p2new = interp2(Igray2,p2_1,p2_2,'nearest');        
% figure;imshowpair(Igray1,p2new); 
% clear p2_1 p2_2 p2new
end
%% State 2
if State == 2
invW = W^-1;

for i=1:frame_size(1)          
    for j=1:frame_size(2)       
        p2 = invW*[j,i,1,1].';
        p2 = p2/p2(3);
        p2_1(i,j) = p2(1);
        p2_2(i,j)=  p2(2);  

    end 
   
end  
% p2new = interp2(Igray2,p2_1,p2_2);  % generate the restructing Image       
% figure;imshowpair(Igray1,p2new);    
% p2new = interp2(Igray2,p2_1,p2_2,'nearest');        
% figure;imshowpair(Igray1,p2new); 
% clear p2_1 p2_2 p2new
end

%%
U2new = interp2(yuv(2).U,p2_1,p2_2);  
% figure;imshow(yuv(2).U/255);
% figure;imshow(yuv(1).U/255);
% figure;imshow(U2new/255);
diff_U = yuv(1).U - U2new;
% figure;imshow(diff_U),title('new diff');
diff_U_origin = yuv(1).U - yuv(2).U;
% figure;imshow(diff_U_origin),title('origin diff');

end
 
 %% P0 parameter include Rotation 
function [p0,J,W,J0] = J_Rotation(pts1h, pts2h, State,frame_size)
p0=[0 0 0];
dp=[2 2 2 ]; % mit 0.1 grad verändern 
term_dp=[0.001 0.001 0.001 ]; % threshold 0.001 grad
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size,State);
end

%% P0 parameter include Rotation and Focal length: 
function [p0,J,W,J0] = J_Rotation_focal(pts1h, pts2h, State,frame_size)
p0=[0 0 0 -3270];  % 3200 or -3200
dp=[2 2 2 5]; % mit 0.1 grad verändern and focal length mit 1 pixel
term_dp=[0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation Translation und Focal length:
function [p0,J,W,J0] = J_Rotation_Translation(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 0.01 0.01 0.01]; % % mit 0.1 grad verändern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.000001 0.000001 0.000001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation und seprate Translation:
function [p0,J,W,J0] = J_Rotation_Translation_seprate(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 1 1]; % mit 0.1 grad verändern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

