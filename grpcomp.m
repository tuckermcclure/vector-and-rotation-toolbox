function [p, s] = grpcomp(p2, p1, a, f, s2, s1)

% Copyright 2016 An Uncommon Lab

%#codegen

    n = size(p1, 2);
    
    % Set defaults for "near" rotation, and so that for small angles, the
    % GRPs will approach the rotation vector.
    if nargin < 3 || isempty(a),  a  = 1;           end;
    if nargin < 4 || isempty(f),  f  = 2*(a+1);     end;
    if nargin < 5 || isempty(s2), s2 = false(1, n); end;
    if nargin < 6 || isempty(s1), s1 = false(1, n); end;

    % If in MATLAB, vectorize.
    if isempty(coder.target)
        
%         % We must operate on the same sets, so swap p1 where it's from a
%         % different set than p2.
%         swap     = xor(s1, s2);
%         p1(:,swap) = grpalt(p1(:,swap), a, f, s1(swap));
        
        % TODO: Add a == 0?
        if a == 1
            f2 = f * f;
            p1m2 = p1(1,:).*p1(1,:) + p1(2,:).*p1(2,:) + p1(3,:).*p1(3,:);
            p2m2 = p2(1,:).*p2(1,:) + p2(2,:).*p2(2,:) + p2(3,:).*p2(3,:);
            d    = p1(1,:).*p2(1,:) + p1(2,:).*p2(2,:) + p1(3,:).*p2(3,:);
            c0   = (f2 - p1m2);
            c1   = (f2 - p2m2);
            c2   = 1./(f2 + (1/f2) .* p1m2 .* p2m2 - 2 * d);
            p    = (-2*f) * cross3(p2, p1);
            p(1,:) = (p(1,:) + c0 .* p2(1,:) + c1 .* p1(1,:)) .* c2;
            p(2,:) = (p(2,:) + c0 .* p2(2,:) + c1 .* p1(2,:)) .* c2;
            p(3,:) = (p(3,:) + c0 .* p2(3,:) + c1 .* p1(3,:)) .* c2;
            s = s2;
        else
            q1     = grp2q(p1, a, f, s1);
            q2     = grp2q(p2, a, f, s2);
            [p, s] = q2grp(qcomp(q2, q1), a, f);
        end
        
    % Otherwise, make good C.
    else
        
        p = zeros(3, n, class(p1));
        s = s2;
        if a == 1
            f2 = f * f;
            for k = 1:n
                if s2(k) ~= s2(k)
                    p2s = grpalt(p2(:,k), a, f, s2(k));
                else
                    p2s = p2(:,k);
                end
                p1m2 = p1(1,k).*p1(1,k) + p1(2,k).*p1(2,k) + p1(3,k).*p1(3,k);
                p2m2 = p2s(1).*p2s(1) + p2s(2).*p2s(2) + p2s(3).*p2s(3);
                d    = p1(1,k).*p2s(1) + p1(2,k).*p2s(2) + p1(3,k).*p2s(3);
                p(:,k) =   (f2 - p1m2) * p2s(:) ...
                         + (f2 - p2m2) * p1(:,k) ...
                         - 2*f * cross3(p2s(:), p1(:,k));
                p(:,k) = (1/(f2 + p1m2 * p2m2 - 2 * d)) * p(:,k);
            end
        else
            for k = 1:n
                q1 = grp2q(p1(:,k), a, f, s1);
                q2 = grp2q(p2(:,k), a, f, s2);
                [p(:,k), s(:,k)] = q2grp(qcomp(q2, q1), a, f);
            end
        end
        
    end
    
end % grpcomp
