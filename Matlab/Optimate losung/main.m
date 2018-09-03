clean;
close all;
%% Load the imagesf from the floder

file_path = uigetdir('D:\xch\Daten\xch\','Select the Folder');

%% ImageRegistration

[Y2new,U2new,V2new] = functions.imageRegistration(file_path);
% implay(mat2gray(gather(Y2new(:,:,:))));
% implay(mat2gray(gather(U2new(:,:,:))));
% implay(mat2gray(gather(V2new(:,:,:))));

%% Differentbild

diff = functions.creatDifferentbild(U2new);
Mal_num = 3;
% Nofind = 0;
% implay(mat2gray(gather(diff(:,:,:))));
while true

diffplus = functions.sum_of_diff(abs(diff),Mal_num);

% implay(mat2gray(gather(diff(:,:,:))));    %abs(diff(:,:,:))
 figure,imshow(diffplus,[]),title('zu detektierendes Diffrenzbild');
% figure;histogram(diffplus);
% diffplus = uint8(diffplus);

%% Bild Pretreat

% Handles.img = imgPreprosessing(Img,threshold,grain);
% Bw_morpho =imopen(imclose(diffplus,ones(5)),ones(5));

[BW,~] = functions.imageSegementer(diffplus);
% figure;imshow(BW),title('BW');

%% QR Pattern detection

[FiPx,FiPy,ux,vx,cr,tformY,Nofind] = detectFIP(BW);

if Nofind
    Mal_num = Mal_num+1;
else 
    break;
end

end
%% plot Result

% fn1='YUV_2018_07_06_17_08_50_411.yuv';
% [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(fn1);
% U1 = U2new(:,:,1);

figure, imshow(Y2new(:,:,1),[]),title('Modelationsbereich'),hold on
functions.plotResult(cr);


Y = imwarp(Y2new(:,:,1), tformY, 'OutputView', imref2d(size(Y2new(:,:,1))));
figure, imshow(Y,[]),title('Ergebnisse'),hold on;
    
% for i =200:200:1080
%      for j = 200:200:1920
%         plot(j,i,'r.');
%      end 
% end

figure, imshow(U2new(:,:,1),[]),hold on
functions.plotResult(cr);






