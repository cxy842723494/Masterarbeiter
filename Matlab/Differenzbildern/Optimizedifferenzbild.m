
clean;
close all;
%% Select the differenz image, which has the largest energie. i.e. the clearest the image to be handled

file_path = uigetdir('*.*','��ѡ���ļ���');
% file_path =  'D:\xch\Daten\xch\2305\';     % ͼ���ļ���·��  
% file_path =  'G:\googlexl\a5\dark\';   
file_path = strcat(file_path,'\');
img_path_list = dir(strcat(file_path,'*.yuv'));     %��ȡ���ļ���������jpg��ʽ��ͼ��  
img_num = length(img_path_list);                    %��ȡͼ�������� 
Energie = zeros(img_num,img_num);

filepath=pwd;               %  save the current work directory
cd(file_path) 
mkdir diff;                    %  save the diff-data in diff folder
if img_num > 0                      %    ������������ͼ��  
        for i = 1:img_num          %    ��һ��ȡͼ��
            for j = i+1:img_num
            image_name1 = img_path_list(i).name;    %  image1 
            [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
            image_name2 = img_path_list(j).name;    %  image2  
            [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  
            diff=  yuv(1).U - yuv(2).U;                     %  ͼ�������
            % figure, imshow(diff,[]);figure,histogram(diff);
            energie = meansqr(diff);
%             energie = sum(sum(diff.^2))/(size(diff,1)*size(diff,2)); 
            Energie(i,j) = energie;
            
           imwrite(diff,[[cd,'\diff\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png'])
%            imwrite(diff,[[cd,'\diff\'],'test-',num2str(i),'_',num2str(j),'.jpg'])

            end
        end  
end 

% find the differrenzbild with the biggest Energie
MaxEnergie = max(max(Energie));
[Index1,Index2] = find(Energie==MaxEnergie);
% Img = imread(strcat('.\diff\','test-',sprintf('%02d',Index1),'_',sprintf('%02d',Index2),'.png'));
% figure,imshow(Img );
cd(filepath)   

%% Idea1: Obtain the biggest differenz image, which we want, the next step: deal with it.
[yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,img_path_list(Index1).name));  
[yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,img_path_list(Index2).name));  
 diff=  yuv(1).U - yuv(2).U;    
 figure,imshow( diff );
 
 %%  Idea2: use several differrenzbild , here sind the images, which has the biggest energie, through Overlay to obtain the required image
% the biggest 4 differenzbild 
 [m,n]=size(Energie);
v=sort(reshape(Energie,1,m*n),'descend');
v=v(1:4);           
idx=zeros(1,4);
idy=zeros(1,4);
for i=1:4
[idx(i),idy(i)]=find(Energie==v(i));
[yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,img_path_list(idx(i)).name));  
[yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,img_path_list(idy(i)).name));  
 diff(:,:,i)=  yuv(1).U - yuv(2).U;    
end

 





% A = [1 2 5; 1 2 3; 1 2 3];