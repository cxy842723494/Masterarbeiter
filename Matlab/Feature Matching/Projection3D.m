function J = Projection3D(x,y,Img,f,delta11,delta12,delta13,delta21,delta22,delta23)
%   Input: the feature point come from feature detection an RANSAC to
%   discard outliers. 
%   x,y: corresponding feature image point, X,Y: corresponding point in 3D world coordinates

%   Parameter: focal length f; Rotation angle: delta11,delta12,delta13,delta21,delta22,delta23

%     Img= imread('IMG_0353.jpg');
    vw = size(Img,2);
    vh = size(Img,1);
%     f=100;
    
% Instrinsic camera matrix
    K1 = [1 0 -vw/2; 0 1 -vh/2; 0 0 f];
    K = inv(K1);
%     X = K1*[x(i,:)'; 1];
%     Y = K1*[y(i,:)'; 1];

% Orientation R(t)
    Rx1 = [1            0           0;
          0 cos(delta11) -sin(delta11);
          0 sin(delta11)  cos(delta11)];

    Ry1 = [ cos(delta12) 0 sin(delta12);
          0           1           0;
          -sin(delta12) 0 cos(delta12)];

    Rz1 = [cos(delta13) -sin(delta13) 0;
          sin(delta13)  cos(delta13) 0;
          0           0            1];
      
    Rx2 = [1            0           0;
          0 cos(delta21) -sin(delta21);
          0 sin(delta21)  cos(delta21)];

    Ry2 = [ cos(delta22) 0 sin(delta22);
          0           1           0;
          -sin(delta22) 0 cos(delta22)];

    Rz2 = [cos(delta23) -sin(delta23) 0;
          sin(delta23)  cos(delta23) 0;
          0           0            1];
      
    R1 = Rz1 * Ry1 * Rx1;  
    R2 = Rz2 * Ry2 * Rx2; 
    
%  corresponding feature image point   
    W = K*R1*R2.'*K1;
    
%     y_cor = W*x;
    
% minimize the mean-squareed-projection error
    J = sum(sum((y - W*x).^2));
    
    
%       
%       I1 = imread('IMG_0356.JPG');
%       I2 = imread('IMG_0357.JPG');
%       figure, imshowpair(I1,I2);
%       figure, imshow(I1);