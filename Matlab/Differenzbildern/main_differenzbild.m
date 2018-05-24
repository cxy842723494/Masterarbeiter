    
    clean;
%     close all;
%% load the image from the camera
        
    % load image from the file
% for k = 1:2
%     [filename,filepath] = uigetfile('*.*','Select the image');
%     if isequal(filename,0)||isequal(filepath,0)
%         return;
%     else
%         filefullpath = [filepath,filename];
%     end
% %     img = imread(filefullpath);
% %     fn(:,:,:,k) = img;
%     [yuv(k).Y, yuv(k).U, yuv(k).V] = readYUV(filefullpath);
%     
% end

%     tic;
    % test sample
%     fn1 = 'YUV_2018_04_20_09_34_44_823.yuv';
%     fn2 = 'YUV_2018_04_20_09_34_44_795.yuv';
    
%     [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
%     [yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);
    
%     diff_Y = yuv(1).Y - yuv(2).Y;
%     diff_U = yuv(1).U - yuv(2).U;
%     diff_V = yuv(1).V - yuv(2).V;
     
%     load('diffc_Uo.mat');
%     diff_U = diffc_Uo;
    load('diffc_U.mat');
    diff_U = diffc_U;
    Img = diff_U;
%     figure,imshow(Handles.img,[]),title('Differenzbild');
    
%% Bild Pretreat

    threshold = graythresh(Img);
    grain = 3;
%     tic;
    Handles.img = imgPreprosessing(Img,threshold,grain);
%     toc;
    
%% locating the Finder Patterns and Recognition
    
    [FiPx,FiPy,ux,vx,cr] = detectFIP(Handles.img);
   
%% plot results Differenzbild
    cr = cr.';
    [y,i] = sort(cr(2,:));
    x = cr(1,i);
    [x(1:2),i] = sort(x(1:2));
    y(1:2) = y(i);
    [x(4:-1:3),i] = sort(x(3:4));
    y(3:4) = y(5-i);

    figure, imshow(diff_U,[]),hold on

    plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
    plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
    plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
    plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)
    toc;