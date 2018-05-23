clean;
%% Input a candidate shape

    Img = imread('1-3.png');
%     Img = imread('Unbenannt.jpg');
    Img = rgb2gray(Img);
    Img = imbinarize(Img);
    % figure,imshow(Img);

    [B,L] = bwboundaries(Img);
    
%     imshow(Img); hold on;
%     colors=['b' 'g' 'r' 'c' 'm' 'y'];
%     for k=1:length(B),
%       boundary = B{k};
%       cidx = mod(k,length(colors))+1;
%       plot(boundary(:,2), boundary(:,1),...
%            colors(cidx),'LineWidth',2);
%     
%       %randomize text position for better visibility
%       rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
%       col = boundary(rndRow,2); row = boundary(rndRow,1);
%       h = text(col+1, row-1, num2str(L(row,col)));
%       set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
%     end
    P = B{3,1};    % choose a candidate shape


%% Algorithm.1 Removal of Outer Outliers

            % input: a candidate shape, a n*2 matrix
P1(:,1) = P(:,2);
P1(:,2) = P(:,1);
P =P1;                  % change the coordinate,the 1.column means x, the 2.colume means y    

n = size(P,1); % caculate the number of the point 

sum1 = zeros(1,2);
for i = 1:2
    for j = 1:n
        sum1(i) = sum1(i) + P(j,i);
    end
end
Pmean = sum1.*1/n;                  % mean of P, a 1*2 matrix
Pc = P - ones(n,1)*Pmean;           % centralization
A = Pc'*Pc;                         % convariance
[U,D,V] = svd(A);                   
Pcr = Pc*U;                         % rotate centralized points (anticlokwise with original point)
Pcr = round(Pcr);

figure,imshow(Img),hold on;
plot(P(:,1),P(:,2));
plot(Pcr(:,1),Pcr(:,2));

xmin=min(Pcr(:,1)); 
ymin=min(Pcr(:,2));  

plot(Pcr(:,1)-xmin,Pcr(:,2)-ymin);

Pcr1(:,1) = Pcr(:,1)-xmin+1;
Pcr1(:,2) = Pcr(:,2)-ymin+1;
plot(Pcr1(:,1),Pcr1(:,2));

Img1 = ones(max(Pcr1(:,2)),max(Pcr1(:,1)));
figure,imshow(Img1);
num = size(Pcr1,1);

for i=1:num

    Img1(Pcr1(i,2),Pcr1(i,1)) = 0;

end
Img1 = logical(Img1);
figure,imshow(Img1);

[a,b] = size(Img1);
h = a-sum(Img1,1);

    
%     h = zeros(1,b);
%     for i = 1:b
%         for j = 1:a
%             if Img(j,i)==0
%                 h(i) = h(i)+1;
%             end
%         end
%     end



figure,bar(h),title('h');

hdiff = zeros(1,b-1);
    for k=1:b-1
        
        hdiff(k) = abs(h(k+1)-h(k));

    end
    bar(hdiff),title('hdiff');                  % approximate the absolute derivative of h

 m=max(hdiff(1,:));                                  %   Algorithm 
    index=find(hdiff(1,:)==m);
    while numel(index)<4
       m=m-1; 
       index1=find(hdiff(1,:)==m);
       index = cat(2,index,index1);
    end
%     max_array=hdiff(1,index);
%     index = index(1:4);
    
    jmin = min(index);
    jmax = max(index);
 

    index1=find(Pcr1(:,1)<jmax & Pcr1(:,1)>jmin);
    
    Pnew = Pcr1(index1,:);
    
    
%     figure,imshow(Img1),hold on;
%     plot(Pnew(:,1),Pnew(:,2));         % Step 11

    Pnew(:,1) = Pnew(:,1)+xmin-1;
    Pnew(:,2) = Pnew(:,2)+ymin-1;
%     plot(Pnew(:,1),Pnew(:,2));
            
    m = size(Pnew,1);                   % Step 12

    Preturn = Pnew/U + ones(m,1)*rectnmean;
    figure,imshow(Img),hold on;
    plot(Preturn(:,1),Preturn(:,2));   









