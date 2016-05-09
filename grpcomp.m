function p = grpcomp(p2, p1, a, f)

% Copyright 2016 An Uncommon Lab

%#codegen

    if nargin < 3 || isempty(a), a = 1; end;
    if nargin < 4 || isempty(f), f = 4; end;

    if a == 1
        
        if f ~= 1
            p1 = p1./f;
            p2 = p2./f;
        end
        
        p1m2 = sum(p1.^2, 1);
        p2m2 = sum(p2.^2, 1);
        p =   (1 - p1m2) * p2 ...
            + (1 - p2m2) * p1 ...
            - 2 * cross3(p2, p1);
        p = (1./(1 + p1m2 .* p2m2 - 2 * p2.' * p1)) * p;
        
        % TODO: Not vectorized.
        
    % Otherwise, use quaternions.
    else
        q1 = grp2q(p1, a, f);
        q2 = grp2q(p2, a, f);
        p  = q2grp(qcomp(q2, q1, a, f), a, f);
    end

end % grpcomp
