
function [] = AuswertForImageregistration(p0,x1,x2,frame_size,State,Igray1) 

[~,x1,x2,pX1,dxy] = functions.objective_fun(p0,x1,x2,frame_size,State);
X1 = x1(1:2,:)';X2 = x2(1:2,:)';PX1 = pX1(1:2,:)';

figure,imshow(Igray1);
hold on;
plot(X1(:,1),X1(:,2),'b.');
plot(X2(:,1),X2(:,2),'r.');
plot(PX1(:,1),PX1(:,2),'g.');legend('x1','x2','Px1')

% dxy1 = dxy(1,:);
% dxy2 = dxy(2,:);
% dx=mean(abs(dxy1) );
% dy=mean(abs(dxy2) );
% sum =0;
% for i =1:826
%     if abs(dxy1(i))>0.5
%         sum=sum+1;
%     end
% end

% figure,bar(dxy1);
figure,histogram(dxy1),title('dxy1');
figure,histogram(dxy2),title('dxy2');
% 
figure,subplot(1,2,1),histogram(dxy1),title('x');
subplot(1,2,2),histogram(dxy2),title('y');
% dxy = dxy.';
% figure,
%     for i = 1:size(pX1(1,:),2)
%         th(i) = atan2d(dxy(i,2),dxy(i,1));
%      plot([0,dxy(i,1)],[0,dxy(i,2)]);
%      hold on;
%     end
% figure,histogram(th);
% bar(th);

end


