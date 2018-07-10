r = 0.0625;
wide = 32;
filt = rcosdesign(r,wide,2,'normal');
filt2d = filt.'*filt;
filt2d = 4*filt2d/sum(filt2d(:));
n = wide + 1;
x = zeros(n);
y = zeros(n);
for k=1:n
    x(k,:) = k+(1:n)-1;
    y(k,:) = k+(n:-1:1)-1;
end
ind = sub2ind(size(filt2d),x,y);
filtrot = filt2d(ind);