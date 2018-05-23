i = imread('theatre.jpg');


i = rgb2gray(i);
i = double(Img);

out1 = log(1+i)/0.065;
out2 = log(1+i)/0.035;
out1(find(out1>255)) = 255;
out2(find(out2>255)) = 255;
out1 = uint8(out1);
out2 = uint8(out2);

figure,imshow(out1,[]);
figure,imshow(out2,[]);