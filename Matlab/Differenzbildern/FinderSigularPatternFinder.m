function patternInfo = FinderSigularPatternFinder(p)

    for k = 1:2
    [filename,filepath] = uigetfile('*.*','Select the image');
    if isequal(filename,0)||isequal(filepath,0)
        return;
    else
        filefullpath = [filepath,filename];
    end

    [yuv(k).Y, yuv(k).U, yuv(k).V] = readYUV(filefullpath);   
    end

    diff_U = yuv(1).U - yuv(2).U;
    diff_V = yuv(1).V - yuv(2).V;
    
    Img = diff_V;
%     figure,imshow(Img,[]),title('Differenzbild');
    
    
    threshold = graythresh(Img);
    grain = 6;
    Handles.img = imgPreprosessing(Img,threshold,grain);
    
    addpath QRFIP
    
    Y = Handles.img;
    figure, imshow(Y,[]);
    
%     h = size(Y, 1);
    w = size(Y, 2);
%     n = size(Y, 3);
    
    s.offset = 0;
    s.sizeH = 250;192*2*(uint16(w/1920)); % 250:450 d.h. the ratio of the tv 3:4
    s.sizeW = 450;256*2*(uint16(w/1920)); % 192:256 d.h. the ratio of the tv 9:16
    s.warpRatio = 1;0.9;
    s.FIPsize = 108;36*(w/1920); % 4 pixels per module
    PatternAreaBW = zeros(s.sizeH, s.sizeW, 4);
    y = Y(:,:,1);
if  max(y(:)) > 1
    y = y / 255; 
end
%      th = 0.35;
     
    PatternAreaBW(:,:,1) = y(s.offset+1:s.sizeH+s.offset,...
    s.offset+1:s.sizeW+s.offset);
    PatternAreaBW(:,:,2) = y(s.offset+1:s.sizeH+s.offset,...
    end-s.sizeW-s.offset+1:end-s.offset);
    PatternAreaBW(:,:,3) =  y(end-s.sizeH-s.offset+1:end-s.offset, ...
    s.offset+1:s.sizeW+s.offset);
    PatternAreaBW(:,:,4) = y(end-s.sizeH-s.offset+1:end-s.offset, ...
    end-s.sizeW-s.offset+1:end-s.offset);

    PatternAreaBW = PatternAreaBW(:,:,p);
    patternInfo = FinderPatternFinder(not(PatternAreaBW),true);
    FIPx(p) = patternInfo.posX;
    FIPy(p) = patternInfo.posY;
    if (FIPx(p)==0||FIPy(p)==0)
    patternInfo = FinderSigularPatternFinder(p);   
    end
    
    
end