% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Run RANSAC to recover the homography. 
%
%
% X1:           x location of the correspondence points in image A
% y1:           y location of the correspondence points in image A
% X1:           x location of the correspondence points in image B
% Y1:           y location of the correspondence points in image B
%
%
% model:        the recovered homography (|3|x|3| matrix)

function [model] = ransac(X1, Y1, X2, Y2)
    % your code here.
    % use (and implement) calculate_transform to calculate a homography
    % between many random sets of points. 
    % return the homography with the most inliers.

    num_points = size(X1,1);

    
    %placeholder
    best_model = [1 0 -50; ...
             0 1 -50; ...
             0 0 1];
    best_inliers = -1;    
     
         
    % repeat 1000 times
    for n=1:1000
        % select random points
        num_rand = 4;
        rand_idx = generate_n_rand(num_points,num_rand);
        X1r = zeros(num_rand,1);
        Y1r = zeros(num_rand,1);
        X2r = zeros(num_rand,1);
        Y2r = zeros(num_rand,1);
        
        for i=1:num_rand
            X1r(i) = X1(rand_idx(i));
            Y1r(i) = Y1(rand_idx(i));
            X2r(i) = X2(rand_idx(i));
            Y2r(i) = Y2(rand_idx(i));
        end
        
        T = calculate_transform(X1r,Y1r,X2r,Y2r);

        % count number of inliers
        inliers = 0;
        for i=1:num_points
            pair_b = T * [X1(i);Y1(i);1];
            
            x_diff = X2(i) - pair_b(1) ./ pair_b(3);
            y_diff = Y2(i) - pair_b(2) ./ pair_b(3);
            %dist = sqrt(x_diff.^2 + y_diff.^2)
            dist = x_diff.^2 + y_diff.^2;
            
            if (dist <= .8)
                inliers = inliers + 1;
            end
        end
        %if inliers < 4

        % if best, set best model
        if inliers > best_inliers
            best_model = T;
            best_inliers = inliers;
        end
    end
    
    model = [best_model(1,1), best_model(2,1), best_model(3,1);
            best_model(1,2), best_model(2,2), best_model(3,2);
            best_model(1,3), best_model(2,3), best_model(3,3)];
end