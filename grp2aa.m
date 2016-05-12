function [theta, r] = grp2aa(p, a, f)

% grp2aa

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that p approximates the rotation vector for small
    % angles.
    if nargin < 2 || isempty(a), a = 1;       end;
    if nargin < 3 || isempty(f), f = 2*(a+1); end;
    
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
    
    % The angle is easy when a == 1. There's a bit more footwork 
    % when a ~= 1.
    if a == 1
        theta = 4 * atan(pm);
    else        
        pm = pm .* pm;
        theta = -a * pm + sqrt(1 + (1-a*a) * pm);
        theta = theta ./ (1 + pm);
        theta = 2 * acos(theta);
    end

end % grp2aa
