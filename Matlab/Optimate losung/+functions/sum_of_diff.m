%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is to choose the 3 differentbild, which the energie of each 
% image is most and plus them to make the detection easilier
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function diffplus = sum_of_diff(diff,Mal_num)


    diff_num  = size(diff(:,:,:),3); 
    energie = zeros(1,diff_num);

    for i = 1:diff_num
    energie(i) = meansqr(diff(:,:,i));
    end
    
    clear i;

    
    v=sort(energie,'descend');%,'descend'
    v=v(1:Mal_num);           
    idx=zeros(1,Mal_num);
    diffplus = zeros(size(diff(:,:,1)));
     for i=1:3
            idx(i) = find(energie==v(i));
            diffplus = diffplus + diff(:,:,idx(i));
     end
     
     % take off the NAN 
%      A =diff(:,:,26);
%      [a,b]= find(isnan(A));
%      for i = 1:size(a)
%         A(a(i),b(i))=0;
%      end
%      clear a b;
%      [a,b]= find(isnan(diffplus));
%      for i = 1:size(a)
%      diffplus(a(i),b(i))=0;
%      end
     
%     figure;imshow(A,[]),title('26');
%     figure;histogram(diff(:,:,86)),title('86');
%     figure;imshow(diffplus,[]),title('diffplus');
end