
clean;
% close all;
%% Select the differenz image, which has the largest energie. i.e. the clearest the image to be handled

% Step1. load imagea and calculate the differenzbild
    file_path = uigetdir('D:\xch\Daten\','Select the Folder');     % '*.*', path of the folder
    % file_path =  'D:\xch\Daten\xch\2305\';    
    % file_path =  'G:\googlexl\a5\dark\';   
    file_path = strcat(file_path,'\');
    img_path_list = dir(strcat(file_path,'*.yuv'));     % find the processing images  
    img_num = length(img_path_list);                    % number of the processing images
    Energie = zeros(img_num,img_num);
    Central = [960,540]; 
    filepath=pwd;               %  save the current work directory
    cd(file_path) 
    mkdir diff;                    %    save the diff-data in diff folder
    if img_num > 0                 %    load image 
            for i = 1:img_num         
                for j = i+1:img_num
                image_name1 = img_path_list(i).name;    %  image1 
                [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,image_name1));  
                image_name2 = img_path_list(j).name;    %  image2  
                [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,image_name2));  
                diff=  yuv(1).U - yuv(2).U;             %  diffenzbild to data
                % figure, imshow(diff,[]);figure,histogram(diff);
%                 energie = meansqr(diff);
%                 energie = sum(sum(diff.^2))/(size(diff,1)*size(diff,2)); 
               
                Teil = diff(Central(2)/2+1:Central(2)*3/2,Central(1)/2+1:Central(1)*3/2);
%                 figure,imshow(Teil,[]);
                energie = meansqr(Teil);

                Energie(i,j) = energie;

%                imwrite(diff,[[cd,'\diff\'],'test-',sprintf('%02d',i),'_',sprintf('%02d',j),'.png'])
    %            imwrite(diff,[[cd,'\diff\'],'test-',num2str(i),'_',num2str(j),'.jpg'])

                end
            end  
    end 

% find the differrenzbild with the biggest Energie
%     MaxEnergie = max(max(Energie));
%     [Index1,Index2] = find(Energie==MaxEnergie);
%     Img = imread(strcat('.\diff\','test-',sprintf('%02d',Index1),'_',sprintf('%02d',Index2),'.png'));
%     figure,imshow(Img );
    cd(filepath)   

% Obtain the biggest differenz image, which we want, the next step: deal with it.
%     Index1 = 3;
%     Index2 = 7;
%     [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,img_path_list(Index1).name));  
%     [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,img_path_list(Index2).name));  
%     diffmax =  yuv(1).U - yuv(2).U; 
%     figure,imshow( diffmax,[]);
%     figure,imshow( abs(diffmax),[]);
%     figure,histogram( abs(diffmax));
 
 
% Step2.3. choose the biggest 4 differenzbild with Energie and absolute the
% differenzbild
    [m,n]=size(Energie);
    v=sort(reshape(Energie,1,m*n),'descend');
    v=v(1:4);           
    idx=zeros(1,4);
    idy=zeros(1,4);
    for i=1:4
        [idx(i),idy(i)]=find(Energie==v(i));
%         [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(strcat(file_path,img_path_list(idx(i)).name));  
%         [yuv(2).Y,yuv(2).U,yuv(2).V] =  readYUV(strcat(file_path,img_path_list(idy(i)).name));  
%         diff(:,:,i)=  abs(yuv(1).U - yuv(2).U);  
%         str = ['The biggest text image ',num2str(i)];
%         figure,imshow( diff(:,:,i),[] ),title(str);
%         str1 = ['The histogram of biggest differenzbild',num2str(j)];
%         figure,histogram(diff(:,:,i)),title(str1);
    end
%     A = diff(:,:,1);
%     B = diff(:,:,2);
%     C = diff(:,:,3);
%     D = diff(:,:,4); 
    
    % Step4. addieren the obtained biggest didderenzbild
    diffadd = zeros(size(diff(:,:,1)));
    for k=1:4

    %  diffadd=  diffadd+diff(:,:,k);
        diffadd=  diffadd+diff(:,:,k);

    end
    str = 'The addieren differenzbild with 4 biggeset';
    figure,imshow(diffadd,[]),title(str);
    figure,histogram(diffadd),title(str);

    

%     E = imcrop(diffadd,[59 17 150 150]);

    % A = [1 2 5; 1 2 3; 1 2 3];