function q = mrp2q(p, f)

% mrp2q

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;
    
    n       = size(p, 2);
    q       = zeros(4, n, class(p));
    f2      = f * f;
    pm2     = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
    c0      = 1 ./ (f2 + pm2);
    q(4,:)  = c0 .* (f2 - pm2);
    c0      = (2*f) * c0;
    q(1,:)  = c0 .* p(1,:);
    q(2,:)  = c0 .* p(2,:);
    q(3,:)  = c0 .* p(3,:);
    
end % mrp2q
