close all;
filename = 'vid2.m4v';
out_filename = 'vid2_stable.avi';
%hVideoSrc = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity');
hVideoSrc = VideoReader(filename);
out_video = VideoWriter(out_filename);
open(out_video);

% Reset the video source to the beginning of the file.
reset(hVideoSrc);

hVPlayer = vision.VideoPlayer; % Create video viewer

% Process all frames in the video
movMean = step(hVideoSrc);
imgB = movMean;
imgBp = imgB;
correctedMean = imgBp;
ii = 2;
Hcumulative = eye(3);


while ~isDone(hVideoSrc) && ii < 10
    % Read in new frame
    imgA = imgB; % z^-1
    imgB = step(hVideoSrc);
    
    writeVideo(out_video,imgB);
    imshow(imgB);

    ii = ii+1;
end

% Here you call the release method on the objects to close any open files
% and release memory.
release(hVideoSrc);
release(hVPlayer);
close(out_video);