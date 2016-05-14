function p = mrpalt(p, f)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 2 || isempty(f), f = 1; end;

    % TODO: codegen
    pm2      = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
    nz       = pm2 > 0;
    c0       = (-f*f)./(pm2(nz));
    p(1, nz) = c0 .* p(1, nz);
    p(2, nz) = c0 .* p(2, nz);
    p(3, nz) = c0 .* p(3, nz);
        
end % mrpalt
