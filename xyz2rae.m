function rae = xyz2rae(v)

% XYZ2RAE
%
% Convert range-azimuth-elevation to Cartesian points with the same
% conventions as rae2xyz.
%
% The units of the angles will be radians. The units of the range will be
% the same as the units of the input vector.
%
% Inputs:
%
% v  Cartesian vectors (3-by-n)
%
% Outputs:
%
% rae  Range, azimuth, and elevation of each vector (3-by-n)
%
% See also: rae2xyz

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(v, 1) ~= 3 && size(v, 2) == 3, v = v.'; end;
    assert(size(v, 1) == 3, ...
           '%s: The input vectors must be 3-by-n.', mfilename);

    n   = size(v, 2);
    rae = zeros(3, n, class(v));
    
    % MATLAB
    if isempty(coder.target)
    
        rae(1,:)   = vmag(v);
        pos        = rae(1,:) > 0;
        rae(3,pos) = asin(-v(3,pos) ./ rae(1,pos));
        rae(2,pos) = atan2(v(2,pos), v(1,pos));
        
    % codegen
    else

        for k = 1:n
            r = vmag(v(:,k));
            if r > 0
                rae(1,k) = r;
                rae(3,k) = asin(-v(3,k) ./ r);
                rae(2,k) = atan2(v(2,k), v(1,k));
            end
        end
        
    end

end % xyz2rae
