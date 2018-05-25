figure,imshow(diffc_U,[])
figure,imshow(diffc_Uo,[])

mean2(abs(diffc_U));
mean2(abs(diffc_Uo));
std(diff_U(:));
std(diffc_Uo(:));
mean2(diff_U);
mean2(diffc_Uo);





file_path =  'D:\xch\Daten\xch\2305\';% ???????  
img_path_list = dir(strcat(file_path,'*.yuv'));%?????????jpg?????  
img_num = length(img_path_list);%???????  
if img_num > 0 %????????  
        for i = 1:img_num %??????  
            for j = i+1:img_num
            image_name = img_path_list(i).name;% ???  
            image =  imread(strcat(file_path,image_name));  
            fprintf('%d %d %s\n',i,i,strcat(file_path,image_name));% ??????????  
            %?????? ??
            end
        end  
end 