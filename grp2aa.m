function [theta, r] = grp2aa(p, a, f)

    if nargin < 2 || isempty(a), a = 1; end;
    if nargin < 3 || isempty(f), f = 4; end;
    
    if a == 1
        p     = p ./ f;
        pm    = vmag(p);
        theta = 4 * atan(pm);
        r     = bsxfun(@rdivide, p, pm);
        % TODO: Does this work for negative stuff?
    else
        [theta, r] = q2aa(grp2q(p, a, f));
    end

end % grp2aa
