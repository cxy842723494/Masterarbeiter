load('G:\0907\7\daten.mat');
num = size(U2new,3);
k=1;
for  i= 1:num
    for j= i+1:num
        diff(:,:,k)=U2new(:,:,i)-U2new(:,:,j);
        k=k+1;
    end
end
implay(mat2gray(gather(diff(:,:,:))));
