function v = rae2xyz(rae)

% RAE2XYZ  Range-azimuth-elevation to Cartesian coordinates
% 
% Convert from range-azimuth-elevation to Cartesian points. The elevation
% angle measures the rotation from the x-y plane to the point and the
% azimuth angle measures the rotation from x about +z. Range measures the
% distance to the point. In other words, this function first rotates a
% vector at [r; 0; 0] about +y by the elevation angle and then about +z by
% the azimuth angle.
%
%   v = RAE2XYZ(rae)
%
% Inputs:
%
% rae  Vector of ranges, azimuths (rad), and elevations (rad) (3-by-n)
% 
% Outputs:
% 
% v    Cartesian vector
%
% See also: xyz2rae

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(rae, 1) ~= 3 && size(rae, 2) == 3, rae = rae.'; end;
    assert(size(rae, 1) == 3, ...
           '%s: The RAE inputs must be 3-by-n.', mfilename);

    v      = zeros(3, size(rae, 2), class(rae));
    v(3,:) = -rae(1,:) .* sin(rae(3,:)); % Start with z.
    v(1,:) =  rae(1,:) .* cos(rae(3,:)); % Create r * cos(el).
    v(2,:) =  v(1,:) .* sin(rae(2,:)); % Re-use r * cos(el).
    v(1,:) =  v(1,:) .* cos(rae(2,:)); % Re-use (destroy) r * cos(el).

end % rae2xyz
