function [p, s] = q2grp(q, a, f)

% g2grp
% 
% Convert quaternion to generalized Rodriguez parameters (GRP) using GRP
% parameters a and f (generally 1 and 4, respectively). This function is
% vectorized to accept 4-by-n quaternions, returning 3-by-n GRP.

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set some defaults.
    if nargin < 2 || isempty(a), a = 1;       end;
    if nargin < 3 || isempty(f), f = 2*(a+1); end;

    % p =  f * q(2:4) / (a + q(4)); % individual quaternion, q(4) > 0
    % p = -f * q(2:4) / (a - q(4)); % if q(4) < 0

    % Pre-allocate.
    n = size(q, 2);
    p = zeros(3, n, class(q));
    
    % In MATLAB? Vectorize.
    if isempty(coder.target)

        % Identify the "long way around" sets.
        pos       = q(4,:) > 0;
        c0        = zeros(1, n, class(q));
        c0( pos)  = f ./ (a + q(4, pos));
        c0(~pos)  = f ./ (a - q(4,~pos));
        p(:, pos) =  q(1:3, pos);
        p(:,~pos) = -q(1:3,~pos);
        p(1,:)    = c0 .* p(1,:);
        p(2,:)    = c0 .* p(2,:);
        p(3,:)    = c0 .* p(3,:);
        
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
    
    % This function always provides the "short" way around, corresponding
    % to q4 > 0.
    if nargout >= 2
        s = false(1, n);
    end
    
end % q2grp
