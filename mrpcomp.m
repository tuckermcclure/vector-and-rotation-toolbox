function p = mrpcomp(p2, p1, f)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(p2, 1) == 3 && size(p1, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(size(p2, 2) == size(p1, 2), ...
           '%s: The number of MRPs in each input must match.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

    % If in MATLAB, vectorize.
    if isempty(coder.target)
        
        f2 = f * f;
        p1m2 = p1(1,:).*p1(1,:) + p1(2,:).*p1(2,:) + p1(3,:).*p1(3,:);
        p2m2 = p2(1,:).*p2(1,:) + p2(2,:).*p2(2,:) + p2(3,:).*p2(3,:);
        d    = p1(1,:).*p2(1,:) + p1(2,:).*p2(2,:) + p1(3,:).*p2(3,:);
        c0   = (f2 - p1m2);
        c1   = (f2 - p2m2);
        c2   = 1./(f2 + (1/f2) .* p1m2 .* p2m2 - 2 * d);
        p    = (-2*f) * cross3(p2, p1);
        p(1,:) = (p(1,:) + c0 .* p2(1,:) + c1 .* p1(1,:)) .* c2;
        p(2,:) = (p(2,:) + c0 .* p2(2,:) + c1 .* p1(2,:)) .* c2;
        p(3,:) = (p(3,:) + c0 .* p2(3,:) + c1 .* p1(3,:)) .* c2;
        
    % Otherwise, make good C.
    else
        
        n  = size(p1, 2);
        p  = zeros(3, n, class(p1));
        f2 = f * f;
        for k = 1:n
            p1m2 = p1(1,k).*p1(1,k) + p1(2,k).*p1(2,k) + p1(3,k).*p1(3,k);
            p2m2 = p2(1,k).*p2(1,k) + p2(2,k).*p2(2,k) + p2(3,k).*p2(3,k);
            d    = p1(1,k).*p2(1,k) + p1(2,k).*p2(2,k) + p1(3,k).*p2(3,k);
            p(:,k) =   (f2 - p1m2) * p2(:,k) ...
                     + (f2 - p2m2) * p1(:,k) ...
                     - 2*f * cross3(p2(:,k), p1(:,k));
            p(:,k) = (1/(f2 + p1m2 * p2m2 / f2 - 2 * d)) * p(:,k);
        end
        
    end
    
end % mrpcomp
