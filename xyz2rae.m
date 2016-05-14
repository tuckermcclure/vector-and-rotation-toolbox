function rae = xyz2rae(xyz)

% xyz2rae
%
% Convert range-azimuth-elevation to Cartesian points with the same
% conventions as rae2xyz.
%
% See also: rae2xyz

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(xyz, 1) ~= 3 && size(xyz, 2) == 3, xyz = xyz.'; end;
    assert(size(xyz, 1) == 3, ...
           '%s: The input vectors must be 3-by-n.', mfilename);

    n = size(xyz, 2);
    rae      = zeros(3, n);
    for k = 1:n
        r = vmag(xyz(:,k));
        if r > 0
            rae(1,k) = r;
            rae(3,k) = asin(-xyz(3,k) ./ r);
            rae(2,k) = atan2(xyz(2,k), xyz(1,k));
        else
            rae(:,k) = 0;
        end
    end

end % xyz2rae
