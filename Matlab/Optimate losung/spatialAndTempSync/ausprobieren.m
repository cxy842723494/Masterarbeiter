bilderAdd = [];
bilderDiff_V = [];

rec1_V = V(end/2:end,:,1);
rec2_V = V(end/2:end,:,2);
rec3_V = V(end/2:end,:,3);
rec4_V = V(end/2:end,:,4);
rec5_V = V(end/2:end,:,5);


bilderAdd(:,:,1) = (rec3_V + rec1_V)/2; % 1 + 3
bilderAdd(:,:,2) = (rec3_V + rec2_V)/2; % 2 + 3
bilderAdd(:,:,3) = (rec3_V + rec4_V)/2; % 4 + 3
bilderAdd(:,:,4) = (rec3_V + rec5_V)/2; % 5 + 3

bilderDiff_V(:,:,1) = (rec1_V - rec3_V)/2; % 1 - 3
bilderDiff_V(:,:,2) = (rec2_V - rec3_V)/2; % 2 - 3
bilderDiff_V(:,:,3) = (rec3_V - rec4_V)/2; % 3 - 4
bilderDiff_V(:,:,4) = (rec3_V - rec5_V)/2; % 3 - 5




corelations = [];
corelations(1) = corr2(rec1_V, bilderDiff_V(:,:,1))
corelations(2) = corr2(rec2_V, bilderDiff_V(:,:,2))
corelations(3) = corr2(rec3_V, bilderDiff_V(:,:,3))
corelations(4) = corr2(rec3_V, bilderDiff_V(:,:,4))

% implay(mat2gray((tmp)))

