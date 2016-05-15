function q = qpos(q)

% QPOS  Positive form of the rotation quaternion
% 
% Ensure that the scalar part (4th element) of the rotation quaternion is 
% positive, which corresponds to the "near" rotation instead of the "long
% way around".
% 
% Inputs:
%
% q   Set of quaternions (4-by-n)
% 
% Outputs:
%
% q   Set of quaternions with positive scalar part (4-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % If running in MATLAB, use vectorized operation.
    if isempty(coder.target)
        
        neg = q(4,:) < 0;
        q(:,neg) = -q(:,neg);
        
    % Otherwise, use a loop.
    else
        
        for k = 1:size(q, 2)
            if q(4,k) < 0
                q(:,k) = -q(:,k);
            end
        end
        
    end
    
end % qpos
