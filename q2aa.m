function [theta, a] = q2aa(q, tol)

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
% a      Axis of rotation

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Set a default tolerance.
    if nargin < 2, tol = eps; end;

    % Make the q0 components positive.
    q = q0pos(q);
    
    % Find the half angle, ensuring that q0 is within [-1, 1].
    half_theta = acos(max(min(q(1,:), 1), -1));
    
    % If we also need the axis...
    if nargout > 1

        % Create space for the axes, defaulting to [1; 0; 0] for each.
        a = [ones(1, size(q, 2)); zeros(2, size(q, 2))];

        % Get the denominator and magnitude of the denominator.
        sin_half_theta = sin(half_theta);
        abs_den        = abs(sin_half_theta);

        % It's only safe to divide normally where the denominator is
        % greater than machine precision.
        safe_indices = abs_den >= 0.5 * tol;
        if any(safe_indices)
            a(:,safe_indices) = bsxfun(@rdivide, ...
                                       q(2:4, safe_indices), ...
                                       sin_half_theta(safe_indices));
        end
        
    end

    % Get the full angle for output.
    theta = 2 * half_theta;
    
end % q2aa
