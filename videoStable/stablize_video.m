% Note: heavily borrowed from Matlab example code

function [] = stablize_video(in_filename, out_filename)
    hVideoSrc = vision.VideoFileReader(in_filename, 'ImageColorSpace', 'Intensity');
    out_video = VideoWriter(out_filename);
    open(out_video);

    % Reset the video source to the beginning of the file.
    reset(hVideoSrc);

    % Process all frames in the video
    movMean = step(hVideoSrc);
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
        [points,validity] = tracker(imgB);
        pointsB = points;

        % Estimate transform from frame A to frame B, and fit as an s-R-t
        H = cvexEstStabilizationTform(imgA,imgB, pointsA, pointsB);
        Hcumulative = H * Hcumulative;
        imgBp = imwarp(imgB,projective2d(Hcumulative),'OutputView',imref2d(size(imgB)));

        writeVideo(out_video,imgBp);
    end
    

    % Here you call the release method on the objects to close any open files
    % and release memory.
    release(hVideoSrc);
    close(out_video);