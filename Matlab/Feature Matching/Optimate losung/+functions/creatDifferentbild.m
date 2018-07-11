%% creat the Differenzbild von the transformed Images
function diff = creatDifferentbild(Img)
    k=1;
    img_num = size(Img,3);
    for  i= 1:img_num
        for j= i+1:img_num
            diff(:,:,k)=Img(:,:,i)-Img(:,:,j);       
            k=k+1;
        end
    end