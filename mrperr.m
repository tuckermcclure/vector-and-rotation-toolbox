function theta = mrperr(p_CA, p_BA, f)

% mrperr
% 
%   theta = mrperr(p_CA, p_BA)
%   theta = mrperr(p_CA, p_BA, f)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    if isempty(coder.target)
        theta = mrp2aa(mrpcomp(p_CA, -p_BA, f), f);
    else
        theta = zeros(1, size(p_CA, 2), class(p_CA));
        for k = 1:size(p_CA, 2)
            theta(k) = mrp2aa(mrpcomp(p_CA(:,k), -p_BA(:,k), f), f);
        end
    end
    
end % mrperr
