 
fn1 = 'YUV_2018_09_03_10_47_07_735.yuv';


[yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(fn1);

figure, imshow( yuv(1).Y,[]),hold on;