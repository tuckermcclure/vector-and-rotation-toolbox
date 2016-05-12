function p = grpcomp(p2, p1, a, f)

% Copyright 2016 An Uncommon Lab

%#codegen

    if nargin < 3 || isempty(a), a = 1;       end;
    if nargin < 4 || isempty(f), f = 2*(a+1); end;

    n = zeros(3, size(p1, 2), class(p1));
    
    % If in MATLAB, vectorize.
    if isempty(coder.target)
        
        % TODO: Add a == 0?
        if a == 1
            f2 = f * f;
            p1m2 = p1(1,:).*p1(1,:) + p1(2,:).*p1(2,:) + p1(3,:).*p1(3,:);
            p2m2 = p2(1,:).*p2(1,:) + p2(2,:).*p2(2,:) + p2(3,:).*p2(3,:);
            p =   (f2 - p1m2) * p2 ...
                + (f2 - p2m2) * p1 ...
                - 2*f * cross3(p2, p1);
            d = p1(1,:).*p2(1,:) + p1(2,:).*p2(2,:) + p1(3,:).*p2(3,:);
            p = (1./(f2 + 1/f2 * p1m2 .* p2m2 - 2 * d)) * p;
        else
            q1 = grp2q(p1, a, f);
            q2 = grp2q(p2, a, f);
            p  = q2grp(qcomp(q2, q1), a, f);
        end
        
    % Otherwise, make good C.
    else
        
        p = zeros(3, n);
        if a == 1
            for k = 1:n
                f2 = f * f;
                p1m2 = p1(1,:).*p1(1,:) + p1(2,:).*p1(2,:) + p1(3,:).*p1(3,:);
                p2m2 = p2(1,:).*p2(1,:) + p2(2,:).*p2(2,:) + p2(3,:).*p2(3,:);
                p =   (f2 - p1m2) * p2 ...
                    + (f2 - p2m2) * p1 ...
                    - 2*f * cross3(p2, p1);
                p = (1./(f2 + p1m2 .* p2m2 - 2 * p2.' * p1)) * p;
            end
        else
            for k = 1:n
                q1 = grp2q(p1(:,k), a, f);
                q2 = grp2q(p2(:,k), a, f);
                p(:,k)  = q2grp(qcomp(q2, q1), a, f);
            end
        end
        
    end
    
end % grpcomp
