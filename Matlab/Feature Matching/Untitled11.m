             %% central of the image
               Teil = E(Central(2)/2+1:Central(2)*3/2,Central(1)/2+1:Central(1)*3/2);
               figure,imshow(Teil,[]);
               energie = meansqr(Teil);
               Energie(i,j) = energie;
               
               [m,n]=size(Energie);
                v=sort(reshape(Energie,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                    diffsum=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energie==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsum = diffsum+diffc(:,:,i);
                    end
                    

              %% 1/2 teil of the image
                Teilober =   E(1:Central(2),:);
                Teilunter =   E(Central(2)+1:end,:);
                energieober = meansqr(Teilober);
                energieunter = meansqr(Teilunter);
                Energieober(i,j) = energieober;
                Energieunter(i,j) = energieunter;  

                [m,n]=size(Energieober);
                v=sort(reshape(Energieober,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsumober=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energieober==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsumober = diffsumober+diffc(:,:,i);
                    end

                [m,n]=size(Energieunter);
                v=sort(reshape(Energieunter,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsumunter=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energieunter==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsumunter = diffsumunter+diffc(:,:,i);
                    end
                diffsum = zeros(size(E));
                diffsum(1:Central(2),:) = diffsumober(1:Central(2),:);
                diffsum(Central(2)+1:end,:) = diffsumunter(Central(2)+1:end,:);
                figure,imshow(diffsum,[])
                figure,imshow(abs(diffsum),[]),title('sum')




              %% 1/4 teil of the image
                Teil1 =   E(1:Central(2),1:Central(1));
                Teil2 =   E(1:Central(2),Central(1)+1:end);
                Teil3 =   E(Central(2)+1:end,1:Central(1));
                Teil4 =   E(Central(2)+1:end,Central(1)+1:end);
%                 figure,imshow(Teil4,[]);
                energie1 = meansqr(Teil1);
                energie2 = meansqr(Teil2);
                energie3 = meansqr(Teil3);
                energie4 = meansqr(Teil4);
                Energie1(i,j) = energie1;
                Energie2(i,j) = energie2;
                Energie3(i,j) = energie3;
                Energie4(i,j) = energie4; 

            % 1/4  teil of the image       
                [m,n]=size(Energie1);
                v=sort(reshape(Energie1,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsum1=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energie1==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsum1 = diffsum1+diffc(:,:,i);
                    end

                [m,n]=size(Energie2);
                v=sort(reshape(Energie2,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsum2=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energie2==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsum2 = diffsum2+diffc(:,:,i);
                    end

                [m,n]=size(Energie);
                v=sort(reshape(Energie,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsum=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energie==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsum = diffsum+diffc(:,:,i);
                    end

                [m,n]=size(Energie4);
                v=sort(reshape(Energie4,1,m*n),'descend');
                v=v(1:4);           
                idx=zeros(1,4);
                idy=zeros(1,4);
                diffsum4=zeros(size(E));
                    for i=1:4
                        [idx(i),idy(i)]=find(Energie4==v(i));
                        diffc(:,:,i) = registerTransformInSameCoordinate(img_path_list,file_path,idx(i),idy(i)); % stilles Image
            %             Scr =['number:',num2str(i)];
            %             figure,imshow(diffc(:,:,i),[]),title(Scr);
                        diffsum4 = diffsum4+diffc(:,:,i);
                    end
                    diffsum = zeros(size(E));
                    diffsum(1:Central(2),1:Central(1)) = diffsum1(1:Central(2),1:Central(1));
                    diffsum(1:Central(2),Central(1)+1:end) = diffsum2(1:Central(2),Central(1)+1:end);
                    diffsum(Central(2)+1:end,1:Central(1)) = diffsum3(Central(2)+1:end,1:Central(1));
                    diffsum(Central(2)+1:end,Central(1)+1:end) = diffsum4(Central(2)+1:end,Central(1)+1:end);
                    figure,imshow(diffsum,[])
                    figure,imshow(abs(diffsum),[]),title('sum')
        
        