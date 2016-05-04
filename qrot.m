function v = qrot(q, v)

% Rotate a vector in frame B, v_B, to frame A given the quaternion
% representing A wrt B, q_AB.
%
% v_A = qmult(qconj(q_AB), qmult([0; v_B], q_AB))

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    for k = 1:size(q, 2)
        vcq = cross3(v(:,k), q(2:4,k));
        v(:,k) =   q(1,k) * q(1,k) * v(:,k) ...
                 + (2 * q(1,k)) * vcq ...
                 + sum(v(:,k) .* q(2:4,k)) * q(2:4,k) ...
                 - cross3(q(2:4,:), vcq);
    end

    % vcq = cross3(v, q(2:4,:));
    % v =   bsxfun(@times, q(1,:).^2, v) ...
    %     + bsxfun(@times, (2 * q(1,:)), vcq) ...
    %     + bsxfun(@times, sum(v .* q(2:4,:)), q(2:4,:)) ...
    %     - cross3(q(2:4,:), vcq);

end % qrot
