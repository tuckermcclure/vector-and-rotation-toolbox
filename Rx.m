function R = Rx(theta)

% RX  Direction cosine matrix of rotation about +x
% 
% Produces a direction cosine matrix (rotation matrix) corresponding to a
% frame rotation about [1; 0; 0].
%
%   R = RX(theta);
%
% Naturally, this corresponds to aa2dcm([1; 0; 0], theta), but this is
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
