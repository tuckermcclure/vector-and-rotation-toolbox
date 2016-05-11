function R = Rz(theta)

% Rz
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
% vB = Rz(theta) * vA;
%
% Let's look at the opposite. Suppose some vector is v = [0 1 0]', and we
% want to rotate this vector (not the frame from which we view it) by pi/4.
% Since this is the opposite of frame rotation, we can achieve the rotated
% vector with either:
%
% vr = Rz(-pi/4) * [0 1 0]'
%
% or
%
% vr = Rz(pi/4)' * [0 1 0]'
%
% This usage corresponds with the general notation used in _Quaternions and
% Rotation Sequences_ by Jack B. Kuiper.
%
% See also: Ry, Rz, aa2dcm

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % c = cos(theta);
    % s = sin(theta);
    % R = [ c  s  0; ...
    %      -s  c  0; ...
    %       0  0  1];
	R = zeros(3, 3, length(theta), class(theta));
    R(3,3,:) = 1;
    R(1,1,:) = cos(theta);
    R(2,2,:) = R(1,1,:);
    R(1,2,:) = sin(theta);
    R(2,1,:) = -R(1,2,:);
      
end % Rz
