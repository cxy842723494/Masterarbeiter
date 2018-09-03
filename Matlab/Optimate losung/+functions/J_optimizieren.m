
function [p0,J,W,J0] = J_optimizieren(p0, dp, term_dp, x1, x2, frame_size, State)

    % p_origin = p0;
    [J,~,~,~,~,W] = functions.objective_fun(p0,x1,x2,frame_size,State);
    J_data = [ ];
    J_data(1) = J;
    i = 2;
    while (any(abs(dp) > term_dp))
        for d=1:numel(dp)
            p0(d) = p0(d) + dp(d);
            [newJ,~,~,~,~,newW] = functions.objective_fun(p0,x1,x2,frame_size,State);
            if (newJ > J)
                p0(d) = p0(d) - dp(d);
                dp(d) = -dp(d)/3;
            else
                J = newJ;W = newW;
                J_data(i)=J; 
                i = i +1;            
            end
        end
    end
    J0 = J_data(1);
 switch State
     case 0
         figure,plot(1:1:i-1,J_data),title(sprintf('i:%d,p0:%f,%f,%f',i-1,p0(1),p0(2),p0(3)));
     case 1
         figure,plot(1:1:i-1,J_data),title(sprintf('i:%d,p0:%f,%f,%f,%f',i-1,p0(1),p0(2),p0(3),p0(4)));
     case 2
         figure,plot(1:1:i-1,J_data),title(sprintf('i:%d,p0:%f,%f,%f,%f,%f,%f',i-1,p0(1),p0(2),p0(3),p0(4),p0(5),p0(6)));
 end
