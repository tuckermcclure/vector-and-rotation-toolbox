function q = dcm2q(M)

% dcm2q
%
% Convert a direction cosine matrix to a unit quaternion representing the
% same rotation.
%
% Shuster, Malcolm D. "A Survey of Attitude Representations." _The Journal
% of Astronautical Sciences. Vol. 41. No. 4. October-December 1993.
% 439-517. http://malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Split the conversion so as to divide by the largest possible number.
    q = zeros(4, 1);
    if M(1,1) + M(2,2) + M(3,3) >= 0
        q(1)  = 0.5 * sqrt(1 + M(1,1) + M(2,2) + M(3,3));
        alpha = 0.25/q(1);
        q(2)  = alpha * (M(2,3) - M(3,2));
        q(3)  = alpha * (M(3,1) - M(1,3));
        q(4)  = alpha * (M(1,2) - M(2,1));
    elseif M(1,1) - M(2,2) - M(3,3) >= 0
        q(2) = 0.5 * sqrt(1 + M(1,1) - M(2,2) - M(3,3));
        alpha = 0.25/q(2);
        q(3)  = alpha * (M(1,2) + M(2,1));
        q(4)  = alpha * (M(3,1) + M(1,3));
        q(1)  = alpha * (M(2,3) - M(3,2));
    elseif - M(1,1) + M(2,2) - M(3,3) >= 0
        q(3) = 0.5 * sqrt(1 - M(1,1) + M(2,2) - M(3,3));
        alpha = 0.25/q(3);
        q(2)  = alpha * (M(1,2) + M(2,1));
        q(4)  = alpha * (M(3,2) + M(2,3));
        q(1)  = alpha * (M(3,1) - M(1,3));
    elseif - M(1,1) - M(2,2) + M(3,3) >= 0
        q(4)  = 0.5 * sqrt(1 - M(1,1) - M(2,2) + M(3,3));
        alpha = 0.25/q(4);
        q(2)  = alpha * (M(1,3) + M(3,1));
        q(3)  = alpha * (M(3,2) + M(2,3));
        q(1)  = alpha * (M(1,2) - M(2,1));
    else
        error('Invalid direction cosine matrix.');
    end

end % dcm2q
