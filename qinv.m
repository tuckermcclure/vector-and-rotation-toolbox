function q = qinv(q)

% qinv
%
% Inverts the input quaternion(s), representing the opposite rotation(s).
% The scalar term is not modified, but the axis of rotation is reverse, so
% that this function keeps the quaternion "positive".

% Copyright 2016 An Uncommon Lab

%#codegen

    % This is pretty easy.
    q(1,:) = -q(1,:);
    q(2,:) = -q(2,:);
    q(3,:) = -q(3,:);
    
end % qinv
