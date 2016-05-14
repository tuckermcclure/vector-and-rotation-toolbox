function q = aa2q(theta, r)

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

    % Check dimensions.
    assert(nargin == 2, ...
           '%s: Two inputs are required.', mfilename);
    assert(size(theta, 1) == 1, ...
           '%s: The angles must be 1-by-n.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);

    % This is pleasantly both vectorized for speed in MATLAB *and* good C
    % code generation.
    s = sin(0.5 * theta);
    q = [s .* r(1,:); ...
         s .* r(2,:); ...
         s .* r(3,:); ...
         cos(0.5 * theta)];

end % aa2q
