function R = grp2dcm(p, a, f)

    if nargin < 2 || isempty(a), a = 1; end;
    if nargin < 3 || isempty(f), f = 4; end;

    if a == 1
        c   = crs3(p/f);
        pm2 = sum(p.^2, 1);
        a   = (1 + pm2).^2;
        R   = eye(3) + (4*(1 - pm2)/a) * c + (8./a) * c * c;
    else
        R = q2dcm(grp2q(p, a, f));
    end
    
end
