function [theta, r] = dcm2aa(R)

% [theta, r] = dcm2aa(R)
%
% Kuipers, Jack B., _Quaternions and Rotation Sequences: A Primer with
% Applications to Orbits, Aerospace, and Virtual Reality_. Princeton:
% Princeton University Press. 1999. Book. Page 66.

% Copyright 2016 An Uncommon Lab

%#codegen

    % Dims
    n = size(R, 3);
    assert(size(R, 1) == 3 && size(R, 2) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    
    % Angle of rotation
    theta    = zeros(1, n, class(R));
    theta(:) = R(1,1,:) + R(2,2,:) + R(3,3,:); % Vectorized trace
    theta(:) = acos(0.5*(theta - 1));
    
    % Axes of rotation
    if nargin >= 2
        r        = zeros(3, n, class(R));
        r(1,:)   = R(2,3,:) - R(3,2,:);
        r(2,:)   = R(3,1,:) - R(1,3,:);
        r(3,:)   = R(1,2,:) - R(2,1,:);
        r        = normalize(r);
    end

end % dcm2aa
