                % teil of the image
                Teilober =   E(1:Central(2),:);
                Teilunter =   E(Central(2)+1:end,:);

                energieober = meansqr(Teilober);
                energieunter = meansqr(Teilunter);
                
                % teil of the image
                Teil1 =   E(1:Central(2),1:Central(1));
                Teil2 =   E(1:Central(2),Central(1)+1:end);
                Teil3 =   E(Central(2)+1:end,1:Central(1));
                Teil4 =   E(Central(2)+1:end,Central(1)+1:end);
                
                energie1 = meansqr(Teil1);
                energie2 = meansqr(Teil2);
                energie3 = meansqr(Teil3);
                energie4 = meansqr(Teil4);