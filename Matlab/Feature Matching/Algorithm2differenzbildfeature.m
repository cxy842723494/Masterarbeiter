 clean;
% close all;

% Step1. load imagea
    file_path = uigetdir('D:\xch\Daten\','Select the Folder');     % '*.*', path of the folder
    % file_path =  'D:\xch\Daten\xch\2305\';    
    % file_path =  'G:\googlexl\a5\dark\';   
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
    img_num = length(img_path_list);                    % number of the processing images
    Energie = zeros(img_num,img_num);
    Central = [950,530];  % size(E)/2;
    filepath=pwd;               %  save the current work directory
    
    cd(file_path) 
    mkdir difftrans;                    %  save the diff-data in diff folder
    if img_num > 0                 %    load image 
            for i = 1:img_num         
                for j = i+1:img_num    % j=1:img_num mean all diff ,but actually wo just need half of the data (note Feature19)
                image_name1 = img_path_list(i).name;    %  image1                 
                [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
                image_name2 = img_path_list(j).name;    %  image2  
                [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  
                
                I1 = imresize(yuv(1).Y,[1080 1920]);
                I1 = I1/255; 
%                 figure, histogram(I1);
                I2 = imresize(yuv(2).Y,[1080 1920]);
                I2 = I2/255; 
%                 figure, histogram(I2);
               
                MOVINGREG = registerImages(I1,I2);
                
%                 figure,imshow(MOVINGREG.RegisteredImage);
                tformY = MOVINGREG.Transformation;    
                
                U_teil1new = imwarp(yuv(1).U, tformY,'OutputView', imref2d(size(yuv(1).U)));
                diffc_U = U_teil1new - yuv(2).U;
%                 figure,imshow(abs(diffc_U),[]),title('after transform data diffc in U');figure,histogram(diffc_U)
                E = imcrop(abs(diffc_U),[11 11 1899 1059]);
%                 figure,imshow(E,[]),figure, histogram(E);

               %% central of the image

                %% 1/2 teil of the image

                %% 1/4 teil of the image

                %%  weiter
                energie = meansqr(E);
                Energie(i,j) = energie;              
                
%                 imwrite(E,[[cd,'\difftrans\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png'])
                end
            end
    end
      cd(filepath) 
                
      
    [m,n]=size(Energie);
    v=sort(reshape(Energie,1,m*n),'descend');
    v=v(1:4);           
    idx=zeros(1,4);
    idy=zeros(1,4);
        diffsum=zeros(size(E));
        for i=1:4
            [idx(i),idy(i)]=find(Energie==v(i));
            diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
%             Scr =['number:',num2str(i)];
%             figure,imshow(diffc(:,:,i),[]),title(Scr);
            diffsum = diffsum+diffc(:,:,i);
        end
        
%         diffsum = diffsum+diffc(:,:,i);
        diffreturn = zeros(1080,1920);
        for i=1:1060
            for j=1:1900
                diffreturn(i+10,j+10) = diffsum (i,j);
            end
        end
        
        Img = imresize(diffreturn,2);
        figure,imshow(diffsum,[])
        figure,imshow(abs(Img),[]);
        
        
        
%% Single Differnzbild mit Registration      
    Index1 = 11;
    Index2 = 13;
    [diff,Ohnediff] =  registerSingeltransform(img_path_list,file_path,Index1,Index2) ; 
    figure,imshow( diff,[]),title('mit transform');
    figure,imshow( abs(diff),[]),title('mit transform');
    figure,imshow( Ohnediff,[]),title('ohne transform');
%     figure,imshow( imbinarize(diff,10));
    figure,histogram(diff);

                
               