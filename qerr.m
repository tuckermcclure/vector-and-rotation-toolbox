function theta = qerr(q_CA, q_BA)

% QERR  Angle of one rotation quaternion wrt another
%
% Calculates the rotation angle of the first quaternion wrt the second 
% quaternion.
% 
%   theta = QERR(q_CA, q_BA)
%
% This is equivalent to:
%
%   q_CB = q2aa(qcomp(q_CA, qinv(q_BA)));
%
% Inputs:
%
% q_CA  Rotation quaternion representing frame C wrt frame A (4-by-n)
% q_BA  Rotation quaternion representing frame B wrt frame A (4-by-n)
%
% Outputs:
%
% theta  Rotation angle of frame C wrt frame B (1-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q_CA, 1) ~= 4 && size(q_CA, 2) == 4, q_CA = q_CA.'; end;
    if size(q_BA, 1) ~= 4 && size(q_BA, 2) == 4, q_BA = q_BA.'; end;
    assert(size(q_CA, 1) == 4 && size(q_BA, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % theta = q2aa(qcomp(q_CA, qinv(q_BA))), but this is faster.
    
    % Dot the quaternions together.
    theta =   q_CA(1,:).*q_BA(1,:) + q_CA(2,:).*q_BA(2,:) ...
            + q_CA(3,:).*q_BA(3,:) + q_CA(4,:).*q_BA(4,:);

    % We want the smallest angle from one quaternion to the other, so
    % reverse the rotation where q4 < 0 to obtain the smaller rotation.
    if isempty(coder.target) % MATLAB
        theta(theta < 0) = -theta(theta < 0);
        theta(theta > 1) = 1;
    else % codegen
        for k = 1:size(q_CA, 2)
            if theta(k) < 0
                theta(k) = -theta(k);
            end
            if theta(k) > 1
                theta(k) = 1;
            end
        end
    end
    
    % Turn the sum into an angle.
    theta = 2 * acos(theta);

end % qdiff

