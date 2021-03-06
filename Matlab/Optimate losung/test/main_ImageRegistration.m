clean;
% This function creat the transformed image in Y,U,V teil.
% parameter: 
% input: 2 set of corresponding points after sift und RANSAC x,y

%% load the image 

    file_path = uigetdir('D:\xch\Daten\xch\','Select the Folder');    
%     file_path = 'D:\xch\Daten\xch\1007\text in 100HZ Bildschirm'
%     file_path = 'G:\0907\7';    
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));    
    img_num = length(img_path_list);
    
    % Transform the other images in the first images' dimension
    i = 1;
    image_name1 = img_path_list(i).name;              
    [yuv(1).Y,yuv(1).U,yuv(1).V] = functions.readYUV(strcat(file_path,image_name1));  
    yuv(1).Y = imresize(yuv(1).Y,0.5,'nearest');
    Igray1 = yuv(1).Y/255;
    frame_size = size(Igray1);
%     Igray1ori = yuv(1).Y/255;
    
    Y2new(:,:,i) = yuv(i).Y; 
    U2new(:,:,i) = yuv(i).U; 
    V2new(:,:,i) = yuv(i).V; 
    
  for j=2:img_num                        % each image transform                            
   
    image_name2 = img_path_list(j).name;     
    [yuv(2).Y,yuv(2).U,yuv(2).V] =  functions.readYUV(strcat(file_path,image_name2));          
    yuv(2).Y = imresize(yuv(2).Y,0.5);
    Igray2 = yuv(2).Y/255;
%     Igray2ori = yuv(2).Y/255;
 
% figure, imshow(Igray1);
% figure, imshow(Igray2);
% figure, imshowpair(Igray1,Igray2);
% figure, imshowpair(Igray1ori,Igray2ori);

%% add a filter in the middle of the image(For moving Video)
% % filter mit 1/2 size of the image
% [m,n] = size(Igray1);
% F = ones(m,n);
% F(m/4:3*m/4,n/4:3*n/4)=0;
% Igray1 = F.*Igray1;
% Igray2 = F.*Igray2;
%
% % filter mit 3/4 size of the image
% [m,n] = size(Igray1);
% F = ones(m,n);
% F(m/8:7*m/8,n/8:7*n/8)=0;
% Igray1 = F.*Igray1;
% Igray2 = F.*Igray2;



%% feature detection
% try 5 mals to select the best result
    for k=1:5
        [pts1h,pts2h] = functions.matchedinlierspoint(Igray1,Igray2);

        % Algorithmus to determin the parameter of the Transform Matrix
        State =2;       % 0:test nur Rotation 
                        % 1:test Rotation and Focal length
                        % 2:test Rotation mit Translation (our Algorithmus)
                        % 3:test Rotation mit seperate Translation Teil       
        switch State
            case 0        
                [p0,J,W,J0] = J_Rotation(pts1h,pts2h,State,frame_size);
            case 1
                [p0,J,W,J0] = J_Rotation_focal(pts1h,pts2h,State,frame_size);
            case 2
                [p0,J,W,J0] = J_Rotation_Translation(pts1h,pts2h,State,frame_size);
            case 3
                [p0,J,W,J0] = J_Rotation_Translation_seprate(pts1h,pts2h,State,frame_size);
        end
        
        P_0(k,:) = p0;
        J_0(k) = J;
        Pts1h(k).data = pts1h;
        Pts2h(k).data = pts2h;  % Subscripted assignment dimension mismatch.

    end
    
    Index = find(J_0==min(J_0));
    J = J_0(Index);
    p0 = P_0(Index,:);
    pts1h = Pts1h(Index).data; 
    pts2h = Pts2h(Index).data;

    % Auswert
%     functions.AuswertForImageregistration(p0,pts1h,pts2h,frame_size,State,Igray1) 

    % Transform Matrix
    p2_1 =zeros(frame_size);
    p2_2 =zeros(frame_size);
    
    if State == 0
       invW = W^-1;
       invW = invW/invW(end); 
       for m=1:frame_size(1)     
           for n=1:frame_size(2)  
                p2 = invW*[n,m,1].';
                p2 = p2/p2(3);
                p2_1(m,n) = p2(1);
                p2_2(m,n)=  p2(2);  

           end 
       end  
    end

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
p2new = interp2(Igray2,p2_1,p2_2);        
% figure;imshowpair(Igray1,p2new);
  
%% Transformed teil_Image

Y2new(:,:,j) = interp2(yuv(2).Y,p2_1,p2_2);  
U2new(:,:,j) = interp2(yuv(2).U,p2_1,p2_2); 
V2new(:,:,j) = interp2(yuv(2).V,p2_1,p2_2);  
% figure;imshow(yuv(j).Y/255),title('yuv.Y');
% figure;imshow(yuv(j).U/255),title('yuv.Y');
% figure;imshow(yuv(j).V/255),title('yuv.Y');

%% Differenzbild

% diff_U(:,:,j-1) = yuv(i).U - U2new(:,:,j);
% diff_V(:,:,j-1) = yuv(i).V - V2new(:,:,j);
% diff_U_origin(:,:,j-1) = yuv(i).U - yuv(2).U;
% diff_V_origin(:,:,j-1) = yuv(i).V - yuv(2).V;
% figure;imshow(diff_U),title('U new diff');
% figure;imshow(diff_V),title('V new diff');
% figure;imshow(diff_U_origin),title('U origin diff');
% figure;imshow(diff_V_origin),title('V origin diff');
%  imwrite(E,[[cd,'\difftrans\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png'])

  end

%% Show the transformed Images

% implay(mat2gray(gather(Y2new(:,:,:))));
% implay(mat2gray(gather(U2new(:,:,:))));
% implay(mat2gray(gather(V2new(:,:,:))));



%% P0 parameter include Rotation 
function [p0,J,W,J0] = J_Rotation(pts1h, pts2h, State,frame_size)
p0=[0 0 0];
dp=[2 2 2 ]; % mit 0.1 grad ver�ndern 
term_dp=[0.001 0.001 0.001 ]; % threshold 0.001 grad
[p0,J,W,J0] = functions.J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size,State);
end

%% P0 parameter include Rotation and Focal length: 
function [p0,J,W,J0] = J_Rotation_focal(pts1h, pts2h, State,frame_size)
p0=[0 0 0 -3270];  % 3200 or -3200
dp=[2 2 2 5]; % mit 0.1 grad ver�ndern and focal length mit 1 pixel
term_dp=[0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = functions.J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation Translation und Focal length:
function [p0,J,W,J0] = J_Rotation_Translation(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 0.01 0.01 0.01]; % % mit 0.1 grad ver�ndern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.000001 0.000001 0.000001]; % 
[p0,J,W,J0] = functions.J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

%% P0 parameter include Rotation und seprate Translation:
function [p0,J,W,J0] = J_Rotation_Translation_seprate(pts1h, pts2h, State,frame_size)
p0=[0 0 0 0 0];  % first 3 Rotation others Translation
dp=[2 2 2 1 1]; % mit 0.1 grad ver�ndern and 0.1 mm Translation
term_dp=[0.001 0.001 0.001 0.001 0.001]; % 
[p0,J,W,J0] = functions.J_optimizieren(p0, dp, term_dp, pts1h, pts2h, frame_size, State);
end

