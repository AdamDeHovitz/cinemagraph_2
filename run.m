%% Estimating Optical Flow
% This example uses the Farneback Method to to estimate the direction and speed of moving
% cars in the video
% Copyright 2018 The MathWorks, Inc.
%% Read the video into MATLAB
%vidreader documentation: https://www.mathworks.com/help/matlab/ref/videoreader.html
vidReader = VideoReader('vid.m4v');
%opticFlow = opticalFlowFarneback;
%% Estimate Optical Flow of each frame

% alternate is ssim_image
initialTime = 0;
vidReader.CurrentTime = initialTime;
startFrame = im2double(readFrame(vidReader));
vidReader.CurrentTime = initialTime;
binary = mean_image(vidReader);

SE = strel('square',20);
morphed = imclose(binary, SE);
no_circles = 1 - bwareaopen(imcomplement(morphed), 10000);

%image that user defines a selection on
selection_image = no_circles ./2 + startFrame ./2;
imshow(selection_image);
sound(randn(4096, 1), 8192)
selection = drawassisted();
selection_mask = createMask(selection);
final_mask = (selection_mask) - (1-no_circles);
color_mask =  cat(3, final_mask, final_mask, final_mask);


start_masked = startFrame .* color_mask;

min_ssd_v = -1;
min_ssd_time = 0;
vidReader.CurrentTime = initialTime + 4;
while hasFrame(vidReader)
        frameRGB = im2double(readFrame(vidReader)) .* color_mask;
        X = frameRGB - start_masked;
        ssd = sum(X(:).^2);
        if (min_ssd_v == -1 || ssd < min_ssd_v)
            min_ssd_v = ssd;
            min_ssd_time = vidReader.CurrentTime;
        end
end


vidReader.CurrentTime = initialTime;
other_mask = logical(1-color_mask);
sound(randn(4096, 1), 8192);

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'test2.gif';
bool = 1;
while true
    if (vidReader.CurrentTime >= min_ssd_time)
        break;
    end
    frameRGB = im2double(readFrame(vidReader));
    frameRGB(other_mask) = startFrame(other_mask);
    imshow(frameRGB);
     [imind,cm] = rgb2ind(frameRGB,256); 
      % Write to the GIF File 
      if bool == 1 
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'Loopcount',inf); 
          bool = 0;
      else 
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1,'WriteMode','append'); 
      end 
end



