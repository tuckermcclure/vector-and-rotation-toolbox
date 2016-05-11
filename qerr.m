function theta = qerr(q_CA, q_BA)

% Copyright 2016 An Uncommon Lab

%#codegen

    % theta = q2aa(qcomp(q_CA, qinv(q_BA))), but this is faster.
    
    % Dot the quaternions together.
    theta =   q_CA(1,:).*q_BA(1,:) + q_CA(2,:).*q_BA(2,:) ...
            + q_CA(3,:).*q_BA(3,:) + q_CA(4,:).*q_BA(4,:);

    % We want the smallest angle from one quaternion to the other, so
    % reverse the rotation where q4 < 0 to obtain the smaller rotation.
    if isempty(coder.target) % MATLAB
        theta(theta < 0) = -theta(theta < 0);
    else % codegen
        for k = 1:size(q_CA, 2)
            if theta(k) < 0
                theta(k) = -theta(k);
            end
        end
    end
    
    % Turn the sum into an angle.
    theta = 2 * acos(theta);

end % qdiff

