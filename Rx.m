function R = Rx(theta)

% Rx
% 
% Produces a direction cosine matrix (rotation) corresponding to a frame
% rotation about [1 0 0]'.
%
% Note that this is *frame* rotation and is the opposite of *vector* 
% rotation.
%
% For example, suppose we're observing a vector in some frame, A, called
% vA. Now let's suppose that some frame, B, is rotated from A by theta
% about [1 0 0]'. Then the vector expressed in the rotated frame, B, is
% given by:
%
% vB = Rx(theta) * vA;
%
% Let's look at the opposite. Suppose some vector is v = [0 1 0]', and we
% want to rotate this vector (not the frame from which we view it) by pi/4.
% Since this is the opposite of frame rotation, we can achieve the rotated
% vector with either:
%
% vr = Rx(-pi/4) * [0 1 0]'
%
% or
%
% vr = Rx(pi/4)' * [0 1 0]'
%
% This usage corresponds with the general notation used in _Quaternions and
% Rotation Sequences_ by Jack B. Kuiper.
%
% See also: Ry, Rz, aa2dcm

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(theta, 1) ~= 1 && size(theta, 2) == 1; theta = theta.'; end;
    assert(size(theta, 1) == 1, ...
           '%s: The angles should be 1-by-n.', mfilename);

    % c = cos(theta);
    % s = sin(theta);
    % R = [ 1  0  0; ...
    %       0  c  s; ...
    %       0 -s  c];
	R = zeros(3, 3, length(theta), class(theta));
    R(1,1,:) = 1;
    R(2,2,:) = cos(theta);
    R(3,3,:) = R(2,2,:);
    R(2,3,:) = sin(theta);
    R(3,2,:) = -R(2,3,:);
      
end % Rx
