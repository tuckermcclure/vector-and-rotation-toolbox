function p = q2mrp(q, f)

% q2mrp
% 
% Convert quaternion to modified Rodriguez parameters (MRPs), with an 
% optional MRP scaling factor. This function is vectorized to accept 4-by-n
% quaternions, returning 3-by-n MRPs.

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 2 || isempty(f), f = 1; end;

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

    % p =  f * q(1:3) / (1 + q(4)); % individual quaternion, q(4) > 0
    % p = -f * q(1:3) / (1 - q(4)); % if q(4) < 0

    % Preallocate.
    n = size(q, 2);
    p = zeros(3, n, class(q));
    
    % In MATLAB? Vectorize.
    if isempty(coder.target)

        % Create the coefficient so as to return only the "short way
        % around" sets.
        pos      = q(4,:) > 0;
        c0       = zeros(1, n, class(q));
        c0( pos) =  f ./ (1 + q(4, pos));
        c0(~pos) = -f ./ (1 - q(4,~pos));
        
        % Create the vector.
        p(1,:)    = c0 .* q(1,:);
        p(2,:)    = c0 .* q(2,:);
        p(3,:)    = c0 .* q(3,:);
        
    % In code? Loop.
    else
 
        for k = 1:n
            if q(4,k) > 0
                p(:,k) =  f / (1 + q(4,k)) * q(1:3,k);
            else
                p(:,k) = -f / (1 - q(4,k)) * q(1:3,k);
            end
        end
        
    end
    
end % q2mrp
