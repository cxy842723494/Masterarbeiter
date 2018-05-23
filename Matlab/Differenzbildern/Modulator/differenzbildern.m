% load('videomitdata.mat');
load('currentFrames1113111.mat');
fn1 = currentFrames(:,:,:,1);
fn2 = currentFrames(:,:,:,2);

% rgb to yuv transfer
Trgb2yuv = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5000; 0.5000 -0.4542 -0.0458]; % BT.709
   
fn1_Y = Trgb2yuv(1,1)*fn1(:,:,1)+Trgb2yuv(1,2)*fn1(:,:,2)+Trgb2yuv(1,3)*fn1(:,:,3);
fn1_U = Trgb2yuv(2,1)*fn1(:,:,1)+Trgb2yuv(2,2)*fn1(:,:,2)+Trgb2yuv(2,3)*fn1(:,:,3);
fn1_V = Trgb2yuv(3,1)*fn1(:,:,1)+Trgb2yuv(3,2)*fn1(:,:,2)+Trgb2yuv(3,3)*fn1(:,:,3);

fn2_Y = Trgb2yuv(1,1)*fn2(:,:,1)+Trgb2yuv(1,2)*fn2(:,:,2)+Trgb2yuv(1,3)*fn2(:,:,3);
fn2_U = Trgb2yuv(2,1)*fn2(:,:,1)+Trgb2yuv(2,2)*fn2(:,:,2)+Trgb2yuv(2,3)*fn2(:,:,3);
fn2_V = Trgb2yuv(3,1)*fn2(:,:,1)+Trgb2yuv(3,2)*fn2(:,:,2)+Trgb2yuv(3,3)*fn2(:,:,3);

diffc_U = fn1_U-fn2_U;
figure,imshow(diffc_U,[]);
save diffc_U diffc_U;
diffc_V = fn1_V-fn2_V;
