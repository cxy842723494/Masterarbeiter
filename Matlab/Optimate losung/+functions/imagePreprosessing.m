function [Text_data] = imgPreprosessing(Img,threshold,grain) 
% In this funktion we will first take the image to a pretreat, so that it
% can be esay to deal with the QR pattern Process. E.g. grayscale of the
% image , noise filter( basic gaus filter median filter),binariesieung
% image and morphological operation.



%% Grayscale of the image, which catches from the camera
    
%     handel.gray = rgb2gray(handles.Img);  % or gibt es noch good idea for grayscalying
%     figure, imshow(handel.gray);
    handles.gray = Img;
%     figure, imshow(handles.gray,[]);
    
%% Noise filter (median filter gaus filter filter the salz or gaus noise)

%     handles.Img_gefiltered = medfilt2(handles.gray,[3 3]);   % median filter mit [3 3]
%     figure, imshow(handles.Img_gefiltered,[])
    handles.Img_gefiltered = medfilt2(handles.gray,[5 5]);   % median filter mit [5 5]
%     handles.Img_gefiltered = imgaussfilt(handles.gray,[3 3]);% gaus filter mit vector [3 3]
%     handles.Img_gefiltered = imgaussfilt(handles.gray);      % gaus filter mit sigma(default 0,5)
%     figure, imshow(handles.Img_gefiltered,[]),title('Image after Median gilter [5 5]');
    
%% Binary of the image (default global binay mit ostu or local binary or method from christian)
% Normalize input data to range in [0,1].
    Xmin = min(handles.Img_gefiltered(:));
    Xmax = max(handles.Img_gefiltered(:));
    if isequal(Xmax,Xmin)
        X = 0*Xhandles.Img_gefiltered;
    else
        X = (handles.Img_gefiltered - Xmin) ./ (Xmax - Xmin);
    end

% Threshold image - adaptive threshold
%     handles.Bw = imbinarize(X, 'adaptive', 'Sensitivity', 0.350000, 'ForegroundPolarity', 'bright');    
    handles.Bw = imbinarize(X, 'adaptive', 'Sensitivity', 0.400000, 'ForegroundPolarity', 'bright');    

    % global binariserung Ostu
%     handles.Bw = imbinarize(handles.Img_gefiltered,'adaptive','Sensitivity',0.35);
%     handles.Bw = imbinarize(handles.Img_gefiltered,6);
%     figure,imshow(handles.Bw),title('Image after binary');
%     handles.Bw1= not(handles.Bw);   % bw image, i.e 1 is object and 0
%     figure,imshow(handles.Bw1);     % background here we want to know, es
                                    % gibt eine Possibolity,in one  
                                    % differenz image ,which have not deal
                                    % with the sythro-Process, the above
                                    % section of the differenzbild can be
                                    % white and under section can be the opposite.

    % local binariesierung Ostu                                    
%     fun = @(block_struct) imbinarize(block_struct.data,'adaptive');  % or 'global'
%     handles.Bw = blockproc(handles.Img_gefiltered,[40 40],fun);      
%     figure,imshow(handles.Bw),title('lockal BW of Original Image');
    

    % Ideal from Christian: from the characteristics of the daten transform 
    % Threshold should be high enough to avoid large noise outside the
    % modulated area, but large enough to avoid large gaps in weakly
    % modulated regions.
    
%     handles.Bw = abs(handles.Img_gefiltered)>std(double(handles.Img_gefiltered(:)))*threshold;
%     figure,imshow(handles.Bw),title('BW of Chri');
%     handles.Bw1= not(handles.Bw);
%     figure,imshow(handles.Bw1);

%      handles.Bw = AdaptiveThreshold(handles.Img_gefiltered, 500, 500);
    
%% Morphological operation
    % Transitions leave gaps between blocks, whereas noise causes small
    % spots outside the modulated area to cross the threshold. Using
    % opening and closing filters, both can be greatly reduced, making the
    % resulting BW image a good estimate of the rectangle containing the
    % modulated data.
%     handles.Bw_open = imopen(handles.Bw,ones(5));
%     figure,imshow(handles.Bw_open),title('Binary Image after open');
%     handles.Bw_morpho = imclose(handles.Bw_open,ones(5));
%     figure,imshow(handles.Bw_morpho),title('Image after close');
    
%     handles.Bw_morpho =  imclose(imopen(handles.Bw,ones(6)),ones(6));
%     figure,imshow(handles.Bw_morpho),title('Image after morpho');  
    
    handles.Bw_close = imclose(handles.Bw,ones(5));
    figure,imshow(handles.Bw_close),title('Binary Image after close');
    handles.Bw_morpho = imopen(handles.Bw_close,ones(5));
    figure,imshow(handles.Bw_morpho),title('Image after open');   

    handles.Bw_morpho =imopen(imclose(handles.Bw,ones(5)),ones(5));   
%     handles.Bw_morpho =imopen(imclose(handles.Bw,ones(grain)),ones(grain));
%     figure,imshow(handles.Bw_morpho),title('Image after morpho');

%     figure,imshow(imclose(handles.Bw_morpho,ones(5)))
%     imerode
%     imdilate
    
    Text_data = handles.Bw_morpho;
%     save Text_data Text_data;
%     
%     a = imerode(handles.Bw1,ones(10));
%     figure,imshow(a),title('Binary Image after erosion');
%     b = imdilate(a,ones(10));
%     figure,imshow(b),title('Binary Image after dilataion');
%     
%     handles.Bw1_open = imopen(handles.Bw1,ones(8));
%     figure,imshow(handles.Bw1_open),title('Binary Image after open');
%     handles.Bw1_morpho = imclose(handles.Bw1_open,ones(8));
%     figure,imshow(handles.Bw1_morpho),title('Image after close');
%     
%     handles.Bw_morpho = imclose(imopen(handles.Bw1,ones(12)),ones(12));
%     figure,imshow(handles.Bw_morpho);
%     
%     handles.morpho = handles.Bw_morpho|handles.Bw1_morpho;
%     figure,imshow(handles.morpho);
    
end

    
    
    