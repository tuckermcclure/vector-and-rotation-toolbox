function q = aa2q(theta, r)

% aa2q  angle-axis to quaternion
%
% Convert an angle and axis of rotation to a quaternion. This is vectorized
% to take multiple angles (1-by-n) and corresponding axes (3-by-n).
%
%   q = aa2q(theta, r)
%
% For a single angle and axis, this is simply the definition of the
% rotation quaternion.
%
%   q = [sin(theta/2) * r; cos(theta/2)];
%
% Inputs:
%
% r      Unit axis (or axes) of right-handed rotation (3-by-n)
% theta  Angle(s) of rotation of frame B wrt A about r (1-by-n)
%
% Outputs:
%
% q      Rotation quaternion representing frame B wrt frame A (4-by-n)
%
% Example:
%
% theta_BA = pi/4;                % Frame B is rotated 45 deg from frame A
% r_A      = [0; 0; 1];           % about the z axis.
% q_BA     = aa2q(theta_BA, r_A); % Create the quaternion.
% v_A      = [1; 0; 0];           % Make an arbitary vector in frame A.
% v_B      = qrot(q_BA, v_A)      % What is the vector in frame B?

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
