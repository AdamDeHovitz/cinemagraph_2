function H = cvexEstStabilizationTform(imgA,imgB,pointsA, pointsB)
    [featuresA, pointsA] = extractFeatures(imgA, pointsA);
    [featuresB, pointsB] = extractFeatures(imgB, pointsB);
  
    
    indexPairs = matchFeatures(featuresA, featuresB);
    pointsA = pointsA(indexPairs(:, 1), :);
    pointsB = pointsB(indexPairs(:, 2), :);
    
    [tform, pointsBm, pointsAm] = estimateGeometricTransform(...
    pointsB, pointsA, 'projective');
    
    H = tform.T;
    
