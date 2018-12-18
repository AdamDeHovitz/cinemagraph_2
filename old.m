%% Estimating Optical Flow
% This example uses the Farneback Method to to estimate the direction and speed of moving
% cars in the video
% Copyright 2018 The MathWorks, Inc.
%% Read the video into MATLAB
%vidreader documentation: https://www.mathworks.com/help/matlab/ref/videoreader.html
vidReader = VideoReader('vid.m4v');
opticFlow = opticalFlowFarneback;
%% Estimate Optical Flow of each frame
accumulatedFlow = zeros(1080, 1920);
meanImage = zeros(1080, 1920, 3);
i = 0;
while hasFrame(vidReader)
    frameRGB = im2double(readFrame(vidReader));
    meanImage = meanImage + frameRGB;
    %frameGray = rgb2gray(frameRGB);
    %flow = estimateFlow(opticFlow,frameGray);
%     if mod(i, 50) == 0e
%         flow = estimateFlow(opticFlow,frameGray);
%         if (i > 0)
%             accumulatedFlow = accumulatedFlow + flow.Magnitude;
%         end
%     end
    
    % imshow(frameRGB)
    % hold on
    % % Plot the flow vectors
    % plot(flow,'DecimationFactor',[25 25],'ScaleFactor', 2)
    % % Find the handle to the quiver object
    % q = findobj(gca,'type','Quiver');
    % % Change the color of the arrows to red
    % q.Color = 'r';
    % drawnow
    % hold off
    i = i + 1;
end
imshow(meanImage ./ i);