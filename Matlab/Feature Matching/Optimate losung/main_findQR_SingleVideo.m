clean;
load('G:\0607\text in Video from still image (ohne stativ mit Data)\diffnew\diff_Unew.mat');

implay(mat2gray(gather(diff_Unew(:,:,:))));

 
num  = size(diff_Unew(:,:,:),3); 
energie = zeros(1,num);

for i = 1:num
energie(i) = meansqr(diff_Unew(:,:,i));
end
clear i;

v=sort(energie,'descend');%,'descend'
v=v(1:4);           
 idx=zeros(1,4);
 for i=1:4
        idx(i)=find(energie==v(i));
 end
 
 diffadd = zeros(size(diff_Unew(:,:,1)));
    for k=1:4

    %  diffadd=  diffadd+diff(:,:,k);
        diffadd=  diffadd+diff_Unew(:,:,idx(k));

    end
    figure;imshow(diffadd),title('diff');
%    
%     BW91=imbinarize(abs(diff_Unew(:,:,91)),20);
%     figure;imshow(BW91),title('91');    
% 
%     figure;imshow(diff_Unew(:,:,91)),title('91');
%     figure;histogram(diff_Unew(:,:,86)),title('86');


%% Bild Pretreat

    threshold = graythresh(diffadd);
    BW = imbinarize(diffadd,10);
    figure;imshow(BW),title('BW');    
    grain = 3;

    Handles.img = imgPreprosessing(Img,threshold,grain);
    
    
