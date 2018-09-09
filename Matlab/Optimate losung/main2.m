clean;
close all;
%% Load the imagesf from the floder

file_path = uigetdir('D:\xch\Daten\xch\','Select the Folder');

%% separateYUV
tic
[Y2new,U2new,V2new] = functions.separateYUV(file_path);  
toc
%    implay(mat2gray(gather(Y2new(:,:,:))));
%    implay(mat2gray(gather(U2new(:,:,:))));
%    implay(mat2gray(gather(V2new(:,:,:))));

%% Differentbild
tic;
diff = functions.creatDifferentbild(U2new);

Mal_num = 5;
tic
diffplus = functions.sum_of_diff(abs(diff),Mal_num);
toc;
%  implay(mat2gray(gather(diff(:,:,:))));    %abs(diff(:,:,:))
%  figure,imshow(diffplus,[]),title('zu detektierendes Diffrenzbild');



%% Bildverarbeitung
tic

diffc_r  = diffplus;
%    figure,imshow(diffc_r,[]),title('diffc_r');

[select,maskedImage]  = functions.binar(diffc_r);
%    figure,imshow(select,[]),title('binar')
 
grain =5;  % size der QR 12 
selectf2 = imopen(imclose(select,ones(grain)),ones(grain));
% figure,imshow(selectf2),title('selectf2');
%     edges = edge(selectf2); % Sobel edge detection
%     figure,imshow(edges),title('sobel');
edges = edge(selectf2,'Canny'); % Canny edge detection

% figure,imshow(edges),title('canny');

toc
%% Radon
% tic;
% cr = estimateModCorners_randon(edges);
% toc;
% tic;
% cr = estimateModCorners_hough(edges,10);
% toc;
tic;
cr = functions.estimateModCorners_randon_mitcrossdiatation(edges);
toc;
% cr = estimateModCorners_hough_mitcrossdiatation(edges,10);

%% plot results
[y,i] = sort(cr(2,:));
x = cr(1,i);
[x(1:2),i] = sort(x(1:2));
y(1:2) = y(i);
[x(4:-1:3),i] = sort(x(3:4));
y(3:4) = y(5-i);

cr_hough = [x;y];
cr_randon = [x;y];
cr_randon_cd = [x;y]; 
cr_hough_cd = [x;y]; 

% einzelbilder
% figure, imshow(yuv(1).U,[]);
figure, imshow(Y2new(:,:,1),[]);
% differenzbilder
%figure, imshow(diff(:,:,1),[])
%figure, imshow(diffplus,[])
hold on,axis normal,
plot(x(1:2), y(1:2), 'r', 'LineWidth', 2)
plot(x(2:3), y(2:3), 'r', 'LineWidth', 2)
plot(x(3:4), y(3:4), 'r', 'LineWidth', 2)
plot([x(1) x(4)], [y(1) y(4)], 'r', 'LineWidth', 2)


ux = [1,1920, 1920, 1];
vx = [1,1, 1080, 1080];

[tformY, ~, ~] = estimateGeometricTransform(...
    [x; y].', [ux; vx].', 'projective');
 Ynew = imwarp( Y2new(:,:,1), tformY, 'OutputView', imref2d(size( Y2new(:,:,1))));
 figure, imshow( Ynew,[]),hold on;

 for i =200:200:1080
     for j = 200:200:1920
        plot(j,i,'rx');
     end 
end