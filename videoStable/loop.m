close all;
filename = 'vid2.m4v';
out_filename = 'vid2_stable.avi';
hVideoSrc = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity');
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


while ~isDone(hVideoSrc) && ii < 50
    % Read in new frame
    imgA = imgB; % z^-1
    imgAp = imgBp; % z^-1
    imgB = step(hVideoSrc);
    movMean = movMean + imgB;

    % Estimate transform from frame A to frame B, and fit as an s-R-t
    [H, tform] = cvexEstStabilizationTform(imgA,imgB);
    %HsRt = cvexTformToSRT(H);
    Hcumulative = H * Hcumulative;
    imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));
    %imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
 
    % Display as color composite with last corrected frame
    step(hVPlayer, imfuse(imgAp,imgBp,'ColorChannels','red-cyan'));
    writeVideo(out_video,imgBp);
    
    correctedMean = correctedMean + imgBp;
    imshow(imgBp);

    ii = ii+1;
end
correctedMean = correctedMean/(ii-2);
movMean = movMean/(ii-2);

% Here you call the release method on the objects to close any open files
% and release memory.
release(hVideoSrc);
release(hVPlayer);
close(out_video);

figure; imshowpair(movMean, correctedMean, 'montage');
title(['Raw input mean', repmat(' ',[1 50]), 'Corrected sequence mean']);