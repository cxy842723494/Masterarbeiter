function [B] =   firstorderdirective3(Imggray,x,y)

%% 3.firstorderdirective from the farthest point to image point
    B = zeros(3,3);
    i = ceil(3/2);
    j = ceil(3/2);
    % x direction
    B(i,j+1) = abs(Imggray(x,y+2)- Imggray(x,y));
    u = cosd(0).*B(i,j+1);
    v = sind(0).*B(i,j+1);
    figure,quiver(0,0,u,v),title('firstorderdirective with farthest point to image point'),hold on;
    % 45 grad direction
    B(i+1,j+1) = abs((Imggray(x+2,y+2)- Imggray(x,y))/2*sqrt(2));
    u = cosd(-45).*B(i+1,j+1);
    v = sind(-45).*B(i+1,j+1);
    quiver(0,0,u,v);
    % y direction
    B(i+1,j) = abs(Imggray(x+2,y)- Imggray(x,y));
    u = cosd(-90).*B(i+1,j);
    v = sind(-90).*B(i+1,j);
    quiver(0,0,u,v);
    % 135 grad direction
    B(i+1,j-1) = abs((Imggray(x+2,y-2)- Imggray(x,y))/2*sqrt(2));
    u = cosd(-135).*B(i+1,j-1);
    v = sind(-135).*B(i+1,j-1);
    quiver(0,0,u,v);
    % 180 direction, -x 
    B(i,j-1) = abs(Imggray(x,y-2)- Imggray(x,y));
    u = cosd(-180).*B(i,j-1);
    v = sind(-180).*B(i,j-1);
    quiver(0,0,u,v);
    % 225 grad direction
    B(i-1,j-1) = abs((Imggray(x-2,y-2)- Imggray(x,y))/2*sqrt(2));
    u = cosd(135).*B(i-1,j-1);
    v = sind(135).*B(i-1,j-1);
    quiver(0,0,u,v);
    % 270 direction, -y
    B(i-1,j) = abs(Imggray(x-2,y)- Imggray(x,y));
    u = cosd(90).*B(i-1,j);
    v = sind(90).*B(i-1,j);
    quiver(0,0,u,v);
    % 315 grad direction
    B(i-1,j+1) = abs((Imggray(x-2,y+2)- Imggray(x,y))/2*sqrt(2));
    u = cosd(45).*B(i-1,j+1);
    v = sind(45).*B(i-1,j+1);
    quiver(0,0,u,v);
end