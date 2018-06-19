% parameter: f,thetaz,thetay,thetax
% input: 2 set of corresponding points after sift und RANSAC x,y

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

pX = W * [y(:,2);y(:,1);1];
       
dxy = y - pX;

J = sqrt(dot(dxy, dxy));

% err += sqrt(dot(dxy, dxy));
% 
% err /= num_pts;