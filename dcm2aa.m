function [theta, r] = dcm2aa(R)

% DCM2AA  Direction cosine matrix to angle-axis representation
%
% Convert a direction cosine matrix (or several) to the corresponding angle
% of rotation and corresponding axes of rotation.
% 
%   [theta, r] = DCM2AA(R)
%   theta      = DCM2AA(R)
%
% When the axes are not needed, this output can be skipped, saving some
% computation time.
%
% Inputs:
%
% R  Direction cosine matrices (3-by-3-by-n)
% 
% Outputs:
%
% theta  Angle(s) of rotation (radians, 1-by-n)
% r      Unit axes of right-handed rotation (3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Dims
    assert(size(R, 1) == 3 && size(R, 2) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
       
    % Angle of rotation
    n        = size(R, 3);
    theta    = zeros(1, n, class(R));
    theta(:) = acos(0.5*(R(1,1,:) + R(2,2,:) + R(3,3,:) - 1));
    
    % Axes of rotation
    if nargout >= 2
        
        % Preallocate.
        r = zeros(3, n, class(R));
        
        % If in MATLAB...
        if isempty(coder.target)
            
            theta_is_zero = theta == 0;
            r(1,     theta_is_zero) = 1;
            r(2:end, theta_is_zero) = 0;
            
            theta_is_pi       = theta == pi;
            use_column_1      =   theta_is_pi ...
                                & reshape(R(1,1,:) >= R(3,3,:), [1 n]) ...
                                & reshape(R(1,1,:) >= R(2,2,:), [1 n]);
            r(1,use_column_1) = R(1,1,use_column_1) + 1;
            r(2,use_column_1) = R(2,1,use_column_1);
            r(3,use_column_1) = R(3,1,use_column_1);
            
            use_column_2      =   theta_is_pi ...
                                & reshape(R(2,2,:) >= R(1,1,:), [1 n]) ...
                                & reshape(R(2,2,:) >= R(3,3,:), [1 n]);
            r(1,use_column_2) = R(1,2,use_column_2);
            r(2,use_column_2) = R(2,2,use_column_2) + 1;
            r(3,use_column_2) = R(3,2,use_column_2);
            
            use_column_3 = theta_is_pi & ~(use_column_1 | use_column_2);
            r(1,use_column_3) = R(1,3,use_column_3);
            r(2,use_column_3) = R(2,3,use_column_3);
            r(3,use_column_3) = R(3,3,use_column_3) + 1;
            
            r(:,theta_is_pi)   = normalize(r(:,theta_is_pi));
            
            normal      = ~theta_is_zero & ~theta_is_pi;
            d           = 1./(2 * sin(theta(normal)));
            s           = sum(normal);
            r(1,normal) = d .* reshape(R(2,3,normal) - R(3,2,normal), [1 s]);
            r(2,normal) = d .* reshape(R(3,1,normal) - R(1,3,normal), [1 s]);
            r(3,normal) = d .* reshape(R(1,2,normal) - R(2,1,normal), [1 s]);
            
        % Otherwise, codegen...
        else
            
            for k = 1:n
                
                % If there's no rotation, then the axis is arbitrary.
                if theta(k) == 0
                    
                    r(1,k) = 1; % (The rest are already zeros.)
                    
                % If the rotation is half a circle, then the rotation axis
                % will be proportional to a column of eye(3) + R. Choose
                % the largest column and normalize for the axis.
                elseif theta(k) == pi
                    
                    if R(1,1,k) >= R(3,3,k)
                        if R(1,1,k) >= R(2,2,k)
                            r(1,k) = R(1,1,k) + 1;
                            r(2,k) = R(2,1,k);
                            r(3,k) = R(3,1,k);
                        else
                            r(1,k) = R(1,2,k);
                            r(2,k) = R(2,2,k) + 1;
                            r(3,k) = R(3,2,k);
                        end
                    else
                        r(1,k) = R(1,3,k);
                        r(2,k) = R(2,3,k);
                        r(3,k) = R(3,3,k) + 1;
                    end
                    r(:,k) = normalize(r(:,k));
                    
                % Otherwise, we build the rotation axis from the
                % off-diagonal components of R.
                else
                    
                    d      = 1/(2 * sin(theta(k)));
                    r(1,k) = d * (R(2,3,k) - R(3,2,k));
                    r(2,k) = d * (R(3,1,k) - R(1,3,k));
                    r(3,k) = d * (R(1,2,k) - R(2,1,k));
                    
                end
                
            end
            
        end
        
    end

end % dcm2aa
