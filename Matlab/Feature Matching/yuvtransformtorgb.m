 clean;
% close all;


%% Step. load imagea
    file_path = uigetdir('D:\xch\Daten\','Select the Folder');     % '*.*', path of the folder
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
    img_num = length(img_path_list);                    % number of the processing images
    filepath=pwd;               %  save the current work directory
    cd(file_path) 
    mkdir rgb;   
    for i=1:img_num
        
        image_name = img_path_list(i).name; 
        [yuv.Y,yuv.U,yuv.V] =  readYUV(strcat(file_path,image_name));  
        Img = yuv2rgb(yuv.Y,yuv.U,yuv.V,'YUV420_8','BT709_l');
        imwrite(Img,[[cd,'\rgb\'],'test-',sprintf('%02d',i),'.jpg']);
    end
    
    