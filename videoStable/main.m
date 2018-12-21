close all;
filename = 'IMG_0728.MOV';
hVideoSrc = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity');


imgA = step(hVideoSrc); % Read first frame into imgA
imgB = step(hVideoSrc); % Read second frame into imgB
imgC = step(hVideoSrc); % Read second frame into imgB
imgD = step(hVideoSrc); % Read second frame into imgB
imgE = step(hVideoSrc); % Read second frame into imgB
imgF = step(hVideoSrc); % Read second frame into imgB

imgA = imgE;
imgB = imgF;

figure; imshowpair(imgA, imgB, 'montage');
title(['Frame A', repmat(' ',[1 70]), 'Frame B']);

figure; imshowpair(imgE,imgF,'ColorChannels','red-cyan');

ptThresh = 0.03;
pointsA = detectFASTFeatures(imgA, 'MinContrast', ptThresh);
pointsB = detectFASTFeatures(imgB, 'MinContrast', ptThresh);

% Display corners found in images A and B.
figure; imshow(imgA); hold on;
plot(pointsA);
title('Corners in A');

figure; imshow(imgB); hold on;
plot(pointsB);
title('Corners in B');

[featuresA, pointsA] = extractFeatures(imgA, pointsA);
[featuresB, pointsB] = extractFeatures(imgB, pointsB);

indexPairs = matchFeatures(featuresA, featuresB);
pointsA = pointsA(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

figure; showMatchedFeatures(imgA, imgB, pointsA, pointsB);
legend('A', 'B');

% warping from documentation

[tform, pointsBm, pointsAm] = estimateGeometricTransform(...
    pointsB, pointsA, 'affine');
imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
pointsBmp = transformPointsForward(tform, pointsBm.Location);

 
% warping from project 5

figure;
showMatchedFeatures(imgA, imgBp, pointsAm, pointsBmp);
legend('A', 'B');

