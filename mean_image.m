function [ binary ] = mean_image(vidReader)
    meanImage = zeros(vidReader.height, vidReader.width);
    i = 0;
    while hasFrame(vidReader)
        frameRGB = rgb2gray(im2double(readFrame(vidReader)));
        meanImage = meanImage + frameRGB;
        i = i + 1;
    end
    vidReader.CurrentTime = 0;
    meanImage = meanImage ./ i;
    maxDif = zeros(vidReader.height, vidReader.width);
    while hasFrame(vidReader)
        frameRGB = rgb2gray(im2double(readFrame(vidReader)));
        frame_dif = abs(meanImage - frameRGB);
        replace = frame_dif > maxDif;
        maxDif(replace) = frame_dif(replace);
    end
    threshold = mean(maxDif(:)) + std(maxDif(:));
    binary = imbinarize(maxDif, threshold);
end