clean;
close all;

profile on;
%% Load the imagesf from the floder

file_path = uigetdir('D:\xch\Daten\xch\','Select the Folder');

%% ImageRegistration
tic;
[Y2new,U2new,V2new] = functions.imageRegistration(file_path);
toc;
% implay(mat2gray(gather(Y2new(:,:,:))));
% implay(mat2gray(gather(U2new(:,:,:))));
% implay(mat2gray(gather(V2new(:,:,:))));

%% Differenzbild
tic;
diff = functions.creatDifferentbild(V2new);
Mal_num = 3;
% Nofind = 0;
% implay(mat2gray(gather(diff(:,:,:))));
% figure,imshow(diff(:,:,19),[]);
% figure, subplot(3,2,1),imshow(diff(:,:,1))
% subplot(3,2,2),imshow(diff(:,:,1));
% subplot(3,2,3),imshow(diff(:,:,1));
% subplot(3,2,4),imshow(diff(:,:,1));
% subplot(3,2,5),imshow(diff(:,:,1));
% subplot(3,2,6),imshow(diff(:,:,1));
% while true

diffplus = functions.sum_of_diff(abs(diff),Mal_num);
toc;
% implay(mat2gray(gather(diff(:,:,:))));    %abs(diff(:,:,:))
%  figure,imshow(diffplus,[]),title('zu detektierendes Diffrenzbild');
% figure;histogram(diffplus);
% diffplus = uint8(diffplus);

%% Bild Pretreat

% Handles.img = imgPreprosessing(Img,threshold,grain);
% Bw_morpho =imopen(imclose(diffplus,ones(5)),ones(5));
tic;
[BW,~] = functions.imageSegementer(diffplus);
% figure;imshow(BW),title('BW');
toc;
%% QR Pattern detection
tic;
[FiPx,FiPy,ux,vx,cr,tformY,Nofind] = detectFIP(BW);
toc;


%%
if Nofind
    Mal_num = Mal_num+1;
% else 
%     break;
end

% end
%% plot Result

% fn1='YUV_2018_07_06_17_08_50_411.yuv';
% [yuv(1).Y,yuv(1).U,yuv(1).V] =  readYUV(fn1);
% U1 = U2new(:,:,1);

figure, imshow(Y2new(:,:,1),[]),title('Modelationsbereich'),hold on,axis normal;
functions.plotResult(cr);


A =diff(:,:,26);
[a,b]= find(isnan(A));
     for i = 1:size(a)
        A(a(i),b(i))=0;
     end
A = imwarp(A, tformY, 'OutputView', imref2d(size(A)));
figure, imshow(diff ,[]),title('V-Kanal'),hold on;

Y = imwarp(Y2new(:,:,1), tformY, 'OutputView', imref2d(size(Y2new(:,:,1))));
figure, imshow(Y,[]),title('Ergebnisse'),hold on;
    
% for i =200:200:1080
%      for j = 200:200:1920
%         plot(j,i,'r.');
%      end 
% end

% figure, imshow(U2new(:,:,1),[]),hold on
% functions.plotResult(cr);

profile viewer;




