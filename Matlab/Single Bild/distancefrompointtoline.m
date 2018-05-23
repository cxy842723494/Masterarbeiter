function [dist] = distancefrompointtoline(v1,v2,P)

    vc = v2-v1;
    vn(1,1) = -vc(1,2);
    vn(1,2) = vc(1,1);
    
    n = size(P,1); 
    distance = zeros(1,n);
    for i = 1:n
        
        distance(i) = dot(P(i,:)-v1,(vn)/sqrt((v2(1,2)-v1(1,2))^2+(v2(1,1)-v1(1,1))^2) );
        dist = abs(distance.'); 
    end
    
end