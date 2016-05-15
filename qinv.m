function q = qinv(q)

% qinv
%
% Inverts the input quaternion(s), representing the opposite rotation(s).
% The scalar term is not modified, but the axis of rotation is reverse, so
% that this function keeps the quaternion "positive".

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % Invert the vector part.
    q(1:3,:) = -q(1:3,:);
    
end % qinv
