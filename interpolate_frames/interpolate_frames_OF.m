function [ frames ] = interpolate_frames_OF(num_frames, img1, img2)
    frames = cell(num_frames);
    
    % 1) calculate flow
    opticFlow = opticalFlowLK();
    flow = estimateFlow(opticFlow,img1); 
    flow = estimateFlow(opticFlow,img2);
    
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
        D = interp2(double(img2), x-cur_vx, y-cur_vy);
        imshow(D);
        frames{i} = D;
    end        
