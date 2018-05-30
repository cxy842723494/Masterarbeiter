close all;  
clear ;  
clc;  
  
img=imread('lena.jpg');  
[h w]=size(img);  
imgn=imresize(img,[floor(h/2) floor(w/2)]);  
imgn=imresize(imgn,[h w]);  
img=double(img);  
imgn=double(imgn);  
  
B=8;                %?????????????  
MAX=2^B-1;          %????????  
MES=sum(sum((img-imgn).^2))/(h*w);     %???  
PSNR=20*log10(MAX/sqrt(MES));           %????? 