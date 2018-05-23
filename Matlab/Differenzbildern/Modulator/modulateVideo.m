%% 
%% Define the modulation parameters
modAmp = 9;
blocksize = 4;

inputName = 'Campus.mp4'
outputName = 'newMatrixAmp3'
v = VideoReader(['input/', inputName]);
nbFrames = 300;
outputFramerate = 50;

%%

vBlocks = v.Height/blocksize;
hBlocks = v.Width/blocksize;
% Create target video object
vMod = VideoWriter(['output/', outputName],'Uncompressed AVI');

% Value of profile	Description
% 'Archival'
% Motion JPEG 2000 file with lossless compression
% 'Motion JPEG AVI'
% AVI file using Motion JPEG encoding
% 'Motion JPEG 2000'
% Motion JPEG 2000 file
% 'MPEG-4'
% MPEG-4 file with H.264 encoding (systems with Windows 7 or later, or Mac OS X 10.7 and later)
% 'Uncompressed AVI'
% Uncompressed AVI file with RGB24 video
% 'Indexed AVI'
% Uncompressed AVI file with indexed video
% 'Grayscale AVI'
% Uncompressed AVI file with grayscale video

vMod.FrameRate = outputFramerate;
open(vMod);

currentFrames = zeros(v.Height, v.Width,3,2);
% getNewFrame = true;
% counter = 0.1;
% minAmp = 10;
% maxAmp = 0;
for i=1:2:nbFrames
    currentFrames(:,:,:,1) = double(readFrame(v))/255;    
    currentFrames(:,:,:,2) = currentFrames(:,:,:,1);

    % Add Pattern for SpatialSync
    qrPatternSize = 12; % origin 12,je small,je better the quality of vidio,but must consider the recterangle detection 
%     currentFrames(:,:,:,1) = addQrFinderPattern(currentFrames(:,:,:,1), qrPatternSize);
%     currentFrames(:,:,:,2) = addQrFinderPattern(currentFrames(:,:,:,2), qrPatternSize);
   
%     currentFrames(:,:,:,1) = addDaVidLightFinderPattern(currentFrames(:,:,:,1));
%     currentFrames(:,:,:,2) = addDaVidLightFinderPattern(currentFrames(:,:,:,2));
    
    dataMatrixU = modAmp * (randi([0 1],vBlocks,hBlocks)*2-1);
    dataMatrixV = modAmp * (randi([0 1],vBlocks,hBlocks)*2-1);
    dataMatrixU = imresize(dataMatrixU, blocksize, 'Nearest');
    dataMatrixV = imresize(dataMatrixV, blocksize, 'Nearest');
     %% add qr patternm in u/v
     dataMatrixU = addQrFinderPattern(dataMatrixU, qrPatternSize);
     dataMatrixV = addQrFinderPattern(dataMatrixV, qrPatternSize);
     
    Trgb2yuv = [0.2126 0.7152 0.0722; -0.1146 -0.3854 0.5000; 0.5000 -0.4542 -0.0458]; % BT.709
    Tyuv2rgb = inv(Trgb2yuv);
    
    dataMatrixR = Tyuv2rgb(1,2)*dataMatrixU + Tyuv2rgb(1,3)*dataMatrixV;
    dataMatrixG = Tyuv2rgb(2,2)*dataMatrixU + Tyuv2rgb(2,3)*dataMatrixV;
    dataMatrixB = Tyuv2rgb(3,2)*dataMatrixU + Tyuv2rgb(3,3)*dataMatrixV;
    
    dataMatrix = cat(3, dataMatrixR, dataMatrixG, dataMatrixB);

    
    
   
   % Modulate the Frames
   currentFrames(:,:,:,1) = currentFrames(:,:,:,1) + dataMatrix/255;
   currentFrames(:,:,:,2) = currentFrames(:,:,:,2) - dataMatrix/255;

   
   % Save in new file
   for i2=1:2
        writeVideo(vMod,uint8(255*currentFrames(:,:,:,i2)));
   end
end
close(vMod);
display('100%');
save currentFrames currentFrames;
