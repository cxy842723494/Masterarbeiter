%  clean;
%     close all;

%% Algorithm.4 Rectangularity_Verification

    % input: a candidate shape P = {pi} i=1,2....n. , a n*2 matrix and four
    % vertices v1,v2,v3 and v4. the result from Algorithm3.
    % output: yes or no 
    
    count = 0;
    
    n = size(P,1); 
    disp =zeros(n,4);    
    disp(:,1) = distancefrompointtoline(v1,v3,P);
    disp(:,2) = distancefrompointtoline(v1,v4,P);
    disp(:,3) = distancefrompointtoline(v2,v3,P);
    disp(:,4) = distancefrompointtoline(v2,v4,P);

    for i =1:n
        min1 = min(disp(i,:));
        if min1<5       % 2,3,5 parameter1: control the displacement of a point from the boundary of a rectangle
            count = count+1;
        end
        
    end
    
    if count/n>=(1-0.2) % parameter2: control the tolerance of a percentage of outliers 
        output = 1 ;
        return
    else 
        output = 0 ;
        return ;
    end
        