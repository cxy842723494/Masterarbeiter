close all;

cr_hough_cd = [x;y]; 
cr_hough = [x;y];
cr_randon = [x;y];
cr_randon_cd = [x;y]; 

figure, imshow(diffc_r,[]),hold on;

plot(cr_hough_cd(1,1),cr_hough_cd(2,1), 'r.');
plot(cr_hough_cd(1,2),cr_hough_cd(2,2), 'r.');
plot(cr_hough_cd(1,3),cr_hough_cd(2,3), 'r.');
plot(cr_hough_cd(1,4),cr_hough_cd(2,4), 'r.');
% legend('x1','x2','Px1');

plot(cr_hough(1,1),cr_hough(2,1), 'g.');
plot(cr_hough(1,2),cr_hough(2,2), 'g.');
plot(cr_hough(1,3),cr_hough(2,3), 'g.');
plot(cr_hough(1,4),cr_hough(2,4), 'g.');

plot(cr_randon(1,1),cr_randon(2,1), 'b.');
plot(cr_randon(1,2),cr_randon(2,2), 'b.');
plot(cr_randon(1,3),cr_randon(2,3), 'b.');
plot(cr_randon(1,4),cr_randon(2,4), 'b.');

plot(cr_randon_cd(1,1),cr_randon_cd(2,1), 'y.');
plot(cr_randon_cd(1,2),cr_randon_cd(2,2), 'y.');
plot(cr_randon_cd(1,3),cr_randon_cd(2,3), 'y.');
plot(cr_randon_cd(1,4),cr_randon_cd(2,4), 'y.');

for i =1:4
    
    plot(cr_randon(1,i),cr_randon(2,i), 'b.');
    
end

