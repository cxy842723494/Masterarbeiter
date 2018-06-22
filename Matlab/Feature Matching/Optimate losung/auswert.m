x1 = x1(1:2,:)';x2 = x2(1:2,:)';pX1 = pX1(1:2,:)';
fn1 ='YUV_2018_06_20_17_08_45_933.yuv';
[yuv(1).Y,yuv(1).U,yuv(1).V]= readYUV(fn1);
Igray1 = yuv(1).Y/255;
figure,imshow(Igray1);
hold on;
plot(x1(:,1),x1(:,2),'b.');
plot(x2(:,1),x2(:,2),'r.');
plot(pX1(:,1),pX1(:,2),'g.');


% ?????????????
dxy = dxy.';
figure,
for i = 1:size(pX1(:,1),1)
    th(i) = atan2d(dxy(i,2),dxy(i,1));
 plot([0,dxy(i,1)],[0,dxy(i,2)]);
 hold on;

end
figure,b=bar(th);
