function p = aa2mrp(r, theta, f)

% aa2mrp

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the 
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    assert(all(size(f) == 1), ...
           '%s: The scaling factor must be a scalar.');

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)

        p = bsxfun(@times, tan(0.25 * theta), r);
        if f ~= 1
            p = f * p;
        end
            
    % Otherwise, write the loops.
    else

        n = size(r, 2);
        p = zeros(3, n, class(theta));
        for k = 1:n
            p(:,k) = tan(0.25 * theta(k)) * r(:,k);
        end
        if f ~= 1
            p = f * p;
        end

    end

end % aa2mrp
