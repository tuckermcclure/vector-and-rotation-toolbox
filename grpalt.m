function p = grpalt(p, a, f)

    if a == 0
        % Nothing to do.
    elseif a == 1
        pm2 = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
        nz  = pm2 > 0;
        s   = (-f*f)./(pm2(nz));
        p(1, nz) = s * p(1, nz);
        p(2, nz) = s * p(2, nz);
        p(3, nz) = s * p(3, nz);
    else
    end

end
