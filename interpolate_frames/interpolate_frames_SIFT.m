function [ frames ] = interpolate_frames_SIFT(num_frames, img1, img2)
    frames = cell(num_frames);
    
    % 1) calculate flow
    opticFlow = opticalFlowHS();
    flow = estimateFlow(opticFlow,img1); 

    
    imshow(img1) 
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off 

    flow2 = estimateFlow(opticFlow,img2); 
    imshow(img2) 
    hold on
    plot(flow2,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off 

   
    
    % 2) scale by dividing by # of frames + 1
    
    % 3) loop by incrementing scaled 