clean;
% parameter: f,thetaz,thetay,thetax,ts,td,wd
% input: 2 set of corresponding points after sift und RANSAC x,y

%% load the image
% fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
% fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
fn1 ='YUV_2018_06_26_17_27_29_610.yuv';
fn2 ='YUV_2018_06_26_17_26_59_679.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
[yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);

Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;
frame_size = size(Igray1);
% figure, imshow(Igray1);
% figure, imshow(Igray2);

%% feature detection
[pts1h,pts2h] = matchedinlierspoint(Igray1,Igray2);

%% Algorithmus
State = 2;              % 0:test nur Rotation 
                        % 1:test Rotation and Focal length
                        % 2:test Rotation, Translation and Focal length
                        % 3:weiter                       
switch State
    case 0        
        [p0,J] = J_Rotation(pts1h, pts2h,State,frame_size);
    case 1
        [p0,J] = J_Rotation_focal(pts1h,pts2h,State,frame_size);
    case 2
        [p0,J] = J_Rotation_Translation(pts1h, pts2h,State,frame_size);
    case 3
               
end
%% Auswert
auswert(p0,pts1h,pts2h,frame_size,State,Igray1) 

    
%% P0 parameter include Rotation 
function [p0,J] = J_Rotation(pts1h, pts2h, State,frame_size)
p0=[0 0 0];
dp=[0.1 0.1 0.1 ]; % mit 0.1 grad verändern 
term_dp=[0.001 0.001 0.001 ]; % threshold 0.001 grad
[p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size,State);
end

%% P0 parameter include Rotation and Focal length: 
function [p0,J] = J_Rotation_focal(pts1h, pts2h, State,frame_size)
p0=[0 0 0 3200];  % 3200 or -3200
dp=[0.1 0.1 0.1 10]; % mit 0.1 grad verändern and focal length mit 1 pixel
term_dp=[0.001 0.001 0.001 1]; % 
[p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation Translation und Focal length:
function [p0,J] = J_Rotation_Translation(pts1h, pts2h, State,frame_size)
p0=[0 0 0 10 0 0];  % first 3 Rotation others Translation
dp=[0.1 0.1 0.1 1 1 1]; % % mit 0.1 grad verändern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.001 0.001 0.001]; % 
[p0,J] = J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

