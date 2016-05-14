function p_CB = mrpdiff(p_CA, p_BA, f)

% mrpdiff
% 
%   theta = mrpdiff(p_CA, p_BA)
%   theta = mrpdiff(p_CA, p_BA, f)

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

    n = size(p_CA, 2);
    if isempty(coder.target)
        p_CB = mrpcomp(p_CA, -p_BA, f);
    else
        p_CB = zeros(3, n, class(p_CA));
        for k = 1:n
            p_CB(:,k) = mrpcomp(p_CA(:,k), -p_BA(:,k), f);
        end
    end
    
end % mrpdiff
