function q_CB = qdiff(q_CA, q_BA)

% QDIFF  Difference of one rotation quaternion wrt another
%
% Calculates the rotation of the first quaternion wrt the second 
% quaternion.
% 
%   q_CB = qdiff(q_CA, q_BA)
%
% This is equivalent to:
%
%   q_CB = qcomp(q_CA, qinv(q_BA));
%
% Inputs:
%
% q_CA  Rotation quaternion representing frame C wrt frame A (4-by-n)
% q_BA  Rotation quaternion representing frame B wrt frame A (4-by-n)
%
% Outputs:
%
% q_CB  Rotation quaternion representing frame C wrt frame B (4-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q_CA, 1) ~= 4 && size(q_CA, 2) == 4, q_CA = q_CA.'; end;
    if size(q_BA, 1) ~= 4 && size(q_BA, 2) == 4, q_BA = q_BA.'; end;
    assert(size(q_CA, 1) == 4 && size(q_BA, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % q_CB = qcomp(q_CA, qinv(q_BA)), but this is faster.
    q_CB = [-q_CA(4,:).*q_BA(1,:) - q_CA(3,:).*q_BA(2,:) + q_CA(2,:).*q_BA(3,:) + q_CA(1,:).*q_BA(4,:); ...
             q_CA(3,:).*q_BA(1,:) - q_CA(4,:).*q_BA(2,:) - q_CA(1,:).*q_BA(3,:) + q_CA(2,:).*q_BA(4,:); ...
            -q_CA(2,:).*q_BA(1,:) + q_CA(1,:).*q_BA(2,:) - q_CA(4,:).*q_BA(3,:) + q_CA(3,:).*q_BA(4,:); ...
             q_CA(1,:).*q_BA(1,:) + q_CA(2,:).*q_BA(2,:) + q_CA(3,:).*q_BA(3,:) + q_CA(4,:).*q_BA(4,:)];

end % qdiff

