function q = dcm2q(R)

% dcm2q
%
% Convert a direction cosine matrix to a unit quaternion representing the
% same rotation.
%
% Shuster, Malcolm D. "A Survey of Attitude Representations." _The Journal
% of Astronautical Sciences. Vol. 41. No. 4. October-December 1993.
% 439-517. http://malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf

% Copyright 2016 An Uncommon Lab

%#codegen

    % Dims
    n = size(R, 3);
    assert(size(R, 1) == 3 && size(R, 2) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);

    % Preallocate.
    q = zeros(4, n, class(R));
    
    % Split the conversion so as to divide by the largest possible number.
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
        elseif - R(1,1,k) - R(2,2,k) + R(3,3,k) >= 0
            q(3,k)  = 0.5 * sqrt(1 - R(1,1,k) - R(2,2,k) + R(3,3,k));
            alpha = 0.25/q(3,k);
            q(1,k)  = alpha * (R(1,3,k) + R(3,1,k));
            q(2,k)  = alpha * (R(3,2,k) + R(2,3,k));
            q(4,k)  = alpha * (R(1,2,k) - R(2,1,k));
        else
            error('%s: Invalid direction cosine matrix.', mfilename);
        end
    end
    
end % dcm2q
