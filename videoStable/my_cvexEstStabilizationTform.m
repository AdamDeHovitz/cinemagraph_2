function tform = my_cvexEstStabilizationTform(imgA,imgB,pointsA, pointsB)
    [featuresA, pointsA] = extractFeatures(imgA, pointsA);
    [featuresB, pointsB] = extractFeatures(imgB, pointsB);
  
    pointImageB = insertMarker(imgB,pointsB,'+','Color','white');
    imshow(pointImageB);

    pointImageA = insertMarker(imgA,pointsA,'+','Color','white');
    imshow(pointImageA);


    indexPairs = matchFeatures(featuresA, featuresB);
    pointsA = pointsA(indexPairs(:, 1), :);
    pointsB = pointsB(indexPairs(:, 2), :);
    
    tform = ransac(pointsB(:,2), pointsB(:,1), pointsA(:,2), pointsA(:,1));
    tform = inv(pinv(tform));