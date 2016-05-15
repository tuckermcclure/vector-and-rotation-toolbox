function [theta, r] = mrp2aa(p, f)

% MRP2AA  Modified Rodrigues parameters to angle-axis representation
%
% Convert modified Rodrigues parameters to corresponding angle of rotation
% and right-handed rotation axis.
%
%   [theta, r] = MRP2AA(p)    % for traditional MRPs
%   [theta, r] = MRP2AA(p, f) % for scaled MRPs
%
% Inputs:
%
% p  Modified Rodrigues parameters (3-by-n)
% f  Optional scaling parameter (default 1)
%
% Outputs:
% 
% theta  Rotation angle (radians, 1-by-n)
% r      Unit rotation axis (3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 2 || isempty(f), f = 1; end;
    
    % Check dimensions.
    assert(nargin >= 1, ...
           '%s: At least one input is required.', mfilename);
    assert(size(p, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);
    
    % Get the magnitude and rotation axes.
    if nargout >= 2
        [r, pm] = normalize(p);
    else
        pm = vmag(p);
    end
    
    % Remove the scaling factor.
    if f ~= 1
        pm = pm ./ f;
    end
    
    theta = 4 * atan(pm);

end % mrp2aa
