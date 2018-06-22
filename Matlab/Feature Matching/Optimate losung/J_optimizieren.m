


function [p0,J] = J_optimizieren(p0, dp, term_dp, x1, x2, frame_size)
% p0 = [0.0,0,0];
p_origin = p0;
J = objective_fun(p0,x1,x2,frame_size);
J_data = [ ];
J_data(1) = J;
i = 2;
while (any(abs(dp) > term_dp))
    for d=1:numel(dp)
        p0(d) = p0(d) + dp(d);
        newJ = objective_fun(p0,x1,x2,frame_size);
        if (newJ > J)
            p0(d) = p0(d) - dp(d);
            dp(d) = -dp(d)/3;
        else  J = newJ;  
            J_data(i)=J; 
            i = i +1;            
        end
        
    end
end
% figure,plot(1:1:i-1,J_data),title(sprintf('i:%d,p0:%f,%f,%f,%f',i-1,p0(1),p0(2),p0(3),p0(4)));
 %figure,plot(1:1:i-1,J_data),%title(sprintf('i:%d,p0:%f,%f,%f',i-1,p0(1),p0(2),p0(3)));
figure,plot(1:1:i-1,J_data),title(sprintf('i:%d,p0:%f,%f,%f,%f,%f,%f',i-1,p0(1),p0(2),p0(3),p0(4),p0(5),p0(6)));
 % display(J);title(sprintf('J-data with p0:%f,%f,%f,%f',p0(1),p0(2),p0(3),p0(4)))