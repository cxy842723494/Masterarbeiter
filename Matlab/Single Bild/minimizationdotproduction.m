function [A] = minimizationdotproduction(v1,v2,P)

    n = size(P,1);
for i =1:n
%     dot(v1-P(i,:),v2-P(i,:))
%     B=sqrt((v1(1,1)-P(i,1))^2+(v1(1,2)-P(i,2))^2);
%     C=sqrt((v2(1,1)-P(i,1))^2+(v2(1,2)-P(i,2))^2);
    
    A (i) =  dot(v1-P(i,:),v2-P(i,:))/(sqrt((v1(1,1)-P(i,1))^2+(v1(1,2)-P(i,2))^2)*sqrt((v2(1,1)-P(i,1))^2+(v2(1,2)-P(i,2))^2));
end

end
