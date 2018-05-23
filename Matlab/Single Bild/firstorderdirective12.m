function [B] =   firstorderdirective12(Imggray,num,x,y)
  
    A = zeros(5,5);
    i = ceil(5/2);
    j = ceil(5/2);
    % x direction
    A(i,j+1) = Imggray(x,y+1)- Imggray(x,y);
    A(i,j+2) = Imggray(x,y+2)- Imggray(x,y+1);
    % 45 grad direction
    A(i+1,j+1) = (Imggray(x+1,y+1)- Imggray(x,y))/sqrt(2);
    A(i+2,j+2) = (Imggray(x+2,y+2)- Imggray(x+1,y+1))/sqrt(2); 
    % y direction
    A(i+1,j) = Imggray(x+1,y)- Imggray(x,y);
    A(i+2,j) = Imggray(x+2,y)- Imggray(x+1,y);
    % 135 grad direction
    A(i+1,j-1) = (Imggray(x+1,y-1)- Imggray(x,y))/sqrt(2);
    A(i+2,j-2) = (Imggray(x+2,y-2)- Imggray(x+1,y-1))/sqrt(2); 
    % 180 direction, -x 
    A(i,j-1) = Imggray(x,y-1)- Imggray(x,y);
    A(i,j-2) = Imggray(x,y-2)- Imggray(x,y-1);
    % 225 grad direction
    A(i-1,j-1) = (Imggray(x-1,y-1)- Imggray(x,y))/sqrt(2);
    A(i-2,j-2) = (Imggray(x-2,y-2)- Imggray(x-1,y-1))/sqrt(2); 
    % 270 direction, -y
    A(i-1,j) = Imggray(x-1,y)- Imggray(x,y);
    A(i-2,j) = Imggray(x-2,y)- Imggray(x-1,y);
    % 315 grad direction
    A(i-1,j+1) = (Imggray(x-1,y+1)- Imggray(x,y))/sqrt(2);
    A(i-2,j+2) = (Imggray(x-2,y+2)- Imggray(x-1,y+1))/sqrt(2); 
    
    

    if num == 1
        %% 1.firstorderdirective with the maxmal value
        B = zeros(3,3);
        % x direction
        B(2,3)= max(abs(A(3,4:5)));
        u = cosd(0).*B(2,3);
        v = sind(0).*B(2,3);
        figure,quiver(0,0,u,v),title('firstorderdirective with the maxmal value'),hold on;
        % 45 grad direction
        B(3,3)= max(abs(A(4,4)),abs(A(5,5)));
        u = cosd(-45).*B(3,3);
        v = sind(-45).*B(3,3);
        quiver(0,0,u,v);
        % y direction
        B(3,2)= max(abs(A(4:5,3)));
        u = cosd(-90).*B(3,2);
        v = sind(-90).*B(3,2);
        quiver(0,0,u,v);
        % 135 grad direction
        B(3,1)= max(abs(A(4,2)),abs(A(5,2)));
        u = cosd(-135).*B(3,1);
        v = sind(-135).*B(3,1);
        quiver(0,0,u,v);
        % 180 direction, -x 
        B(2,1)= max(abs(A(3,1:2)));
        u = cosd(-180).*B(2,1);
        v = sind(-180).*B(2,1);
        quiver(0,0,u,v);
        % 225 grad direction
        B(1,1)= max(abs(A(2,2)),abs(A(1,1)));
        u = cosd(135).*B(1,1);
        v = sind(135).*B(1,1);
        quiver(0,0,u,v);
        % 270 direction, -y
        B(1,2)= max(abs(A(1:2,3)));
        u = cosd(90).*B(1,2);
        v = sind(90).*B(1,2);
        quiver(0,0,u,v);
        % 315 grad direction
        B(1,3)= max(abs(A(2,4)),abs(A(1,5)));
        u = cosd(45).*B(1,3);
        v = sind(45).*B(1,3);
        quiver(0,0,u,v);
  end
    
  if num == 2
    %% 2.firstorderdirective with the value addition
    B = zeros(3,3);
    % x direction
    B(2,3)= abs(A(3,4))+abs(A(3,5));
    u = cosd(0).*B(2,3);
    v = sind(0).*B(2,3);
    figure,quiver(0,0,u,v),title('firstorderdirective with the value addition'),hold on;
    % 45 grad direction
    B(3,3)= abs(A(4,4))+abs(A(5,5));
    u = cosd(-45).*B(3,3);
    v = sind(-45).*B(3,3);
    quiver(0,0,u,v);
    % y direction
    B(3,2)= abs(A(4,3))+abs(A(5,3));
    u = cosd(-90).*B(3,2);
    v = sind(-90).*B(3,2);
    quiver(0,0,u,v);
    % 135 grad direction
    B(3,1)= abs(A(4,2))+abs(A(5,2));
    u = cosd(-135).*B(3,1);
    v = sind(-135).*B(3,1);
    quiver(0,0,u,v);
    % 180 direction, -x 
    B(2,1)= abs(A(3,1))+abs(A(3,2));
    u = cosd(-180).*B(2,1);
    v = sind(-180).*B(2,1);
    quiver(0,0,u,v);
    % 225 grad direction
    B(1,1)= abs(A(2,2))+abs(A(1,1));
    u = cosd(135).*B(1,1);
    v = sind(135).*B(1,1);
    quiver(0,0,u,v);
    % 270 direction, -y
    B(1,2)= abs(A(1,3))+abs(A(2,3));
    u = cosd(90).*B(1,2);
    v = sind(90).*B(1,2);
    quiver(0,0,u,v);
    % 315 grad direction
    B(1,3)= abs(A(2,4))+abs(A(1,5));
    u = cosd(45).*B(1,3);
    v = sind(45).*B(1,3);
    quiver(0,0,u,v);
    
    
    
  end
end