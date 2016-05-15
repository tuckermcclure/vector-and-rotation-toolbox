function q = dcm2q(R)

% DCM2Q  Direction cosine matrix to quaternion
%
% Convert direction cosine matrices to equivalent rotation quaternions.
%
%   q = DCM2Q(R)
% 
% Inputs:
%
% R    Direction cosine matrices (3-by-3-by-n)
% seq  Sequence for Euler angles, specified as, e.g., [3 1 2] or 'zxy'
% 
% Outputs:
%
% q    Rotation quaternions (4-by-1)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Dims
    assert(size(R, 1) == 3 && size(R, 2) == 3, ...
           '%s: The DCMs must be 3-by-3-by-n.', mfilename);

    % Preallocate.
    n = size(R, 3);
    q = zeros(4, n, class(R));

    % MATLAB
    if isempty(coder.target)
        
        % Split the conversion so as to divide by the largest possible 
        % number.
        m1 = reshape( R(1,1,:) + R(2,2,:) + R(3,3,:) >= 0, 1, n);
        m2 = reshape( R(1,1,:) - R(2,2,:) - R(3,3,:) >= 0, 1, n);
        m3 = reshape(-R(1,1,:) + R(2,2,:) - R(3,3,:) >= 0, 1, n);
        m4 = ~m1 & ~m2 & ~m3;
        
        q(4,m1) = 0.5 * sqrt(1 + R(1,1,m1) + R(2,2,m1) + R(3,3,m1));
        alpha   = 0.25 ./ q(4,m1).';
        q(1,m1) = alpha .* squeeze(R(2,3,m1) - R(3,2,m1));
        q(2,m1) = alpha .* squeeze(R(3,1,m1) - R(1,3,m1));
        q(3,m1) = alpha .* squeeze(R(1,2,m1) - R(2,1,m1));

        q(1,m2) = 0.5 * sqrt(1 + R(1,1,m2) - R(2,2,m2) - R(3,3,m2));
        alpha   = 0.25 ./ q(1,m2).';
        q(2,m2) = alpha .* squeeze(R(1,2,m2) + R(2,1,m2));
        q(3,m2) = alpha .* squeeze(R(3,1,m2) + R(1,3,m2));
        q(4,m2) = alpha .* squeeze(R(2,3,m2) - R(3,2,m2));

        q(2,m3) = 0.5 * sqrt(1 - R(1,1,m3) + R(2,2,m3) - R(3,3,m3));
        alpha   = 0.25 ./ q(2,m3).';
        q(1,m3) = alpha .* squeeze(R(1,2,m3) + R(2,1,m3));
        q(3,m3) = alpha .* squeeze(R(3,2,m3) + R(2,3,m3));
        q(4,m3) = alpha .* squeeze(R(3,1,m3) - R(1,3,m3));
        
        q(3,m4) = 0.5 * sqrt(1 - R(1,1,m4) - R(2,2,m4) + R(3,3,m4));
        alpha   = 0.25 ./ q(3,m4).';
        q(1,m4) = alpha .* squeeze(R(1,3,m4) + R(3,1,m4));
        q(2,m4) = alpha .* squeeze(R(3,2,m4) + R(2,3,m4));
        q(4,m4) = alpha .* squeeze(R(1,2,m4) - R(2,1,m4));
        
    % codegen
    else

        % Split the conversion so as to divide by the largest possible 
        % number.
        for k = 1:n
            if R(1,1,k) + R(2,2,k) + R(3,3,k) >= 0
                q(4,k)  = 0.5 * sqrt(1 + R(1,1,k) + R(2,2,k) + R(3,3,k));
                alpha = 0.25/q(4,k);
                q(1,k)  = alpha * (R(2,3,k) - R(3,2,k));
                q(2,k)  = alpha * (R(3,1,k) - R(1,3,k));
                q(3,k)  = alpha * (R(1,2,k) - R(2,1,k));
            elseif R(1,1,k) - R(2,2,k) - R(3,3,k) >= 0
                q(1,k) = 0.5 * sqrt(1 + R(1,1,k) - R(2,2,k) - R(3,3,k));
                alpha = 0.25/q(1,k);
                q(2,k)  = alpha * (R(1,2,k) + R(2,1,k));
                q(3,k)  = alpha * (R(3,1,k) + R(1,3,k));
                q(4,k)  = alpha * (R(2,3,k) - R(3,2,k));
            elseif - R(1,1,k) + R(2,2,k) - R(3,3,k) >= 0
                q(2,k) = 0.5 * sqrt(1 - R(1,1,k) + R(2,2,k) - R(3,3,k));
                alpha = 0.25/q(2,k);
                q(1,k)  = alpha * (R(1,2,k) + R(2,1,k));
                q(3,k)  = alpha * (R(3,2,k) + R(2,3,k));
                q(4,k)  = alpha * (R(3,1,k) - R(1,3,k));
            else
                q(3,k)  = 0.5 * sqrt(1 - R(1,1,k) - R(2,2,k) + R(3,3,k));
                alpha = 0.25/q(3,k);
                q(1,k)  = alpha * (R(1,3,k) + R(3,1,k));
                q(2,k)  = alpha * (R(3,2,k) + R(2,3,k));
                q(4,k)  = alpha * (R(1,2,k) - R(2,1,k));
            end
        end
        
    end
    
end % dcm2q
