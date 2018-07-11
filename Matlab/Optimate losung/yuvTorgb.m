clean;
 
file_path = uigetdir('D:\xch\Daten\xch\1107');     % '*.*', path of the folder
% file_path = uigetdir('G:\','Select the Folder'); 
file_path = strcat(file_path,'\');
img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
img_num = length(img_path_list);        

filepath=pwd;                 %  save the current work directory
cd(file_path) 
mkdir GRB;                    %  save the diff-data in diff folder

if img_num > 0                %  load image 
    for i = 1:img_num         
            image_name1 = img_path_list(i).name;    %  image1                 
            [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
            Image = yuv2rgb(yuv(1).Y,yuv(1).U,yuv(1).V,'YUV420_8','BT709_l');    
            imwrite(Image,[[cd,'\GRB\'],'test-',sprintf('%02d',i),'.png']);
    end
end