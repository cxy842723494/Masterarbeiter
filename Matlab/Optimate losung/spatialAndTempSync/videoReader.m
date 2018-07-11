v = VideoReader('test11.mp4');
% obj = videoinput('test.mp4');
nbFrames = round(v.FrameRate*v.Duration);
video = zeros(1080,1920,3, nbFrames);

for i=1:nbFrames-3
   video(:,:,:,i) = double(readFrame(v)); 
end