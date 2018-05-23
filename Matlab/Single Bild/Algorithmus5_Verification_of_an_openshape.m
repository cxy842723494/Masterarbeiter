%     clean;
%     close all;

    % Algorithm.5 Verification of an Open Shape
    % input: a candidate shape P = {pi} i=1,2....n. , a n*2 matrix and four
    % output: open points if yes and the angle of the open points

    function [id1,id2]=Algorithmus5_Verification_of_an_openshape(P,Pmean)
    %% 1. compute the centroid Pmean (this section can be optimiert, use which method is best)
    n = size(P,1);
%     Pmean = mean(P);
%     figure, imshow(Img),hold on;
%     plot(Pmean(1,1),Pmean(1,2),'r.');
    
    % centroid use the bounding-box centroid
%     [rectx,recty] = minboundrect(P(:,1),P(:,2),'a');
%     rect(:,1) = rectx;
%     rect(:,2) = recty;
%     rectn = rect(1:4,1);
%     rectn(:,2) = rect(1:4,2);
%     Pmean = mean(rectn);
%     
%     figure,imshow(Img),hold on;
%     plot(rectn(:,1),rectn(:,2), 'r', 'LineWidth', 2);
%     plot([rectn(4,1) rectn(1,1)],[rectn(4,2) rectn(1,2)], 'r', 'LineWidth', 2);
%     plot(Pmean(:,1),Pmean(:,2), 'r.');
    
    %% 2. centralization
    Pc = P- ones(n,1)*Pmean;
    plot(Pc(:,1),Pc(:,2));
 
    %% 3.4. normalization 
    Pcn = zeros(n,2);
    for i = 1:n
        
        Pcn(i,:) = Pc(i,:)/sqrt(Pc(i,1)^2 + Pc(i,2)^2);  % angle
%         Pcn(i,:) = Pcr(i,:)/sqrt(Pcr(i,1)^2 + Pcr(i,2)^2); 
    end
    
    %% 5.6. init each angular bin
    bins = zeros(1,360);
    for theta = 1:360
        
        bins(theta) = 0;   % null
        
    end
    
    %% 7.8. for each p=(x,y) belong to Pc, calculate the responsed angle 
    thetap = zeros(1,n);
    for j = 1:n
        thetap(j) = atan2d(Pcn(j,2),Pcn(j,1)); % returns values in the closed interval [-180,180]
        thetap = round(thetap);
        if(thetap(j)<1)
            thetap(j) =  thetap(j) +360;
        end
        
    %% 9. insert p into bins[thetap]
        for theta =  1:360
            if thetap(j)==theta                 
                bins(theta)= bins(theta)+1;     % accumalize normalized points to an anngular bin
            end
        end
   
    end 
    figure,bar(bins),title('bins');
    
%     thetap = thetap/pi*180; % mit atan von[-90 90] ,radian to grad   
%     max(thetap);
%     min(thetap); 

    %% 10-18.

    id1 = [];
    id2 = [];
    for theta = 1:360
       
        front =  mod(theta + 359,360);
        front1 =  mod(theta + 358,360);
        front2 =  mod(theta + 357,360);
        front3 =  mod(theta + 356,360);
        front4 =  mod(theta + 355,360);
        rear = mod(theta + 1,360);
        rear1 = mod(theta + 2,360);
        rear2 = mod(theta + 3,360);
        rear3 = mod(theta + 4,360);
        rear4 = mod(theta + 5,360);
        if front==0
            front=360;
        end
        if front1==0
            front1=360;
        end
        if front2==0
            front2=360;
        end
        if front3==0
            front3=360;
        end
        if front4==0
            front4=360;
        end
        
        if rear==0
            rear=360;
        end
        if rear1==0
            rear1=360;
        end
        if rear2==0
            rear2=360;
        end
        if rear3==0
            rear3=360;
        end
        if rear4==0
            rear4=360;
        end

                
        if(bins(front)==0 && bins(front1)==0 && bins(front2)==0 && bins(front3)==0 && bins(front4)==0 && bins(theta)>0)
            idx1 = theta;    % right open
            id1 = cat(1,id1,idx1);    
        end
        if(bins(rear)==0 && bins(rear1)==0 && bins(rear2)==0 && bins(rear3)==0 && bins(rear4)==0 && bins(theta)>0)
            idx2 = theta;    % left open
            id2 = cat(1,id2,idx2); 
        end        
    end

    % find the open point 
%     index1 = find(thetap==id1);
%     index2 = find(thetap==id2);    
%     
%     pnode = Pc(index1,:);
%     qnode = Pc(index2,:);
%     
%     distance = zeros(size(pnode,1),size(qnode,1));
%     for i=1:size(pnode,1)
%         for j=1:size(qnode,1)
%             
%             distance(i,j) = sqrt((qnode(j,1)-pnode(i,1))^2+(qnode(j,2)-pnode(i,2))^2);
%             
%         end
%     end
%     mind = min(min(distance));
%     [M,N] = find(distance==mind);
%     
%     node1 = index1(M);
%     node2 = index2(N);
%     
%     figure,imshow(Img),hold on;
%     plot(Pc(:,1),Pc(:,2));
%     plot(Pc(node1,1),Pc(node1,2),'r.');
%     plot(Pc(node2,1),Pc(node2,2),'r.'); 
%     
%     plot(Pc(node1,1)+Pmean(1,1),Pc(node1,2)+Pmean(1,2),'b.');
%     plot(Pc(node2,1)+Pmean(1,1),Pc(node2,2)+Pmean(1,2),'b.'); 
%     

%     plot(Pc(node1,1)+centrP(1,1),Pc(node1,2)+centrP(1,2),'b.');    
%     plot(Pc(node2,1)+centrP(1,1),Pc(node2,2)+centrP(1,2),'b.');   
end
    