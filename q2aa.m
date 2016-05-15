function [theta, r] = q2aa(q)

% Q2AA  Rotation quaternion to angle-axis representation
%
% Converts the rotation quaternion into angle-axis representation. When the
% angle is zero, the arbitrary axis will be [1; 0; 0].
%
%   theta      = Q2AA(q)
%   [theta, r] = Q2AA(q)
%
% When the axes aren't necessary, that output can be skipped to save some
% computation time.
% 
% Inputs:
%
% q      Rotation quaternion(s) (4-by-n)
% 
% Outputs:
%
% theta  Angle of rotation (radians, 1-by-n)
% r      Axis of rotation

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    
    % If in MATLAB, vectorize.
    if isempty(coder.target)

        % Find the positive half angle.
        ind     = q(4,:) < 0;
        ht      = q(4,:);
        ht(ind) = -ht(ind);
        ht      = acos(min(ht, 1));

        % Reverse the axes when the sign of the scalar component was
        % negative. (We've already taken care of the angle.)
        r = q(1:3,:);
        r(:,ind) = -r(:,ind);

        % If we also need the axis...
        if nargout > 1

            % Get the denominator.
            sht = sin(ht);

            % Divide (where possible).
            ind = sht > 0; % Definitely >= 0 since ht is positive.
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
        
        % Preallocate.
        n     = size(q, 2);
        theta = zeros(1, n, class(q));
        
        % If we need both outputs...
        if nargout >= 2
            
            r     = zeros(3, n, class(q));
            for k = 1:n
                ht     = q(4,k);
                r(:,k) = q(1:3,k);
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
                if q(4,k) < 0
                    ht = -q(4,k);
                else
                    ht = q(4,k);
                end
                if ht > 1
                    ht = 1;
                end
                theta(k) = 2 * acos(ht);
            end
            
        end
        
    end
    
end % q2aa
