function R = mrp2dcm(p, f)

% mrp2dcm

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 2 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 1, ...
           '%s: At least one input is required.', mfilename);
    assert(size(p, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

    % Dims
    n = size(p, 2);
    R = zeros(3, 3, n, class(p));

    % Make the denominator term.
    f2  = f*f;
    pm2 = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
    s1  = f2 + pm2;
    s1  = (f2 * 8) ./ (s1.*s1);

    % Make the diagonals.
    R(1,1,:) = 1 - s1 .* (p(3,:).*p(3,:) + p(2,:).*p(2,:));
    R(2,2,:) = 1 - s1 .* (p(3,:).*p(3,:) + p(1,:).*p(1,:));
    R(3,3,:) = 1 - s1 .* (p(1,:).*p(1,:) + p(2,:).*p(2,:));

    % Make the remaining terms.
    s2 = (0.5/f) * (f2 - pm2) .* s1;
    R(1,2,:) =  s2 .* p(3,:) + s1 .* p(1,:) .* p(2,:);
    R(1,3,:) = -s2 .* p(2,:) + s1 .* p(1,:) .* p(3,:);
    R(2,3,:) =  s2 .* p(1,:) + s1 .* p(2,:) .* p(3,:);
    R(2,1,:) = -s2 .* p(3,:) + s1 .* p(2,:) .* p(1,:);
    R(3,1,:) =  s2 .* p(2,:) + s1 .* p(3,:) .* p(1,:);
    R(3,2,:) = -s2 .* p(1,:) + s1 .* p(3,:) .* p(2,:);

end % mrp2dcm
