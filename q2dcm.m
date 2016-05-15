function dcm = q2dcm(q)

% Q2DCM  Rotation quaternion to direction cosine matrix
%
% Converts the rotation quaternion into a direction cosine matrix.
%
%   R = Q2AA(q)
%
% Inputs:
%
% q  Rotation quaternion(s) (4-by-n)
% 
% Outputs:
%
% R  Direction cosine matrix or matrices (3-by-3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    dcm = zeros(3, 3, size(q, 2), class(q));
	dcm(1,1,:) = 1 - 2*(q(2,:).*q(2,:) + q(3,:).*q(3,:));
	dcm(1,2,:) = 2.*(q(1,:).*q(2,:) + q(4,:).*q(3,:));
	dcm(1,3,:) = 2.*(q(1,:).*q(3,:) - q(4,:).*q(2,:));
	dcm(2,1,:) = 2.*(q(1,:).*q(2,:) - q(4,:).*q(3,:));
	dcm(2,2,:) = 1 - 2*(q(1,:).*q(1,:) + q(3,:).*q(3,:));
	dcm(2,3,:) = 2.*(q(2,:).*q(3,:) + q(4,:).*q(1,:));
	dcm(3,1,:) = 2.*(q(1,:).*q(3,:) + q(4,:).*q(2,:));
	dcm(3,2,:) = 2.*(q(2,:).*q(3,:) - q(4,:).*q(1,:));
	dcm(3,3,:) = 1 - 2*(q(1,:).*q(1,:) + q(2,:).*q(2,:));

end % q2dcm
