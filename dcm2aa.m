function [theta, r] = dcm2aa(R)

% [theta, r] = dcm2aa(R)
%
% Kuipers, Jack B., _Quaternions and Rotation Sequences: A Primer with
% Applications to Orbits, Aerospace, and Virtual Reality_. Princeton:
% Princeton University Press. 1999. Book. Page 66.

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
        
%         % If in MATLAB...
%         if isempty(coder.target)
% 
%             % TODO: Vectorize
%             if theta == 0
%                 r = [1; 0; 0];
%             elseif theta == pi
%                 if R(1,1) > R(2,2) && R(1,1) > R(3,3)
%                     r = [R(1,1) + 1; R(2,1); R(3,1)];
%                 elseif R(2,2) > R(3,3)
%                     r = [R(1,2); R(2,2) + 1; R(3,2)];
%                 else
%                     r = [R(1,3); R(2,3); R(3,3) + 1];
%                 end
%                 r = normalize(r);
%             else
%                 r        = zeros(3, n, class(R));
%                 r(1,:)   = R(2,3,:) - R(3,2,:);
%                 r(2,:)   = R(3,1,:) - R(1,3,:);
%                 r(3,:)   = R(1,2,:) - R(2,1,:);
%                 r        = normalize(r);
%             end
%             
%         % Otherwise, codegen...
%         else
            
            r = zeros(3, n, class(R));
            for k = 1:n
                
                % If there's no rotation, then the axis is arbitrary.
                if theta(k) == 0
                    
                    r(1,k) = 1;
                    
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
            
%         end
        
    end

end % dcm2aa
