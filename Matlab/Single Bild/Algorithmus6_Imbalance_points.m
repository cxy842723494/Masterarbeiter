    clean;
%     close all;
    %% use imbalanced points to quantify the likelihood of a rectangular shape

%     load A.mat
    [filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end
    [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(filefullpath);
    
    Img = yuv2rgb(yuv(1).Y, yuv(1).U, yuv(1).V);
    
    handels.Img = double(Img)./255;
    handels.R = handels.Img(:,:,1);
    handels.G = handels.Img(:,:,2);
    handels.B = handels.Img(:,:,3);
    handels.Imggray = rgb2gray(handels.Img);
    figure, imshow(handels.Imggray);
%     figure, imshow(handels.Imggray*255);
%     BW =  imbinarize(handels.Imggray*255,5);
%      figure, imshow(BW);

    sigma = 0.5;
    G1 = fspecial('gauss',[round(10*sigma), round(10*sigma)], sigma);
    [Gx,Gy] = gradient(G1);

    n = 8;
   tic;
    for i =1:n
        theta = (i-1)*pi/4;

        Gtheta= cos(theta)*Gx + sin(theta)*Gy; % 8 direction

%          conv2(A1,B1,'valid');
 %Y = filter2(H,X) applies a finite impulse response filter to a matrix of data X according to coefficients in a matrix H.
%         Y = filter2(Gtheta,handels.Imggray,'valid');
         Y = imfilter(handels.Imggray,Gtheta,'replicate','same','conv');
         Z(:,:,i) =Y; 
%         figure, imshow(Y);
    end
    toc;
  
    
%     plot(1000,400,'x');
    tic;
    A = zeros(3,3); 
    output=0;
    [m,n] = size(handels.Imggray);
    d=1;
    for i = 5:m-4
        for j = 5:n-4
            A(1,1) =Z(i-2,j-2,6);     
            A(1,2) =Z(i-2,j,7);      
            A(1,3) =Z(i-2,j+2,8);     
            A(2,3) =Z(i,j+2,1);      
            A(3,3) =Z(i+2,j+2,2);     
            A(3,2) =Z(i+2,j,3);      
            A(3,1) =Z(i+2,j-2,4);     
            A(2,1) =Z(i,j-2,5);  
                        
            A = A*255;
            A = abs(A);
%             x=[0 0 0 0 0 0 0 0];
%             y=x;
%             u=[A(2,3) -A(2,1) 0 0 0.707*A(1,3) -0.707*A(1,1) -0.707*A(3,1) 0.707*A(3,3)];
%             v=[0 0 A(1,2) -A(3,2) 0.707*A(1,3) 0.707*A(1,1) -0.707*A(3,1) -0.707*A(3,3)];
%             figure,quiver(x,y,u,v);
            A1 = reshape(A,1,9);
            A2 = sort(A1);
%              figure,bar(A2);
%              output=0;
            for k = 2:8
                A3(k-1) = A2(k+1)-A2(k);
            end
%             figure,bar(A3);
            index = find(A3 == max(A3));
            if max(A3)>5
                if index ==4
                output = output+1;
%                 plot(j,i,'x');
                Point(:,1)=i;
                Point(:,2)=j;
                P(d,:) = Point;
                d = d+1;
                end
            end
           
        end
    end
    toc;
    
  figure, imshow(handels.Imggray),hold on;
%     P1 = P.';
    plot(P(:,2),P(:,1),'x');

    
%     i = 90;j =188; 
%     P = (x,y);   


    
    T=[0.482636409469512,0.506039163495649,0.520148465623443,0.515501739674272,0.485748629578385;0.492824142969855,0.506081630037360,0.534704908552238,0.521767904547164,0.498238492782458;0.488455433541404,0.513924767292262,0.526414630496335,0.516674037796992,0.493827316812295;0.463753723653977,0.461046919690958,0.450454511931326,0.451584343512335,0.464031740174697;0.379460860491354,0.369315593532722,0.357593354192081,0.353671785564630,0.363369911722261]
    Re = imfilter(T,Gtheta,'replicate','same','conv');
    Y1 = filter2(rot90(Gtheta,2),T,'valid');