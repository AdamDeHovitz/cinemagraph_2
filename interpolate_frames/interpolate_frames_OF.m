function [ frames ] = interpolate_frames_OF(num_frames, img1, img2)
    [rows, cols, num_channels] = size(img1);
    frames = cell(num_frames, 1);
    
    opticFlow = opticalFlowLK();

    % 1) calculate flow
    if num_channels > 1
        flow = estimateFlow(opticFlow,rgb2gray(img1)); 
        flow = estimateFlow(opticFlow,rgb2gray(img2));
    else
        flow = estimateFlow(opticFlow,img1); 
        flow = estimateFlow(opticFlow,img2);
    end

    
    % (optional) visualize flow
    imshow(img2) 
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off 
    
    % 2) scale by dividing by # of frames + 1
    vx = flow.Vx ./ (num_frames + 1);
    vy = flow.Vy ./ (num_frames + 1);
    
    % setup for warping
    [x, y] = meshgrid(1:size(img2,2), 1:size(img2,1));
    
    % 3) loop by incrementing scaled 
    for i=1:num_frames
        [x, y] = meshgrid(1:size(img2,2), 1:size(img2,1));
        cur_vx = vx .* i;
        cur_vy = vy .* i;
        
        D = zeros(rows,cols,num_channels);
        for j=1:num_channels
            D(:,:,j) = interp2(double(img2(:,:,j)), x-cur_vx, y-cur_vy);
        end
        imshow(D);
        frames{i} = D;
    end        
