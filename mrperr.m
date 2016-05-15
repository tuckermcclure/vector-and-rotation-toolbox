function theta = mrperr(p_CA, p_BA, f)

% MRPERR
%
% Returns the angle of the first rotation wrt the second rotation. For
% example, if p_CA were a true value and P_BA were some estimate of the
% truth, this function would calculate the error angle of the estimate.
% 
%   theta = MRPERR(p_CA, p_BA)    % for traditional MRPs
%   theta = MRPERR(p_CA, p_BA, f) % for scaled MRPs
%
% This is a simple convenience utility and corresponds to:
%
%   theta = mrp2aa(mrpcomp(p_CA, -p_BA));
% 
% Inputs:
%
% p_CA  Modified Rodrigues parameters some rotation (3-by-n)
% p_BA  Modified Rodrigues parameters different rotation (3-by-n)
% f     Optional scaling parameter (default 1)
%
% Outputs:
%
% theta  Angle of first rotation wrt second (radians, 1-by-n)


% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(p_CA, 1) == 3 && size(p_BA, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(size(p_CA, 2) == size(p_BA, 2), ...
           '%s: The number of MRPs in each input must match.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

	% MATLAB
    if isempty(coder.target)
        
        theta = mrp2aa(mrpcomp(p_CA, -p_BA, f), f);
        
    % codegen
    else
        
        theta = zeros(1, size(p_CA, 2), class(p_CA));
        for k = 1:size(p_CA, 2)
            theta(k) = mrp2aa(mrpcomp(p_CA(:,k), -p_BA(:,k), f), f);
        end
        
    end
    
end % mrperr
