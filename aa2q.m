function q = aa2q(a, theta)

% aa2q
%
% Convert axis-angle format to quaternion.
%
% If theta represents the rotation of frame A wrt frame B about an axis a
% (specified in either A or B -- it doesn't matter which), then this
% function returns a unit quaternion representing the same rotation. E.g.,
% if frame A is rotated 45 degrees about [1; 0; 0] from frame B, then the
% axis and angles are:
%
% theta_AB = pi/4;
% a_A      = [1; 0; 0];
% q_AB     = aa2q(a_A, theta_AB);
%
% The function is vectorized to accept the axes as 3-by-n matrices with
% corresponding 1-by-n angles.

% Copyright 2016 An Uncommon Lab

%#codegen

    % This is pleasantly both vectorized for speed in MATLAB *and* good C
    % code generation.
    s = sin(0.5 * theta);
    q = [cos(0.5 * theta); ...
         s .* a(1,:); ...
         s .* a(2,:); ...
         s .* a(3,:)];

end % aa2q
