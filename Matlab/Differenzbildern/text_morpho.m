qr_base= [
    1 1 1 1 1 1 1 1 1;
    1 0 0 0 0 0 0 0 1;
    1 0 1 1 1 1 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 0 0 0 1 0 1;
    1 0 1 1 1 1 1 0 1;
    1 0 0 0 0 0 0 0 1;
    1 1 1 1 1 1 1 1 1];

qr = imresize(qr_base.*9, 12, 'nearest');
figure,imshow(qr);
qr_erosion = imerode(qr,ones(12));
figure,imshow(qr_erosion);
qr_morpho = imopen(qr,ones(13));
figure,imshow(qr_morpho);