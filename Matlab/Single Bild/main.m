
    clean;
%     close all;
%% load the image from the camera
        
    [filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end
    [yuv(1).Y, yuv(1).U, yuv(1).V] = readYUV(filefullpath);
    
    Img = yuv2rgb(yuv(1).Y, yuv(1).U, yuv(1).V);
    
    handels.Img = double(Img)./255;
    handels.R = handels.Img(:,:,1);
    handels.G = handels.Img(:,:,2);
    handels.B = handels.Img(:,:,3);
    handels.Imggray = rgb2gray(handels.Img);
    
%     figure,imshow(handels.R),title('R');
%     figure,imshow(handels.G),title('G');
%     figure,imshow(handels.B),title('B');
%     figure,imshow(handels.Imggray),title('Imggray');

%% Candidate Shape in channel_scale Spaces
 % as a result of this section can we get a clean edge of an object behind union Strategy with channel(r,g,b,gray) and
 % scale(sigma)
    % Gaus filter
    sigma = 0.5; % 0.5(default)|scalar or 2-element vector of positive values

    % R
    handels.Imggausfilter_R = imgaussfilt(handels.R,sigma);
%     figure,imshow(handels.Imggausfilter_R),title('Imggausfilter_R');

    handels.edge_R = edge(handels.Imggausfilter_R,'Canny');
%     figure,imshow(handels.edge_R),title('Imgedge_R');
    
    % G
    handels.Imggausfilter_G = imgaussfilt(handels.G,sigma);
%     figure,imshow(handels.Imggausfilter_G),title('Imggausfilter_G');

    handels.edge_G = edge(handels.Imggausfilter_G,'Canny');
%     figure,imshow(handels.edge_G),title('Imgedge_G');
    
    % B
    handels.Imggausfilter_B = imgaussfilt(handels.B,sigma);
%     figure,imshow(handels.Imggausfilter_B),title('Imggausfilter_B');

    handels.edge_B = edge(handels.Imggausfilter_B,'Canny');
%     figure,imshow(handels.edge_B),title('Imgedge_B');
    
    % Gray
    handels.Imggausfilter_Imggray = imgaussfilt(handels.Imggray,sigma);
%     figure,imshow(handels.Imggausfilter_Imggray),title('Imggausfilter_Imggray');

    handels.edge_Imggray = edge(handels.Imggausfilter_Imggray,'Canny');
%     figure,imshow(handels.edge_Imggray),title('Imgedge_Imggray');
    
    
   % set a threshold, to removed small connected components, amd got the
   % candidate shape
    tic;
    handels.edge_RC = bwareaopen(handels.edge_R,1000);
%     figure,imshow(handels.edge_RC),title('handels.edge_RC');    
    handels.edge_GC = bwareaopen(handels.edge_G,1000);
%     figure,imshow(handels.edge_GC),title('handels.edge_GC');
    handels.edge_BC = bwareaopen(handels.edge_B,1000);
%     figure,imshow(handels.edge_BC),title('handels.edge_BC');
    handels.edge_ImggrayC = bwareaopen(handels.edge_Imggray,1000);
%     figure,imshow(handels.edge_ImggrayC),title('handels.edge_ImggrayC');
  
    handels.edge = handels.edge_RC|handels.edge_GC|handels.edge_BC|handels.edge_ImggrayC;
%     figure,imshow(handels.edge),title('handels.edge');
    toc;
    
    
 [B,L] = bwboundaries(handels.edge);
 handels_edge = handels.edge;
 save handels_edge handels_edge;   
 
%% Removal of Outer Outliers

P = B{1,1};


n = size(P,1); % caculate the nummber of the point 

sum = zeros(1,2);
for i = 1:2
    for j = 1:n
        sum(i) = sum(i) + P(j,i);
    end
end
Pmean = sum.*1/n;
Pc = P - ones(n,1)*Pmean;
A = Pc'*Pc;
[U,V,D] = svd(A);
Pcr = Pc*U;
Pcr = Pcr + ones(n,1)*Pmean;
Pcr = ceil(Pcr);

Img = zeros(size(L));
for i =1:n
Img(P(i,1),P(i,2))=1;
end

imshow(Img),hold on;
plot(P(:,2),Pcr(:,1));
plot(Pcr(:,2),Pcr(:,1));


% 
% % ?????
% for y=1:n
%      S(y)=sum(Pcr(1:m,y));
% end
% y=1:n;
% figure
% subplot(211),plot(y,S(y));
% title('????');


