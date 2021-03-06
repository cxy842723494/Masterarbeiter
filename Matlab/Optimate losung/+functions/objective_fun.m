% P0: initial parameter:
% thetaz,thetay,thetax,focal length,Translation_z,Translation_y,Translation_x
% dp: small differenz, same size with p0
% term_dp: terminate condition
% x1,x2: the corresponding point
% frame_time

function [J,x1,x2,pX1,dxy,W] = objective_fun(p0,x1,x2,frame_size,State) % frame_time
w=frame_size(2);
h=frame_size(1);
P = p0; 
% p =[0.01 0 0];p =[0 0.01 0 ];p =[0 0 0.002 0.025];

% Switch
% 0:test nur Rotation 
% 1:test Rotation and Focal length
% 2:test Rotation, Translation and Focal length
% 3:weiter
                        
switch State 
    case 0
        W = getW_Rotation(P(1),P(2),P(3),w,h);   
        pX1 = W*x2 ; 
        for i =1:size(pX1,2)
            pX1(1,i) = pX1(1,i)/ pX1(3,i);
            pX1(2,i) = pX1(2,i)/ pX1(3,i);
        end
    case 1
        W = getW_Rotation_F(P(1),P(2),P(3),P(4),w,h);  
        pX1 = W*x2 ; 
        for i =1:size(pX1,2)
            pX1(1,i) = pX1(1,i)/ pX1(3,i);
            pX1(2,i) = pX1(2,i)/ pX1(3,i);
        end
    case 2
        x1(4, :) = 1;
        x2(4, :) = 1;
        W = getW_Rotation_Translation(P(1),P(2),P(3),P(4),P(5),P(6),w,h);   
        pX1 = W*x2 ; 
        for i =1:size(pX1,2)
            pX1(1,i) = pX1(1,i)/ pX1(3,i);
            pX1(2,i) = pX1(2,i)/ pX1(3,i);
        end
    case 3 
        W = getW_Rotation_seperateTranslation(P(1),P(2),P(3),w,h);    
        pX1 = W*x2 ; 
        for i =1:size(pX1,2)
            pX1(1,i) = pX1(1,i)/ pX1(3,i);
            pX1(2,i) = pX1(2,i)/ pX1(3,i);
        end
        pX1 = pX1 +[P(4),P(5),0].' ; 
end

% pX1 = W*x2 ; 
% for i =1:size(pX1,2)
%     pX1(1,i) = pX1(1,i)/ pX1(3,i);
%     pX1(2,i) = pX1(2,i)/ pX1(3,i);
% end
dxy = x1(1:2,:) - pX1(1:2,:) ;

J = sum(sqrt(dot(dxy,dxy)));

end


function [W] = getW_Rotation(thetaz,thetay,thetax,w,h)           % f,w,h
% intrinsic camera Matrix
% load('cameraParametersGooglePixel2XL.mat');
% K = cameraParams.IntrinsicMatrix.';
% invK = inv(K);
% norm_invK = invK/3.142160374450406e-04;   % 1 0 -ox
                                          % 0 1 -oy
                                          % 0 0 f  
f = -3270; 
invK = [ 1, 0, -w/2;
         0, 1, -h/2;       
         0, 0, f];
              
K = [1, 0, w/(2*f);
     0, 1, h/(2*f);  
     0, 0, 1/f];
%  thetaz =0;   thetay = 0; thetax =0; 
Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
        sind(thetaz)  cosd(thetaz)  0; ...
        0             0             1];  
Roty = [cosd(thetay)  0             sind(thetay) ; ...
        0             1             0 ; ...
        -sind(thetay) 0             cosd(thetay)]; 
Rotx = [1             0             0 ; ...
        0             cosd(thetax)  -sind(thetax); ...
        0             sind(thetax)  cosd(thetax)]; 
 R = Rotz * Roty * Rotx;

W = K * R * invK;
end

function [W] = getW_Rotation_F(thetaz,thetay,thetax,f,w,h)           % f,w,h
% intrinsic camera Matrix
invK = [ 1, 0, -w/2;
         0, 1, -h/2;       
         0, 0, f];
              
K = [1, 0, w/(2*f);
     0, 1, h/(2*f);  
     0, 0, 1/f];
% K*inv(K)=I;

% thetaz =10;   thetax =20; thetay =30; 
Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...  
        sind(thetaz)  cosd(thetaz)  0; ...
        0             0             1];  
Roty = [cosd(thetay)  0             sind(thetay) ; ...
        0             1             0 ; ...
        -sind(thetay) 0             cosd(thetay)]; 
Rotx = [1             0             0 ; ...
        0             cosd(thetax)  -sind(thetax); ...
        0             sind(thetax)  cosd(thetax)]; 
R = Rotz * Roty * Rotx;

W = K * R* invK;

end

function [W] = getW_Rotation_F2(thetaz,thetay,thetax,f,w,h)           % f,w,h
% intrinsic camera Matrix
K = [f, 0, w/2;
     0, f, h/2;  
     0, 0, 1];
invK = inv(K); 
invK2 = [ 1, 0, -w/2;  % invK = lamdba * invK2 ; lamdba = 1/f;
         0, 1, -h/2;       
         0, 0, f];                   
% K*inv(K)=I;

% thetaz =10;   thetax =20; thetay =30; 
Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...  
        sind(thetaz)  cosd(thetaz)  0; ...
        0             0             1];  
Roty = [cosd(thetay)  0             sind(thetay) ; ...
        0             1             0 ; ...
        -sind(thetay) 0             cosd(thetay)]; 
Rotx = [1             0             0 ; ...
        0             cosd(thetax)  -sind(thetax); ...
        0             sind(thetax)  cosd(thetax)]; 
% R = Rotz * Roty * Rotx;

W = K * Rotz * Roty * Rotx * invK;

end


function [W] = getW_Rotation_Translation(thetaz,thetay,thetax,tx,ty,tz,w,h)           % f,w,h

f = -3270; 
% intrinsic camera Matrix
% load('cameraParametersGooglePixel2XL.mat');
% invK = cameraParams.IntrinsicMatrix;
% invKn = [invK; 0 0 0];invKnn(1:3,:) = invKn';
% invKnn(4,:)=[0 0 0 1]; 
%  K = invK'; K =inv(K)/3.142160374450406e-04;K =[K';0 0 0 ];
% K = [K';0 0 0 1];
% invKnn=invKnn'; 
K = [f, 0, w/2, 0;
     0, f, h/2, 0;  
     0, 0, 1,   0;
     0, 0, 0,   1];
invK = inv(K);
%%
%  thetaz =-0.362139917695473;   thetay = 0.840556148283629; thetax =-3.844535893918611; 
Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
        sind(thetaz)  cosd(thetaz)  0; ...
        0            0            1];   
Roty = [cosd(thetay)  0            sind(thetay) ; ...
        0             1            0 ; ...
        -sind(thetay) 0            cosd(thetay)]; 
Rotx = [1            0            0 ; ...
        0            cosd(thetax)  -sind(thetax); ...
        0            sind(thetax)  cosd(thetax)]; 
R = Rotz * Roty * Rotx;
T = [tx,ty,tz];
% T = [R(1,1)*tx+R(1,2)*ty+R(1,3)*tz, R(2,1)*tx+R(2,2)*ty+R(2,3)*tz, R(3,1)*tx+R(3,2)*ty+R(3,3)*tz];
RTtemp = [R';T];
RT(1:3,:) = RTtemp';
RT(4,:) =[0 0 0 1];

W = K * RT * invK;
end

function [W] = getW_Rotation_seperateTranslation(thetaz,thetay,thetax,w,h)           % f,w,h
% intrinsic camera Matrix
% load('cameraParametersGooglePixel2XL.mat');
% K = cameraParams.IntrinsicMatrix.';
% invK = inv(K);
% norm_invK = invK/3.142160374450406e-04;   % 1 0 -ox
                                          % 0 1 -oy
                                          % 0 0 f  
f = -3270; 
invK = [ 1, 0, -w/2;
         0, 1, -h/2;       
         0, 0, f];
              
K = [1, 0, w/(2*f);
     0, 1, h/(2*f);  
     0, 0, 1/f];
%  thetaz =0;   thetay = 0; thetax =0; 
Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
        sind(thetaz)  cosd(thetaz)  0; ...
        0             0             1];  
Roty = [cosd(thetay)  0             sind(thetay) ; ...
        0             1             0 ; ...
        -sind(thetay) 0             cosd(thetay)]; 
Rotx = [1             0             0 ; ...
        0             cosd(thetax)  -sind(thetax); ...
        0             sind(thetax)  cosd(thetax)]; 
 R = Rotz * Roty * Rotx;

W = K * R * invK;
end