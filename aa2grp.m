function p = aa2grp(ax, theta, a, f)

    % Set defaults so that small p correspond to rotation vectors.
    if nargin < 3 || isempty(a), a = 1; end;
    if nargin < 4 || isempty(f), f = 4; end;

    % Use a special form if possible.
    if a == 1
        
        p = bsxfun(@times, tan(0.25 * theta), ax);
        if f ~= 1
            p = f * p;
        end
        
    % Otherwise, go through the quaternion (still plenty fast).
    else
        p = q2grp(aa2q(ax, theta), a, f);
    end

end % aa2grp
