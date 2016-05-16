function q_CA = qcomp(q_CB, q_BA)

% QCOMP  Rotation quaternion composition
%
% Composition (multiplication) of two quaternions. Note that this function
% preserves the order of multiplied direction cosine matrices, and so the
% order is backwards from Hamilton's quaternion multiplication. That is,
% if the first input represents frame C wrt frame B, and the second
% represents frame B wrt frame A, then the output will represent the
% rotation of frame C wrt frame A.
%
%   q_CA = QCOMP(q_CB, q_BA);
%
% This preserves the order of the DCMs:
%
%   R_CB = q2dcm(q_CB);
%   R_BA = q2dcm(q_BA);
%   R_CA = R_CB * R_BA;
%
% Inputs:
%
% q_CB  Rotation quaternion of frame C wrt frame B (4-by-n)
% q_BA  Rotation quaternion of frame B wrt frame A (4-by-n)
% 
% Outputs:
% 
% q_CA  Rotation quaternion of frame C wrt frame A (4-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q_CB, 1) ~= 4 && size(q_CB, 2) == 4, q_CB = q_CB.'; end;
    if size(q_BA, 1) ~= 4 && size(q_BA, 2) == 4, q_BA = q_BA.'; end;
    assert(size(q_CB, 1) == 4 && size(q_BA, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % c = ([-crs3(a(1:3)), a(1:3); -a(1:3).', 0] + a(4) * eye(4)) * b;
    q_CA = [ q_CB(4,:).*q_BA(1,:) + q_CB(3,:).*q_BA(2,:) - q_CB(2,:).*q_BA(3,:) + q_CB(1,:).*q_BA(4,:); ...
            -q_CB(3,:).*q_BA(1,:) + q_CB(4,:).*q_BA(2,:) + q_CB(1,:).*q_BA(3,:) + q_CB(2,:).*q_BA(4,:); ...
             q_CB(2,:).*q_BA(1,:) - q_CB(1,:).*q_BA(2,:) + q_CB(4,:).*q_BA(3,:) + q_CB(3,:).*q_BA(4,:); ...
            -q_CB(1,:).*q_BA(1,:) - q_CB(2,:).*q_BA(2,:) - q_CB(3,:).*q_BA(3,:) + q_CB(4,:).*q_BA(4,:)];
     
end % qcomp
