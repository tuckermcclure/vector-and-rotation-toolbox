function R = Ry(theta)

% RY  Direction cosine matrix of rotation about +x
% 
% Produces a direction cosine matrix (rotation matrix) corresponding to a
% frame rotation about [0; 1; 0].
%
%   R = RY(theta);
%
% Naturally, this corresponds to aa2dcm([0; 1; 0], theta), but this is
% faster and requires less RAM.
%
% Inputs:
% 
% theta  Rotation angles (1-by-n)
%
% Outputs:
% 
% R      Direction cosine matrix (3-by-3-by-n)
%
% See also: Rx, Rz, aa2dcm

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(theta, 1) ~= 1 && size(theta, 2) == 1; theta = theta.'; end;
    assert(size(theta, 1) == 1, ...
           '%s: The angles should be 1-by-n.', mfilename);

    % c = cos(theta);
    % s = sin(theta);
    % R = [ c  0 -s; ...
    %       0  1  0; ...
    %       s  0  c];
	R = zeros(3, 3, length(theta), class(theta));
    R(2,2,:) = 1;
    R(1,1,:) = cos(theta);
    R(3,3,:) = R(1,1,:);
    R(3,1,:) = sin(theta);
    R(1,3,:) = -R(3,1,:);
      
end % Ry
