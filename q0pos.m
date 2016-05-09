function q = q0pos(q)

% q0pos
% 
% Ensure that the scalar part (4th element) of the quaternion is positive.
% 
% Inputs:
%
% q   Set of quaternions, 4-by-n
% 
% Outputs:
%
% q   Set of quaternions with positive scalar part.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % If running in MATLAB, use vectorized operation.
    if isempty(coder.target)
        
        neg = q(1,:) < 0;
        q(:,neg) = -q(:,neg);
        
    % Otherwise, use a loop.
    else
        
        for k = 1:size(q, 2)
            if q(1,k) < 0
                q(:,k) = -q(:,k);
            end
        end
        
    end
    
end % q0pos
