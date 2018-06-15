% Load the stereo images.
I1 = imread('viprectification_deskLeft.png');
I2 = imread('viprectification_deskRight.png');
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
figure,imshow(I1);
figure,imshow(I2);
[m,n] = size(I2); 
I2new_matrix = ones(m,n);  
T1 = fLMedS;
T2 = [1,0,0;0,1,0;-m/2,-n/2,1];  %x?y??????  
T3 = [1,0,0;0,1,0;m/2,n/2,1];    %x?y????  
T = T2*T1*T3; 
for i=1:m  
    for j=1:n  
        p = floor([i,j,1]*T1^-1);%?P_new = P_old*T ???P_old = P_new*(T^-1)  
        if (p(1)<=m)&&(p(1)>0)&&(p(2)<=n)&&(p(2)>0) %????   
         I2new_matrix(i,j) = I2(p(1),p(2));   %??????  
        else   
        I2new_matrix(i,j) = 0;     %???????0  
        end  
    end  
end  
% figure;imshow(I2,[]);  
figure;imshow(I2new_matrix);  