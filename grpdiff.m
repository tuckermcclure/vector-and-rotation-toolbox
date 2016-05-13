function p_CB = grpdiff(p_CA, p_BA, varargin)

% grperr
% 
%   theta = grpdiff(p_CA, p_BA)
%   theta = grpdiff(p_CA, p_BA, a)
%   theta = grpdiff(p_CA, p_BA, a, f)
%   theta = grpdiff(p_CA, p_BA, a, f, s)

% Copyright 2016 An Uncommon Lab

%#codegen

    if isempty(coder.target)
        p_CB = grpcomp(p_CA, -p_BA, varargin{:});
    else
        p_CB = zeros(3, size(p_CA, 2), class(p_CA));
        if length(varargin) >= 3
            s = varargin{3};
            for k = 1:size(p_CA, 2)
                p_CB(:,k) = grpcomp(p_CA(:,k), -p_BA(:,k), ...
                                    varargin{1:2}, s(k));
            end
        else
            for k = 1:size(p_CA, 2)
                p_CB(:,k) = grpcomp(p_CA(:,k), -p_BA(:,k), varargin{:});
            end
        end
    end
    
end % grpdiff
