function [p, s] = grpalt(p, a, f, s)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults for "near" rotation, and so that for small angles, the
    % GRPs will approach the rotation vector.
    if nargin < 2 || isempty(a), a = 1;                   end;
    if nargin < 3 || isempty(f), f = 2*(a+1);             end;
    if nargin < 4 || isempty(s), s = false(1, size(p,2)); end;

    % TODO: codegen
    
    % Gibbs vector
    if a == 0
        
        % Nothing to do. The Gibbs vector is unique.
        
    % MRPs
    elseif a == 1
        
        pm2      = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
        nz       = pm2 > 0;
        c0       = (-f*f)./(pm2(nz));
        p(1, nz) = c0 .* p(1, nz);
        p(2, nz) = c0 .* p(2, nz);
        p(3, nz) = c0 .* p(3, nz);
        s        = ~s;
        % For ~nz, the columns must already contain zeros.
        
    % General case
    else
        
        pm2 = (p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:));
        c0  = sqrt(1 + pm2 * ((1 - a*a)/(f*f)));
        pm2 = (2*a/(f*f)) * pm2;
        
        % Handle the "near" rotations first. These require checking for the
        % singularity.
        nz        = ~s & (c0 - a - pm2 ~= 0);
        ind       = ~s & nz;
        if any(ind)
            c0(ind)    = (a + c0(ind)) ./ (c0(ind) - a - pm2(ind));
            p(1,  ind) = c0(ind) .* p(1, ind);
            p(2,  ind) = c0(ind) .* p(2, ind);
            p(3,  ind) = c0(ind) .* p(3, ind);
        end
        p(:, ~s & ~nz) = 0;

        % Handle the "far" rotations next. These *can't* divide by 0.
        if any(s)
            c0(s)      = (-a + c0(s)) ./ (c0(s) + a + pm2(s));
            p(1, s) = c0(s) .* p(1, s);
            p(2, s) = c0(s) .* p(2, s);
            p(3, s) = c0(s) .* p(3, s);
        end
        
        % The sets are now swapped.
        s = ~s;
        
    end

end % grpalt
