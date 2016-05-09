function p = grpcomp(p2, p1, varargin)

% Copyright 2016 An Uncommon Lab

%#codegen

    if nargin < 3 || isempty(varargin{1}), a = 1; end;
    if nargin < 4 || isempty(varargin{2}), f = 4; end;

    if a == 1
        
        if f ~= 1
            p1 = p1./f;
            p2 = p2./f;
        end
        
        p1m2 = p1(1,:).*p1(1,:) + p1(2,:).*p1(2,:) + p1(3,:).*p1(3,:);
        p2m2 = p2(1,:).*p2(1,:) + p2(2,:).*p2(2,:) + p2(3,:).*p2(3,:);
        p =   (1 - p1m2) * p2 ...
            + (1 - p2m2) * p1 ...
            - 2 * cross3(p2, p1);
        p = (1./(1 + p1m2 .* p2m2 - 2 * p2.' * p1)) * p;
        
        % TODO: Not vectorized.
        
    % Otherwise, use quaternions.
    else
        % TODO: Make codegen version.
        q1 = grp2q(p1, varargin{:});
        q2 = grp2q(p2, varargin{:});
        p  = q2grp(qcomp(q2, q1, varargin{:}), varargin{:});
    end

end % grpcomp
