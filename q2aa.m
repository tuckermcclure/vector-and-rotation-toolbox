function [theta, r] = q2aa(q)

% q2aa
%
% Quaternion to axis-angle, using q(1,:) as the scalars and q(2:4,:)
% as the vectors. Note that when the angle is zero, the axis is undefined.
% This function will return [1; 0; 0] for all rotations smaller than tol so
% that the output axis always has unit norm. It also protects against 
% q(1,:) being slightly less than -1 or more than 1, which can happen in 
% numerical integration of the quaternion. It's vectorized to accept a 
% matrix of quaternions with dimensions 4-by-n. This function does *not*
% ensure the unit norm of the quaternion. Use the normalize function for
% that first if required.
%
% Example:
% 
% >> q = [0 0 1 0].'; % Rotation of pi about y
% >> [theta, a] = q2aa(q)
% theta =
%     3.1416
% a =
%      0
%      1
%      0
%
% Inputs:
%
% q      Quaternion (scalar part last)
% tol    Divide-by-zero tolerance; when the scalar part is less than this 
%        number (no rotation), the axis will be simply [1; 0; 0] (optional)
% 
% Outputs:
%
% theta  Angle of rotation [rad]
% r      Axis of rotation

% Copyright 2016 An Uncommon Lab

%#codegen

%     % Set a default tolerance.
%     if nargin < 2, tol = eps; end;
    
    % If in MATLAB, vectorize.
    if isempty(coder.target)

        % Find the positive half angle.
        ind     = q(1,:) < 0;
        ht      = q(1,:);
        ht(ind) = -ht(ind);
        ht      = acos(min(ht, 1));

        % Reverse the axes when the sign of the scalar component was
        % negative. (We've already taken care of the angle.)
        r = q(2:4,:);
        r(:,ind) = -r(:,ind);

        % If we also need the axis...
        if nargout > 1

            % Get the denominator.
            sht = sin(ht);

            % Divide (where possible).
            ind = sht >= 0; % Definitely >= 0 since ht is positive.
            if any(ind)
                r(:,ind) = bsxfun(@rdivide, r(:,ind), sht(ind));
            end

            % Where there was no rotation, give [1 0 0].
            r(1,~ind) = 1;
            r(2,~ind) = 0;
            r(3,~ind) = 0;

        end

        % Get the full angle for output.
        theta = 2 * ht;
       
    % Otherwise, loop.
    else
        
        % Pre-allocate.
        n     = size(q, 2);
        theta = zeros(1, n, class(q));
        
        % If we need both outputs...
        if nargout >= 2
            
            r     = zeros(3, n, class(q));
            for k = 1:n
                ht     = q(1,k);
                r(:,k) = q(2:4,k);
                if ht < 0
                    ht = -ht;
                    r(:,k) = -r(:,k);
                end
                if ht > 1
                    ht = 1;
                end
                ht  = acos(ht);
                sht = sin(ht);
                if sht > 0
                    r(:,k) = r(:,k) * (1./sht);
                else
                    r(1,k) = 1; r(2,k) = 0; r(3,k) = 0;
                end
                theta(k) = 2 * ht;
            end
            
        % Otherwise, there's an easier way.
        else
            
            for k = 1:n
                if q(1,k) < 0
                    ht = -q(1,k);
                else
                    ht = q(1,k);
                end
                if ht > 1
                    ht = 1;
                end
                theta(k) = 2 * acos(ht);
            end
            
        end
        
    end
    
end % q2aa
