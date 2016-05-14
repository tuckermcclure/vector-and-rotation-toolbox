function [theta, r] = mrp2aa(p, f)

% mrp2aa

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
