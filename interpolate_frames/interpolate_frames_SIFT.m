% Note that this is SUPER slow wo downsizing and it also crops image
% slightly
function [ frames ] = interpolate_frames_SIFT(num_frames, img1, img2)
    frames = cell(num_frames);
    addpath(genpath('release'));
    downsize = true;
    
    % downsize images
    if (downsize)
        im1=imresize(imfilter(img1,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');
        im2=imresize(imfilter(img2,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');
        im1=im2double(im1);
        im2=im2double(im2);
    else
        im1 = img1;
        im2 = img2;
    end
    
    % 1) calculate flow
    [Vx, Vy, Im1, Im2] = getSIFT(im1, im2);    
    [Vx_r, Vy_r, Im1_r, Im2_r] = getSIFT(im2, im1);    

    
    % 2) scale by dividing by # of frames + 1
    vx = Vx ./ (num_frames + 1);
    vy = Vy ./ (num_frames + 1);
    
    % setup for warping
    [x, y] = meshgrid(1:size(img2,2), 1:size(img2,1));
    
    % 3) loop by incrementing scaled 
    for i=1:num_frames
        %[x, y] = meshgrid(1:size(img2,2), 1:size(img2,1));
        cur_vx = vx .* i;
        cur_vy = vy .* i;
        cur_base = warpImage(Im1, Im2, vx .* (num_frames + 1 - i), vy .* (num_frames + 1 - i));
        D = warpImage(Im2, cur_base, cur_vx, cur_vy);
        %D = interp2(double(img2), x-cur_vx, y-cur_vy);
        %D = imfuse(D, cur_base, 'blend');
        imshow(D);
        frames{i} = D;
    end        
