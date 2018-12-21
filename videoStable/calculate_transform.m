% Automated Panorama Stitching stencil code
% CS 129 Computational Photography, Brown U.
%
% Given a set of corresponding points, find the least square solution 
% of the homography that transforms between them. 
%
%
% X1:           x location of the correspondence points in image A
% Y1:           y location of the correspondence points in image A
% X2:           x location of the correspondence points in image B
% Y2:           y location of the correspondence points in image B
%
%
% T:            the calculated homography (|3|x|3| matrix)

function T = calculate_transform(X1, Y1, X2, Y2)

    num_points = size(X1,1);
    b = cat(1,X2,Y2);
    A = zeros(num_points * 2, 8);
    
        
    % set first 3 columns
    A(1:num_points,1) = X1;
    A(1:num_points,2) = Y1;
    A(1:num_points,3) = 1;
    
    % set next 3 columns
    A(num_points + 1:end,4) = X1;
    A(num_points + 1:end,5) = Y1;
    A(num_points + 1:end,6) = 1;

    % last 2 columns
    A(1:num_points,7) = -1 .* X1 .* X2;
    A(1:num_points,8) = -1 .* Y1 .* X2;
    
    A(num_points+1:end,7) = -1 .* X1 .* Y2;
    A(num_points+1:end,8) = -1 .* Y1 .* Y2;

    x = A \ b;
    
    % Placeholder code
    T = [x(1),x(2),x(3);x(4),x(5),x(6);x(7),x(8),1];
end