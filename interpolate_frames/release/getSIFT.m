function [vx, vy, Im1, Im2, patchsize] = getSIFT(im1, im2)

% Step 1. downsample the images

    im1=imresize(imfilter(im1,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');
    im2=imresize(imfilter(im2,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');

    im1=im2double(im1);
    im2=im2double(im2);
    

    % Step 2. Compute the dense SIFT image

    % patchsize is half of the window size for computing SIFT
    % gridspacing is the sampling precision

    patchsize=8;
    gridspacing=1;

    Sift1=dense_sift(im1,patchsize,gridspacing);
    Sift2=dense_sift(im2,patchsize,gridspacing);

    %{
    % visualize the SIFT image
    figure;title('SIFT image 1');imshow(showColorSIFT(Sift1));
    figure;title('SIFT image 2');imshow(showColorSIFT(Sift2));
    %}
    

    % Step 3. SIFT flow matching

    % prepare the parameters
    SIFTflowpara.alpha=2;
    SIFTflowpara.d=40;
    SIFTflowpara.gamma=0.005;
    SIFTflowpara.nlevels=4;
    SIFTflowpara.wsize=5;
    SIFTflowpara.topwsize=20;
    SIFTflowpara.nIterations=60;

    [vx,vy,energylist]=SIFTflowc2f(Sift1,Sift2,SIFTflowpara);
    
    Im1=im1(patchsize/2:end-patchsize/2+1,patchsize/2:end-patchsize/2+1,:);
    Im2=im2(patchsize/2:end-patchsize/2+1,patchsize/2:end-patchsize/2+1,:);
    
    % visualize
    %warpI2=warpImage(Im2,Im1,vx,vy);
    %warpI2_half=warpImage(Im2,Im1,vx./2,vy./2);
    


    % display flow
    clear flow;
    flow(:,:,1)=vx;
    flow(:,:,2)=vy;
    figure;imshow(flowToColor(flow));title('SIFT flow field');
