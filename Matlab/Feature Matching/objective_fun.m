% p0: initial parameter: f 45°,thetaz,thetay,thetax 0
% dp: small differenz, same size with p0
% term_dp: terminate condition
% x1,x2: the corresponding point
% frame_time
% 
function [J] = objective_fun(p0,x1,x2,frame_size) % frame_time
w=size(frame_size,2);
h=size(frame_size,1);
p = p0;
pX1 = getW(p.f,p.thetaz,p.thetay,p.thetax,w,h)*x2 ;
dxy = x1(1:2,:) - ( Vec(pX|X, pX|Y) / (pX|Z) );

end


function [W] = getW(f,thetaz,thetay,thetax,w,h) 
% intrinsic camera Matrix
K = [1, 0, -w/2;
      0, 1, -h/2;
      0, 0, f];
              
invK = [1, 0, w/(2*f);
        0, 1, h/(2*f);
        0, 0, 1/f];
    

Rotz = [cos(thetaz)  -sin(thetaz) 0; ...
        sin(thetaz)  cos(thetaz)  0; ...
        0            0            1]; 
Roty = [cos(thetay)  0            sin(thetay) ; ...
        0            1            0 ; ...
        -sin(thetay) 0            cos(thetay)]; 
Rotx = [1            0            0 ; ...
        0            cos(thetax)  -sin(thetax); ...
        0            sin(thetax)  cos(thetax)]; 

R = Rotz * Roty * Rotx;
W = invK * R * K;
end