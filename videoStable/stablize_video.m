% Note: heavily borrowed from Matlab example code

function [] = stablize_video(in_filename, out_filename)
    hVideoSrc = vision.VideoFileReader(in_filename, 'ImageColorSpace', 'Intensity');
    hVideoSrc_color = vision.VideoFileReader(in_filename, 'ImageColorSpace', 'RGB');

    out_video = VideoWriter(out_filename);
    open(out_video);

    % Reset the video source to the beginning of the file.
    reset(hVideoSrc);
    reset(hVideoSrc_color);

    % Process all frames in the video
    movMean = step(hVideoSrc);
    imgB_color = step(hVideoSrc_color);

    imgB = movMean;
    imgBp = imgB;
    Hcumulative = eye(3);

    % detect initial features for tracking
    ptThresh = 0.15;
    points = detectFASTFeatures(imgB, 'MinContrast', ptThresh);
    %pointImage = insertMarker(imgB,points.Location,'+','Color','white');
    %imshow(pointImage);

    tracker = vision.PointTracker('MaxBidirectionalError',1);
    initialize(tracker,points.Location,imgB);
    pointsB = points.Location;


    while ~isDone(hVideoSrc)
        % Read in new frame
        imgA = imgB; % z^-1
        pointsA = pointsB;
        imgB = step(hVideoSrc);
        imgB_color = step(hVideoSrc_color);
        [points,validity] = tracker(imgB);
        pointsB = points;

        % Estimate transform from frame A to frame B, and fit as an s-R-t
        H = cvexEstStabilizationTform(imgA,imgB, pointsA, pointsB);
        Hcumulative = H * Hcumulative;
        imgBp_r = imwarp(imgB_color(:,:,1),projective2d(Hcumulative),'OutputView',imref2d(size(imgB)));
        imgBp_g = imwarp(imgB_color(:,:,2),projective2d(Hcumulative),'OutputView',imref2d(size(imgB)));
        imgBp_b = imwarp(imgB_color(:,:,3),projective2d(Hcumulative),'OutputView',imref2d(size(imgB)));
        imgBp = cat(3, imgBp_r, imgBp_g, imgBp_b);
        
        writeVideo(out_video,imgBp);
    end
    

    % Here you call the release method on the objects to close any open files
    % and release memory.
    release(hVideoSrc);
    close(out_video);