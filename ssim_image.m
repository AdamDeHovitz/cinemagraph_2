function [ binary ] = ssim_image(vidReader)
    ssim_total = zeros(vidReader.height, vidReader.width);
    i = 0;
    ref = rgb2gray(im2double(readFrame(vidReader)));
    while hasFrame(vidReader)
        frameRGB = rgb2gray(im2double(readFrame(vidReader)));
        [~, ssim_map] = ssim(frameRGB, ref);
        ref = frameRGB;
        ssim_total = ssim_total + ssim_map;
        i = i + 1;
    end
    ssim_final = ssim_total ./ i;


    threshold = mean(ssim_final(:));
    binary = imbinarize(ssim_final, threshold);
end