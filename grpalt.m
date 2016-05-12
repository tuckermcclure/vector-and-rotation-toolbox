function p = grpalt(p, a, f)

    if a == 0
        % Nothing to do.
    elseif a == 1
        pm2 = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
        nz  = pm2 > 0;
        c0   = (-f*f)./(pm2(nz));
        p(1, nz) = c0 * p(1, nz);
        p(2, nz) = c0 * p(2, nz);
        p(3, nz) = c0 * p(3, nz);
    else
        pm2 = (p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:)) / (f^2);
        c0  = sqrt(1 + pm2 * (1 - a*a));
        nz  = c0 - a - 2*a*pm2 ~= 0;
        c0(nz) = (a + c0(nz)) ./ (c0(nz) - a - 2*a*pm2(nz));
        p(1, nz) = c0(nz) * p(1, nz);
        p(2, nz) = c0(nz) * p(2, nz);
        p(3, nz) = c0(nz) * p(3, nz);
        p(:, ~nz) = 0;
    end

end
