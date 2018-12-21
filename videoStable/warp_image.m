% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Warps an img according to projective transfomation T

function [ im1, im2, overlap ] = warp_image(A, B, T)
    
    T_inv = inv(T);
    
    % warp im1 into im2 reference point
    [A_rows, A_cols] = size(A);
    [B_rows, B_cols] = size(B);

    % 1) find bounds of combined image
    top_left_unscaled = T * [1; 1; 1];
    top_right_unscaled = T * [A_cols; 1; 1];
    bot_left_unscaled = T * [1; A_rows; 1];
    bot_right_unscaled = T * [A_cols; A_rows; 1];
    
    % 2) scale bounds of new image
    top_left = top_left_unscaled(1:2) ./ top_left_unscaled(3);
    top_right = top_right_unscaled(1:2) ./ top_right_unscaled(3);
    bot_left = bot_left_unscaled(1:2) ./ bot_left_unscaled(3);
    bot_right = bot_right_unscaled(1:2) ./ bot_right_unscaled(3);
    
    % figure out how much we need to grow image by
    x_coords = [top_left(1), top_right(1), bot_left(1), bot_right(1)];
    y_coords = [top_left(2), top_right(2), bot_left(2), bot_right(2)];
    
    top_grow = 0;
    left_grow = 0;
    right_grow = 0;
    bottom_grow = 0;
    
    if min(y_coords) < 0
        top_grow = -1 .* min(y_coords);
    end
    
    if min(x_coords) < 0
        left_grow = -1 .* min(x_coords);
    end
    
    if max(y_coords) > B_cols
        bottom_grow = max(y_coords) - B_cols;
    end
    
    if max(x_coords) > B_rows
        right_grow = max(x_coords) - B_rows;
    end
  
    frame_rows = B_rows;
    frame_cols = B_cols;
    frame = zeros(frame_rows, frame_cols,3);

    [frameX, frameY] = meshgrid(1:frame_cols,1:frame_rows);
   
    
    BX = zeros(size(frameX,1),size(frameX,2));
    BY = zeros(size(frameX,1),size(frameX,2));

    for i=1:size(frameX,1)
        for j=1:size(frameX,2)

        coord = T_inv * [frameX(i,j); frameY(i,j); 1];
        BX(i,j) = coord(1) ./ coord(3);
        BY(i,j) = coord(2) ./ coord(3);
        end
    end
    
    [AX,AY] = meshgrid(1:A_cols,1:A_rows);
    Vq_r = interp2(AX,AY,A,BX,BY);
    Vq_g = interp2(AX,AY,A,BX,BY);
    Vq_b = interp2(AX,AY,A,BX,BY);
    
        
    % build image 2
    for i=1:size(B,1)
        for j=1:size(B,2)
            if i
            fx = i;
            fy = j;
            frame2(fx, fy,1) = B(i,j);
            frame2(fx, fy,2) = B(i,j);
            frame2(fx, fy,3) = B(i,j);

            frame_overlap(fx,fy) = frame_overlap(fx,fy) + 1;
        end
    end
    
    overlap = frame_overlap > 1;
    im1 = frame1;
    im2 = frame2;
end