clean;
%% load the image
    file_path = uigetdir('G:\','Select the Folder');     % '*.*', path of the folder
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
    img_num = length(img_path_list);                    % number of the processing images
%     Energie = zeros(img_num,img_num);
    
    filepath=pwd;               %  save the current work directory
    cd(file_path) 
%     mkdir diffnew;  
%     mkdir difforigin;
num = 1;
if img_num > 0                 %    load image 
    for i = 1:img_num         
        for j = i+1:img_num    % j=1:img_num mean all diff ,but actually wo just need half of the data (note Feature19)
        image_name1 = img_path_list(i).name;    %  image1                 
        [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
        image_name2 = img_path_list(j).name;    %  image2  
        [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  


% fn1 ='YUV_2018_07_06_17_08_50_411.yuv';
% fn2 ='YUV_2018_07_06_17_08_50_419.yuv';
% fn2 ='YUV_2018_07_06_17_08_50_815.yuv';

% [yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
% [yuv(2).Y,yuv(2).U,yuv(2).V]= readYUV(fn2);

yuv(1).Y = imresize(yuv(1).Y,0.5);%,'nearest'
yuv(2).Y = imresize(yuv(2).Y,0.5);%,'nearest'
Igray1 = yuv(1).Y/255;
Igray2 = yuv(2).Y/255;

% diff_U = imageRegistration(Igray1,Igray2,yuv);
diff_U(:,:,num) = imageRegistration(Igray1,Igray2,yuv);
num = num+1;
% figure;imshow(diff_U(:,:,2),[]),title('new diff');
%  imwrite(diff_U(:,:,:,num),[[cd,'\diffnew\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png']);
%  imwrite(diff_U(:,:,:,num),[[cd,'\difforigin\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png']);
             end
       end
 end
%%
implay(mat2gray(gather(diff_U(:,:,:))));


