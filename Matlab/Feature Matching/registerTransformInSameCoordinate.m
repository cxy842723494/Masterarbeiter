function [diffc] = registerTransformInSameCoordinate(img_path_list,file_path,Index1,Index2) 

%     for i =Index1:Index2-Index1:Index2
    for i =2:15
                image_name1 = img_path_list(i).name;    %  image1                 
                [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
                image_name2 = img_path_list(1).name;    %  image2  
                [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  
                
                I1 = imresize(yuv(1).Y,[1080 1920]);
                I1 = I1/255; 
%                 figure, histogram(I1);
                I2 = imresize(yuv(2).Y,[1080 1920]);
                I2 = I2/255; 
%                 figure, histogram(I2);
               
                MOVINGREG = registerImagestext1(I1,I2);
                
%                 figure,imshow(MOVINGREG.RegisteredImage);
                tformY = MOVINGREG.Transformation;    
                
%                 U_teil1new = imwarp(yuv(1).U, tformY,'OutputView', imref2d(size(yuv(1).U)));
%                 diffc_U = U_teil1new - yuv(2).U;
%                 figure,imshow(abs(diffc_U),[]),title('after transform data diffc in U');figure,histogram(diffc_U)
                U_teil(:,:,i) = imwarp(yuv(1).U, tformY,'OutputView', imref2d(size(yuv(1).U)));
                V_teil(:,:,i) = imwarp(yuv(1).V, tformY,'OutputView', imref2d(size(yuv(1).V)));

%                 E(:,:,i) = imcrop(diffc_U,[11 11 1899 1059]);
%                 E(:,:,i) = imcrop(abs(diffc_U),[11 11 1899 1059]);
    end
%     figure,imshow(abs(E(:,:,15)),[])
%     diffc = E(:,:,Index1)- E(:,:,Index2);
%     figure,imshow(abs(diffc),[]);
%     energie = meansqr(diffc);
%     figure,imshow(diffc,[]);
%     figure,histogram(diffc);

end
U_teil(:,:,1)=yuv(1).U;
           figure,imshow(U_teil(:,:,2),[]);
           V_teil(:,:,1)=yuv(1).V;
           figure,imshow(V_teil(:,:,2),[]);