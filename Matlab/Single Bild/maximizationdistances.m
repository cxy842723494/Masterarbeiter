function [A] = maximizationdistances(v1,v2,P)

    n = size(P,1);
    A = zeros(1,n);
for i =1:n
    
    A (i) =  (sqrt((v1(1,1)-P(i,1))^2+(v1(1,2)-P(i,2))^2)*sqrt((v2(1,1)-P(i,1))^2+(v2(1,2)-P(i,2))^2));
    
end

end
