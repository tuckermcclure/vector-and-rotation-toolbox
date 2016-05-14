function v = qrot(q, v)

% Rotate a vector in frame A, v_A, to frame B given the quaternion
% representing B wrt A, q_BA.
%
%   v_B = qrot(q_BA, v_A);
%

% Copyright 2016 An Uncommon Lab

%#codegen

    % Faster in MATLAB:
    if isempty(coder.target)

        % v_B = qcomp(qcomp(q_BA, [v_B; 0]), qinv(q_BA));
        c = [ q(4,:).*v(1,:) + q(3,:).*v(2,:) - q(2,:).*v(3,:); ...
             -q(3,:).*v(1,:) + q(4,:).*v(2,:) + q(1,:).*v(3,:); ...
              q(2,:).*v(1,:) - q(1,:).*v(2,:) + q(4,:).*v(3,:); ...
             -q(1,:).*v(1,:) - q(2,:).*v(2,:) - q(3,:).*v(3,:)];
        v = [-c(4,:).*q(1,:) - c(3,:).*q(2,:) + c(2,:).*q(3,:) + c(1,:).*q(4,:); ...
              c(3,:).*q(1,:) - c(4,:).*q(2,:) - c(1,:).*q(3,:) + c(2,:).*q(4,:); ...
             -c(2,:).*q(1,:) + c(1,:).*q(2,:) - c(4,:).*q(3,:) + c(3,:).*q(4,:)];
         
    % Better for codegen:
    else
        
        for k = 1:size(q, 2)
            c = [ q(4,k).*v(1,k) + q(3,k).*v(2,k) - q(2,k).*v(3,k); ...
                 -q(3,k).*v(1,k) + q(4,k).*v(2,k) + q(1,k).*v(3,k); ...
                  q(2,k).*v(1,k) - q(1,k).*v(2,k) + q(4,k).*v(3,k); ...
                 -q(1,k).*v(1,k) - q(2,k).*v(2,k) - q(3,k).*v(3,k)];
            v(:,k) = [-c(4).*q(1,k) - c(3).*q(2,k) + c(2).*q(3,k) + c(1).*q(4,k); ...
                       c(3).*q(1,k) - c(4).*q(2,k) - c(1).*q(3,k) + c(2).*q(4,k); ...
                      -c(2).*q(1,k) + c(1).*q(2,k) - c(4).*q(3,k) + c(3).*q(4,k)];
        end
        
    end
    
end % qrot
