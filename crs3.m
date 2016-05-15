function m = crs3(v)

% crs3  cross product matrix
%
% Produces a skew-symmetric "cross product matrix" from a 3-dimensional
% vector:
% 
%   m = crs3(v);
%
% such that cross(a, b) == crs3(a) * b.
%
% When the input vectors are 3-by-n, the cross product matrix for each
% column will be computed, and the output will be 3-by-3-by-n.
% 
% Inputs:
%
% v   Vector(s) (3-by-n)
%
% Outputs:
%
% m   Cross product matrix (matrices) (3-by-3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    assert(size(v, 1) == 3, ...
           '%s: The vectors must be 3-by-n.', mfilename);

    % m = [ 0    -v(3)  v(2); ...
    %       v(3)  0    -v(1); ...
    %      -v(2)  v(1)  0];
    m = zeros(3, 3, size(v, 2), class(v));
    m(1,2,:) = -v(3,:);
    m(1,3,:) =  v(2,:);
    m(2,1,:) =  v(3,:);
    m(2,3,:) = -v(1,:);
    m(3,1,:) = -v(2,:);
    m(3,2,:) =  v(1,:);

end % crs3
