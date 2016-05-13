function theta = grperr(p_CA, p_BA, varargin)

% grperr
% 
%   theta = grperr(p_CA, p_BA)
%   theta = grperr(p_CA, p_BA, a)
%   theta = grperr(p_CA, p_BA, a, f)
%   theta = grperr(p_CA, p_BA, a, f, s)

% Copyright 2016 An Uncommon Lab

%#codegen

    if isempty(coder.target)
        theta = grp2aa(grpcomp(p_CA, -p_BA, varargin{:}), varargin{:});
    else
        theta = zeros(1, size(p_CA, 2), class(p_CA));
        if length(varargin) >= 3
            s = varargin{3};
            for k = 1:size(p_CA, 2)
                theta(k) = grp2aa(grpcomp(p_CA(:,k), -p_BA(:,k), ...
                                          varargin{1:2}, s(k)), ...
                                  varargin{1:2}, s(k));
            end
        else
            for k = 1:size(p_CA, 2)
                theta(k) = grp2aa(grpcomp(p_CA(:,k), -p_BA(:,k), ...
                                          varargin{:}), ...
                                  varargin{:});
            end
        end
    end
    
end % grperr
