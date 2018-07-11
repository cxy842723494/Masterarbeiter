clean;

%% Load the imagesf from the floder
    file_path = uigetdir('D:\xch\Daten\xch\','Select the Folder'); 

%% ImageRegistration
    [Y2new,U2new,V2new] = functions.imageRegistration(file_path);
    implay(mat2gray(gather(Y2new(:,:,:))));
    implay(mat2gray(gather(U2new(:,:,:))));
    implay(mat2gray(gather(V2new(:,:,:))));

%% Differentbild 
    diff = functions.creatDifferentbild(U2new); 
    Mal_num = 3;
    diffplus = functions.sum_of_diff(diff,Mal_num);
    
    implay(mat2gray(gather(diff(:,:,:))));   
    figure;imshow(diffplus),title('diffplus');    

%% Bild Pretreat

%     threshold = graythresh(diffadd);
    BW = imbinarize(diffadd,40);
%     BW1 = imbinarize(diffadd.10);
    figure;imshow(BW),title('BW');    
%     grain = 3;

%     Handles.img = imgPreprosessing(Img,threshold,grain);
    Bw_morpho =imopen(imclose(BW,ones(5)),ones(5));   
    figure;imshow(Bw_morpho),title('Bw_morpho');   
     
    [FiPx,FiPy,ux,vx,cr] = detectFIP(Bw_morpho);
     
 %% plot Result
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

     

    
