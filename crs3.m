function m = crs3(v)

% crs3
%
% Produces a skew-symmetric "cross product" matrix from 3D vector such 
% that:
%
%    cross(a, b) == skew(a) * b.
%
% When v is 3-by-n, m will be 3-by-3-by-n.
% 
% Interface:
% 
%   m = crs3(v);
%
% Inputs:
%
% v   A 3D vector or vectors (3-by-n)
%
% Outputs:
%
% m   Cross product matrix or matrices (3-by-3-by-n)

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
