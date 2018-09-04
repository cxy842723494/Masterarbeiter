% this part of fuction is to estimate the image registration, 
% i.e von hand held camera images to restruction image,
% to provide the hande shake by catching the images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: camera images von the folder
% output: durch the restructuring images to generate the differenzbild
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y2new,U2new,V2new] = separateYUV(file_path)

     file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));    
    img_num = length(img_path_list);
    
    % Read YUV 
    for i = 1:img_num
    image_name1 = img_path_list(i).name;              
    [yuv(i).Y,yuv(i).U,yuv(i).V] = functions.readYUV(strcat(file_path,image_name1));  
    yuv(i).Y = imresize(yuv(i).Y,0.5,'nearest');
    Igray1 = yuv(i).Y/255;
    frame_size = size(Igray1);
%     Igray1ori = yuv(1).Y/255;
    
    Y2new(:,:,i) = yuv(i).Y; 
    U2new(:,:,i) = yuv(i).U; 
    V2new(:,:,i) = yuv(i).V; 
    end
    
end

