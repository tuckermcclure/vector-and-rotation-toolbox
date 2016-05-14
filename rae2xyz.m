function xyz = rae2xyz(rae)

% rae2xyz
% 
% Convert from range-azimuth-elevation to Cartesian points. The elevation
% angle measures the rotation from the x-y plane to the point and the
% azimuth angle measures the rotation from x about +z. Range measures the
% distance to the point. In other words, this function first rotates a
% vector at [r; 0; 0] about +y by the elevation angle and then about +z by
% the azimuth angle.
%
% See also: xyz2rae

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(rae, 1) ~= 3 && size(rae, 2) == 3, rae = rae.'; end;
    assert(size(rae, 1) == 3, ...
           '%s: The RAE inputs must be 3-by-n.', mfilename);

    % Transpose if necessary.
    if size(rae, 1) ~= 3 && size(rae, 2) == 3
        rae = rae.';
    end

    xyz      = zeros(3, size(rae, 2));
    xyz(3,:) = -rae(1,:) .* sin(rae(3,:)); % Start with z.
    xyz(1,:) =  rae(1,:) .* cos(rae(3,:)); % Create r * cos(el).
    xyz(2,:) =  xyz(1,:) .* sin(rae(2,:)); % Re-use r * cos(el).
    xyz(1,:) =  xyz(1,:) .* cos(rae(2,:)); % Re-use (destroy) r * cos(el).

end % rae2xyz
