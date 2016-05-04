function p = q2grp(q, a, f)

% g2grp
% 
% Convert quaternion to generalized Rodriguez parameters (GRP) using GRP
% parameters a and f (generally 1 and 4, respectively). This function is
% vectorized to accept 4-by-n quaternions, returning 3-by-n GRP.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Set some defaults.
    if nargin < 2, a = 1; end;
    if nargin < 3, f = 4; end;

    % p = f * q(2:4) / (a + q(1)); % Individual quaternion.
    
    % We don't want to divide by zero, so take the convention that q0 > 0.
    % First, divide normally where this is true. Then, flip the sign on all
    % q where this isn't true.
    p = zeros(3, size(q, 2));
    for k = 1:size(q, 2)
        if q(1,k) > 0
            p(:,k) = bsxfun(@rdivide,  f * q(2:4,k), (a + q(1,k)));
        else
            p(:,k) = bsxfun(@rdivide, -f * q(2:4,k), (a - q(1,k)));
        end
    end 
    
end % q2grp
