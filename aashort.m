function [theta, r] = aashort(theta, r)

% AASHORT  Shortest equivalent angle of rotation and corresponding axis
%
% Calculate the shortest angle of rotation and corresponding axis for the
% given rotations.
% 
%   [theta, r] = AASHORT(theta, r)
%   theta      = AASHORT(theta, r)
%
% When the axis isn't needed, this output can be skip, which saves some
% computation time.
% 
% Inputs:
%
% r      Unit axis (or axes) of right-handed rotation (3-by-n)
% theta  Angle(s) of rotation of frame B wrt A about r (1-by-n)
%
% Outputs:
%
% r      Unit axis (or axes) of right-handed rotation (3-by-n)
% theta  Smallest angle(s) of rotation of frame B wrt A about r (1-by-n)
%
% See also: qpos, mrpalt

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    assert(size(theta, 1) == 1, ...
           '%s: The angles must be 1-by-n.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
    
    % MATLAB
    if isempty(coder.target)
        
        theta      = mod(theta, 2*pi);
        ind        = theta >= pi;
        theta(ind) = 2*pi - theta(ind);
        if nargout >= 2
            r(:,ind) = -r(:,ind);
        end
        
    % codegen
    else
        
        for k = 1:length(theta)
            theta(k) = mod(theta(k));
            if theta(k) > pi
                theta(k) = 2*pi - theta(k);
                if nargout >= 2
                    r(:, k) = 0;
                end
            end
        end
        
    end
    
end % aashort
