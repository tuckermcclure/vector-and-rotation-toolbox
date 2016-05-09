function R = aa2dcm(r, theta)

% aa2dcm
%
% Convert an axis and angle or rotation to a direction cosine matrix. This
% is vectorized to take multiple axes (3-by-n) and corresponding angles
% (1-by-n).
%
%   R = eye(3)*cos(theta) + (1-cos(theta))*(r*r') - sin(theta)*crs(r);
% 
% Inputs:
%
% r      Unit axis of rotation (3-by-n)
% theta  Angle of rotation of frame B wrt A (1-by-n)
%
% Outputs:
%
% R      Direction cosine matrix representing B wrt A (v_B = R * v_A)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    assert(nargin == 2, ...
           '%s: Two inputs are required.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    
    % Pre-allocate the DCMs.
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
