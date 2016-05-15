function R = aa2dcm(theta, r)

% aa2dcm  angle-axis to direction cosine matrix
%
% Convert an angle and axis of rotation to a direction cosine matrix. This
% is vectorized to take multiple angles (1-by-n) and corresponding
% axes (3-by-n).
%
%   R = aa2dcm(theta, r);
%
% For a single angle and axis, this is equivalent to:
%
%   R = cos(theta)*eye(3) + (1-cos(theta))*(r*r') - sin(theta)*crs3(r);
% 
% Inputs:
%
% r      Unit axis (or axes) of right-handed rotation (3-by-n)
% theta  Angle(s) of rotation of frame B wrt A about r (radians, 1-by-n)
%
% Outputs:
%
% R      Direction cosine matrix representing B wrt A (3-by-3-by-n)
%
% Example:
%
% v_A = [1; 0; 0]; % A vector as seen in the A frame
% R_BA = aa2dcm([0; 1; 0], pi/4); % Rotation of B wrt A (45 deg. about y)
% v_B = R_BA * v_A % The same vector as seen in the B frame

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    assert(nargin == 2, ...
           '%s: Two inputs are required.', mfilename);
    assert(size(theta, 1) == 1, ...
           '%s: The angles must be 1-by-n.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    
    % Preallocate the DCMs.
    R = zeros(3, 3, length(theta), class(theta));

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)
        
        c        = cos(theta);
        s        = 1 - c;
        sr       = bsxfun(@times, s, r);
        R        = zeros(3, 3, length(theta));
        R(1,1,:) = sr(1,:) .* r(1,:) + c;
        R(1,2,:) = sr(1,:) .* r(2,:);
        R(1,3,:) = sr(1,:) .* r(3,:);
        R(2,1,:) = R(1,2,:);
        R(2,2,:) = sr(2,:) .* r(2,:) + c;
        R(2,3,:) = sr(2,:) .* r(3,:);
        R(3,1,:) = R(1,3,:);
        R(3,2,:) = R(2,3,:);
        R(3,3,:) = sr(3,:) .* r(3,:) + c;
        s        = sin(theta);
        sr       = bsxfun(@times, s, r);
        R        = R - crs3(sr);
    
    % Otherwise, when running in some type of embedded code, use efficient
    % (non-vectorized) code.
    else
        
        % For the unvectorized code, just replace ',:' with ',k' for the
        % most part.
        for k = 1:length(theta)
            c        = cos(theta(k));
            s        = 1 - c;
            sr       = s * r(:,k);
            R(1,1,k) = sr(1) .* r(1,k) + c;
            R(1,2,k) = sr(1) .* r(2,k);
            R(1,3,k) = sr(1) .* r(3,k);
            R(2,1,k) = R(1,2,k);
            R(2,2,k) = sr(2) .* r(2,k) + c;
            R(2,3,k) = sr(2) .* r(3,k);
            R(3,1,k) = R(1,3,k);
            R(3,2,k) = R(2,3,k);
            R(3,3,k) = sr(3) .* r(3,k) + c;
            s        = sin(theta(k));
            sr       = s * r(:,k);
            R(1,2,k) = R(1,2,k) + sr(3);
            R(1,3,k) = R(1,3,k) - sr(2);
            R(2,3,k) = R(2,3,k) + sr(1);
            R(2,1,k) = R(2,1,k) - sr(3);
            R(3,1,k) = R(3,1,k) + sr(2);
            R(3,2,k) = R(3,2,k) - sr(1);
        end
        
    end
    
    
end % aa2dcm
