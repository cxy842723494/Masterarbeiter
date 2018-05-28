    clean;
    close all;
%% load 2 image
% yuv image


for i=1:2
    [filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end
    [yuv(i).Y, yuv(i).U, yuv(i).V] = readYUV(filefullpath);
    
   
end
      
%     fn1='YUV_2018_05_22_16_51_08_780.yuv';
%     fn2='YUV_2018_05_22_16_51_08_811.yuv';
% 
%     [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);
%     [yuv(2).Y, yuv(2).U, yuv(2).V] = readYUV(fn2);
%     Img1 = yuv2rgb(yuv(1).Y, yuv(1).U, yuv(1).V);
%     Img2 = yuv2rgb(yuv(2).Y, yuv(2).U, yuv(2).V);
    
    diffc_Uo = yuv(1).U - yuv(2).U;
    figure,imshow(diffc_Uo,[]),title('original data diff in U');
    save diffc_Uo diffc_Uo;histogram(diffc_Uo);
    I1 = yuv(1).Y/255;   % grayscale image
    I2 = yuv(2).Y/255;
    
%     % rgb image    
%     Img1 = imread('IMG_0305.jpg');
%     Img2 = imread('IMG_0306.jpg');
%     I1 = double(rgb2gray(Img1))./255;
%     I2 = double(rgb2gray(Img2))./255;
    
     figure, imshow(yuv(1).U,[]); 
%     figure, imshow(I1);    
%     figure, imshow(I2);  
      figure,imshowpair(I1,I2,'montage');
    %% Registration app
    
    %% weiter
    figure,imshow(movingReg.RegisteredImage);
    tformY = movingReg.Transformation;
    % U teil
    U_teil1new = imwarp(yuv(1).U, tformY,'OutputView', imref2d(size(yuv(1).U)));
    diffc_U = U_teil1new - yuv(2).U;
    figure,imshow(diffc_U,[]),title('after transform data diffc in U');figure,histogram(diffc_U)
    save diffc_U diffc_U;
    diffc_Uself = yuv(1).U - U_teil1new;
    figure,imshow(diffc_Uself),title('U after transform selfchange');
    % V teil
    V_teil1new = imwarp(yuv(1).V, tformY,'OutputView', imref2d(size(yuv(1).V)));
    diffc_V = yuv(2).V - V_teil1new;
    figure,imshow(diffc_V),title('after transform data diff in V');
    diffc_Vself = yuv(1).V - V_teil1new;
    figure,imshow(diffc_Vself),title('V after transform selfchange');

    % Y teil
    diffc_Yself = movingRegSURF.RegisteredImage- yuv(1).Y/255;
    figure,imshow(diffc_Yself,[]),title('Y teil after transform selfchange');

    figure,imshow(diffc_Vo-diffc_V,[]);
 

    
    
    
    tformY = movingReg.Transformation;
    Img1new = imwarp(double(Img1), tformY,'OutputView', imref2d(size(Img1)));
    I1new = rgb2gray(Img1new/255);
    figure, imshow(I1new);
    figure, imshow(movingReg.RegisteredImage- I1new);
    [Y1new,U1new,V1new]=rgb2yuv(Img1new(:,:,1),Img1new(:,:,2),Img1new(:,:,3),'YUV420_8','BT709_l');
    % rgb to yuv transfer
%     Trgb2yuv = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5000; 0.5000 -0.4542 -0.0458]; % BT.709
% 
%     fn2_Ynew = Trgb2yuv(1,1)*Img2new(:,:,1)+Trgb2yuv(1,2)*Img2new(:,:,2)+Trgb2yuv(1,3)*Img2new(:,:,3);
%     fn2_Unew = Trgb2yuv(2,1)*Img2new(:,:,1)+Trgb2yuv(2,2)*Img2new(:,:,2)+Trgb2yuv(2,3)*Img2new(:,:,3);
%     fn2_Vnew = Trgb2yuv(3,1)*Img2new(:,:,1)+Trgb2yuv(3,2)*Img2new(:,:,2)+Trgb2yuv(3,3)*Img2new(:,:,3);


%% Find the corners.

    % detectBRISKFeatures
%     points1 = detectBRISKFeatures(I1,'MinContrast',0.1,'MinQuality',0.2,'NumOctaves',4);
%     points2 = detectBRISKFeatures(I2,'MinContrast',0.1,'MinQuality',0.2,'NumOctaves',4);
    points1 = detectBRISKFeatures(I1);
    points2 = detectBRISKFeatures(I2);
    % detectFASTFeatures
%     points1 = detectFASTFeatures(I1,'MinQuality',0.01,'MinContrast',0.01);
%     points2 = detectFASTFeatures(I2,'MinQuality',0.01,'MinContrast',0.01);
%     points1 = detectFASTFeatures(I1);
%     points2 = detectFASTFeatures(I2);
    % detectHarrisFeatures
%     points1 = detectHarrisFeatures(I1,'MinQuality',0.001,'FilterSize',5,'ROI',[1 1 400 200]);     %  1 1 ; 1 1950 ; 3400 1950 ; 3400 1
%     points2 = detectHarrisFeatures(I2);
%     points1 = detectHarrisFeatures(I1);
%     points2 = detectHarrisFeatures(I2);
    % detectMinEigenFeatures
%     points1 = detectMinEigenFeatures(I1,'MinQuality',0.01,'FilterSize',9,'ROI',[1 1 400 200]);
%     points2 = detectMinEigenFeatures(I2);
%     points1 = detectMinEigenFeatures(I1);
%     points2 = detectMinEigenFeatures(I2);
    % detectSURFFeatures
%     points1 = detectSURFFeatures(I1,'MetricThreshold',1000,'NumOctaves',4,'NumScaleLevels',3);    % ,'ROI',[1 1 400 200]
%     points2 = detectSURFFeatures(I2);   
%     points1 = detectSURFFeatures(I1,'MetricThreshold',16000);
%     points2 = detectSURFFeatures(I2,'MetricThreshold',16000);
    % detectKAZEFeatures
%     points1 = detectKAZEFeatures(I1,'Diffusion','sharpedge','Threshold',0.001,'ROI',[3400 1 400 200] );
%     points2 = detectKAZEFeatures(I2);
%     points1 = detectKAZEFeatures(I1);
%     points2 = detectKAZEFeatures(I2);

    % detectMSERFeatures
%     points1 = detectMSERFeatures(I1,'ThresholdDelta',0.7,'RegionAreaRange',[500 14000],'MaxAreaVariation' ,0.3,'ROI',[3400 1 400 200]);
%     figure; imshow(I1); hold on;
%     plot(points1,'showPixelList',true,'showEllipses',false);
%     points1 = detectMSERFeatures(1-I1,'ThresholdDelta',0.7,'RegionAreaRange',[250000 500000],'MaxAreaVariation' ,0.3);
    
    % Extract the neighborhood features.
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    figure;subplot(1,2,1);imshow(I1); hold on
    plot(points1);
%     plot(selectStrongest(points1, 100));
     subplot(1,2,2);imshow(I2); hold on
%     plot(selectStrongest(points2, 100));
    plot(points2);
    
    % Match the features.
    indexPairs = matchFeatures(features1,features2);
    
    % Retrieve the locations of the corresponding points for each image.
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);


    
    % Visualize the corresponding points. You can see the effect of translation between the two images despite several erroneous matches.
    
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2),title('SURF');

    
%         [tformY, ~, ~] = estimateGeometricTransform(...
%         [FIPx; FIPy].', [ux; vx].', 'projective');
%     Yw(:,:,k) = imwarp(Y(:,:,k), tformY, 'OutputView', imref2d(size(Y(:,:,k))));
    
  