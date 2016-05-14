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
