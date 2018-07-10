clean;
load('G:\0607\text in Video from still image (ohne stativ mit Data)\diffnew\diff_Unew.mat');

% implay(mat2gray(gather(diff_Unew(:,:,:))));

 
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

%     threshold = graythresh(diffadd);
    BW = imbinarize(diffadd);
%     BW1 = imbinarize(diffadd.10);
    figure;imshow(BW),title('BW');    
%     grain = 3;

%     Handles.img = imgPreprosessing(Img,threshold,grain);
     Bw_morpho =imopen(imclose(BW,ones(5)),ones(5));   
     figure;imshow(Bw_morpho),title('Bw_morpho');   
     
     [FiPx,FiPy,ux,vx,cr] = detectFIP(Bw_morpho);
     
 %% plot results Differenzbild
    cr = cr.';
    [y,i] = sort(cr(2,:));
    x = cr(1,i);
    [x(1:2),i] = sort(x(1:2));
    y(1:2) = y(i);
    [x(4:-1:3),i] = sort(x(3:4));
    y(3:4) = y(5-i);
    
    fn1='YUV_2018_07_06_17_08_50_411.yuv';
    [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(fn1);  
    figure, imshow(yuv(1).U,[]),hold on

    plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
    plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
    plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
    plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)

     

    
