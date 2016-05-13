function [theta, r] = grp2aa(p, a, f, s)

% grp2aa

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults for "near" rotation, and so that for small angles, the
    % GRPs will approach the rotation vector.
    if nargin < 2 || isempty(a), a = 1;                   end;
    if nargin < 3 || isempty(f), f = 2*(a+1);             end;
    if nargin < 4 || isempty(s), s = false(1, size(p,2)); end;
    
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
%         theta = -a * pm + sqrt(1 + (1-a*a) * pm);
%         theta = theta ./ (1 + pm);
%         theta(s) = -theta(s);
        c1        = sqrt(1 + (1-a*a) * pm);
        c2        = 1 + pm;
        theta     = zeros(1, size(p, 2), class(p));
        theta(s)  = (-a * pm(s)  - c1(s))  ./ c2(s);
        theta(~s) = (-a * pm(~s) + c1(~s)) ./ c2(~s);
        theta     = 2 * acos(theta);
    end

end % grp2aa
