function [E,OhneE] = registerSingeltransform(img_path_list,file_path,Index1,Index2) 
                image_name1 = img_path_list(Index1).name;    %  image1                 
                [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
                image_name2 = img_path_list(Index2).name;    %  image2  
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
                E = imcrop(diffc_U,[11 11 1899 1059]);
%                 E = imcrop(abs(diffc_U),[11 11 1899 1059]);
                OhneE = yuv(1).U- yuv(2).U;
end