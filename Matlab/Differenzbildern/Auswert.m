figure, imshow(im,[]);
hold on;
plot(93.77,44.85, 'g.');
plot(100.3,44.78, 'r.');

plot(1875,26.05, 'g.');
plot(1870,23.16, 'r.');

plot(87.26,1040, 'g.');
plot(84.69,1039, 'r.');

plot(1883,1043, 'g.');
plot(1884,1042, 'r.');

plot(corners(1,1),corners(2,1), 'r.');
plot(corners(1,2),corners(2,2), 'r.');
plot(corners(1,3),corners(2,3), 'r.');
plot(corners(1,4),corners(2,4), 'r.');

stats = regionprops(BW1,'Centroid');
cr1 = stats.Centroid(:,1);
figure, imshow(diff,[]);hold on;
 plot(471.,234.17950505402,'r');