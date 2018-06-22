% p0: initial parameter: f 45?,thetaz,thetay,thetax 0
% dp: small differenz, same size with p0
% term_dp: terminate condition
% x1,x2: the corresponding point
% frame_time
% 
function [J] = objective_fun(p0,x1,x2,frame_size) % frame_time
w=frame_size(2);
h=frame_size(1);
p = p0; % p =[0.01 0 0];p =[0 0.01 0 ];p =[0 0 0.002 0.025];
% pX1 = getW(p(1),p(2),p(3))*x2 ; 

% W = getW_mit_f(p(1),p(2),p(3),p(4),w,h);
% pX1 = getW_mit_f(p(1),p(2),p(3),p(4),w,h)*x2 ;    % p.f,
 x1(4, :)   = 1;
 x2(4, :)   = 1;
 pX1 = getW_shift(p(1),p(2),p(3),p(4),p(5),p(6))*x2 ;  

for i =1:size(pX1,2)
    pX1(1,i) = pX1(1,i)/ pX1(3,i);
    pX1(2,i) = pX1(2,i)/ pX1(3,i);
end
dxy = x1(1:2,:) - pX1(1:2,:) ;


J = sum(sqrt(dot(dxy,dxy)));

end


function [W] = getW_mit_f(thetaz,thetay,thetax,f,w,h)           % f,w,h
% intrinsic camera Matrix
K = [ 1, 0, -w/2;
      0, 1, -h/2;       % k.^-1
      0, 0, f];
              
invK = [1, 0, w/(2*f);
        0, 1, h/(2*f);
        0, 0, 1/f];

% Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
%         sind(thetaz)  cosd(thetaz)  0; ...
%         0            0            1];  
%  thetaz =10;   thetax =20; thetay =30; 
Rotz = [cosd(-thetaz)  -sind(-thetaz) 0; ...   % -thetaz?
        sind(-thetaz)  cosd(-thetaz)  0; ...
        0             0            1];  
Roty = [cosd(thetay)  0            sind(thetay) ; ...
        0             1            0 ; ...
        -sind(thetay) 0            cosd(thetay)]; 
Rotx = [1             0            0 ; ...
        0             cosd(thetax)  -sind(thetax); ...
        0             sind(thetax)  cosd(thetax)]; 
% R = Rotz * Roty * Rotx;

W = invK * Rotz * Roty * Rotx * K;

end

function [W] = getW(thetaz,thetay,thetax)           % f,w,h
% intrinsic camera Matrix
load('cameraParametersGooglePixel2XL.mat');
invK = cameraParams.IntrinsicMatrix.';

K = inv(invK)/3.142160374450406e-04;

Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
        sind(thetaz)  cosd(thetaz)  0; ...
        0            0            1];  
%  thetaz =0.01;   thetay = 0; thetax =0; 
% Rotz = [cosd(-thetaz)  -sind(-thetaz) 0; ...   % -thetaz?
%         sind(-thetaz)  cosd(-thetaz)  0; ...
%         0            0            1];  
Roty = [cosd(thetay)  0            sind(thetay) ; ...
        0            1            0 ; ...
        -sind(thetay) 0            cosd(thetay)]; 
Rotx = [1            0            0 ; ...
        0            cosd(thetax)  -sind(thetax); ...
        0            sind(thetax)  cosd(thetax)]; 
% R = Rotz * Roty * Rotx;

W = invK * Rotz * Roty * Rotx * K;
end

function [W] = getW_shift(thetaz,thetay,thetax,tx,ty,tz)           % f,w,h
T = [tx,ty,tz];
% intrinsic camera Matrix
load('cameraParametersGooglePixel2XL.mat');
invK = cameraParams.IntrinsicMatrix;
invKn = [invK; 0 0 0];invKnn(1:3,:) = invKn';
invKnn(4,:)=[0 0 0 1]; 
 K = invK'; K =inv(K)/3.142160374450406e-04;K =[K';0 0 0 ];
K = [K';0 0 0 1];
invKnn=invKnn'; 

Rotz = [cosd(thetaz)  -sind(thetaz) 0; ...
        sind(thetaz)  cosd(thetaz)  0; ...
        0            0            1];  
%  thetaz =0.01;   thetay = 0; thetax =0; 
% Rotz = [cosd(-thetaz)  -sind(-thetaz) 0; ...   % -thetaz?
%         sind(-thetaz)  cosd(-thetaz)  0; ...
%         0            0            1];  
Roty = [cosd(thetay)  0            sind(thetay) ; ...
        0            1            0 ; ...
        -sind(thetay) 0            cosd(thetay)]; 
Rotx = [1            0            0 ; ...
        0            cosd(thetax)  -sind(thetax); ...
        0            sind(thetax)  cosd(thetax)]; 
 R = Rotz * Roty * Rotx;
RTtemp = [R';T];
RT(1:3,:) = RTtemp';
RT(4,:) =[0 0 0 1];
% Q = [1 0 0 0;0 1 0 0;0 0 1 0];

W = invKnn  * RT * K;
end