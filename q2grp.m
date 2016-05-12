function p = q2grp(q, a, f)

% g2grp
% 
% Convert quaternion to generalized Rodriguez parameters (GRP) using GRP
% parameters a and f (generally 1 and 4, respectively). This function is
% vectorized to accept 4-by-n quaternions, returning 3-by-n GRP.

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set some defaults.
    if nargin < 2, a = 1; end;
    if nargin < 3, f = 4; end;

    % p = f * q(2:4) / (a + q(1));  % individual quaternion, q(1) > 0
    % p = -f * q(2:4) / (a - q(1)); % if q(1) < 0

    % Pre-allocate.
    n = size(q, 2);
    p = zeros(3, n, class(q));
    
    % In MATLAB? Vectorize.
    if isempty(coder.target)

        pos       = q(4,:) > 0;
        s         = zeros(1, n, class(q));
        s( pos)   = f ./ (a + q(4, pos));
        s(~pos)   = f ./ (a - q(4,~pos));
        p(:, pos) =  q(1:3, pos);
        p(:,~pos) = -q(1:3,~pos);
        p(1,:)    = s .* p(1,:);
        p(2,:)    = s .* p(2,:);
        p(3,:)    = s .* p(3,:);
        
    % In code? Loop.
    else
 
        for k = 1:n
            if q(4,k) > 0
                p(:,k) =  f / (a + q(4,k)) * q(1:3,k);
            else
                p(:,k) = -f / (a - q(4,k)) * q(1:3,k);
            end
        end
        
    end
    
end % q2grp
