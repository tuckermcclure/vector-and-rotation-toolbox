function p = aa2mrp(theta, r, f)

% AA2MRP  Angle-axis to modified Rodrigues parameters
%
% Convert an angle and axis of rotation to a modified Rodrigues parameters.
% This is vectorized to take multiple angles (1-by-n) and corresponding 
% axes (3-by-n). An optional scaling parameter is allowed; by using a
% scaling parameter of 4, the MRPs are approximately equal to the rotation 
% vector (r * theta) for small rotations. The default scaling is 1, 
% resulting in the traditional MRPs.
%
%   p = AA2MRP(theta, r);
%   p = AA2MRP(theta, r, f);
%
% For a single angle and axis, this is equivalent to:
%
%   p = f * tan(theta/4) * r;
%
% See the readme for more on MRPs.
% 
% Inputs:
%
% r      Unit axis (or axes) of right-handed rotation (3-by-n)
% theta  Angle(s) of rotation of frame B wrt A about r (1-by-n)
%
% Outputs:
%
% p      MRPs representing the rotation of frame B wrt frame A (3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the 
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(theta, 1) == 1, ...
           '%s: The angles must be 1-by-n.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)

        p = bsxfun(@times, f * tan(0.25 * theta), r);
            
    % Otherwise, write the loops.
    else

        n = size(r, 2);
        p = zeros(3, n, class(theta));
        for k = 1:n
            p(:,k) = tan(0.25 * theta(k)) * r(:,k);
        end
        if f ~= 1
            p = f * p;
        end

    end

end % aa2mrp
