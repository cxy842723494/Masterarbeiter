I1 = imread('IMG_0348.jpg');

I1 = rgb2gray(I1);
imgc = edge(I1,'Canny');
imgs = edge(I1);

figure, imshow(imgc),title('canny');
figure, imshow(imgs),title('sobel');