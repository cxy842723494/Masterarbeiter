
function [] = auswert(p0,x1,x2,frame_size,State,Igray1) 

[~,x1,x2,pX1,dxy] = objective_fun(p0,x1,x2,frame_size,State);
X1 = x1(1:2,:)';X2 = x2(1:2,:)';PX1 = pX1(1:2,:)';

figure,imshow(Igray1);
hold on;
plot(X1(:,1),X1(:,2),'b.');
plot(X2(:,1),X2(:,2),'r.');
plot(PX1(:,1),PX1(:,2),'g.');legend('x1','x2','Px1')

dxy1 = dxy(1,:);
dxy2 = dxy(2,:);
% figure,bar(dxy1);
figure,histogram(dxy1),title('dxy1');
figure,histogram(dxy2),title('dxy2');

dxy = dxy.';
figure,
    for i = 1:size(pX1(1,:),2)
        th(i) = atan2d(dxy(i,2),dxy(i,1));
     plot([0,dxy(i,1)],[0,dxy(i,2)]);
     hold on;
    end
figure,histogram(th);
% bar(th);

end


