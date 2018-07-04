 clean;
% close all;

% fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
% fn2 ='YUV_2018_06_20_17_08_45_919.yuv';
%% Step. load imagea
    file_path = uigetdir('D:\xch\Daten\','Select the Folder');     % '*.*', path of the folder
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
    img_num = length(img_path_list);                    % number of the processing images
    Energie = zeros(img_num,img_num);
    
    
    if img_num > 0                 %    load image 
            for i = 1:img_num         
                for j = i+1:img_num    % j=1:img_num mean all diff ,but actually wo just need half of the data (note Feature19)
                image_name1 = img_path_list(i).name;    %  image1                 
                [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
                image_name2 = img_path_list(j).name;    %  image2  
                [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  
                
                I1 = imresize(yuv(1).Y,0.5,'nearest');                
                I1 = I1/255;
%                 figure,imshow(I1,[]);figure, histogram(I1);
                              
                I2 = imresize(yuv(2).Y,0.5,'nearest');
                I2 = I2/255; 
%                 figure,imshow(I2,[]);figure, histogram(I2);
                figure, imshowpair(I1,I2,'montage')
                figure, imshowpair(I1,I2)
                MOVINGREG = RANSAC(I1,I2);
                MOVINGREG = registerImagestext(I1,I2);
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

