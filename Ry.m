function R = Ry(theta)

% Ry
% 
% Produces a direction cosine matrix (rotation) corresponding to a frame
% rotation about [0 1 0]'.
%
% Note that this is *frame* rotation and is the opposite of *vector* 
% rotation.
%
% For example, suppose we're observing a vector in some frame, A, called
% vA. Now let's suppose that some frame, B, is rotated from A by theta
% about [0 1 0]'. Then the vector expressed in the rotated frame, B, is
% given by:
%
% vB = Ry(theta) * vA;
%
% Let's look at the opposite. Suppose some vector is v = [0 1 0]', and we
% want to rotate this vector (not the frame from which we view it) by pi/4.
% Since this is the opposite of frame rotation, we can achieve the rotated
% vector with either:
%
% vr = Ry(-pi/4) * [0 1 0]'
%
% or
%
% vr = Ry(pi/4)' * [0 1 0]'
%
% This usage corresponds with the general notation used in _Quaternions and
% Rotation Sequences_ by Jack B. Kuiper.
%
% See also: Rx, Rz, aa2dcm

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % c = cos(theta);
    % s = sin(theta);
    % R = [ c  0 -s; ...
    %       0  1  0; ...
    %       s  0  c];
	R = zeros(3, 3, size(theta, 2));
    R(2,2,:) = 1;
    R(1,1,:) = cos(theta);
    R(3,3,:) = R(1,1,:);
    R(3,1,:) = sin(theta);
    R(1,3,:) = -R(3,1,:);
      
end % Ry
