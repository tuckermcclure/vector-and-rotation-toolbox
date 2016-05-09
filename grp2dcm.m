function R = grp2dcm(p, a, f)

% grp2dcm

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set some defaults.
    if nargin < 2 || isempty(a), a = 1; end;
    if nargin < 3 || isempty(f), f = 4; end;

    % When a == 1, we can go directly to the DCM. Otherwise, it's easier to
    % go through the quaternion.
    if a == 1
        
        % Dims
        n = size(p, 2);
        R = zeros(3, 3, n, class(p));
        
        % Make the denominator term.
        f2  = f*f;
        pm2 = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
        s1  = f2 + pm2;
        s1  = (f2 * 8) ./ (s1.*s1);
        
        % Make the diagonals.
        R(1,1,:) = 1 - s1 .* (p(3,:).*p(3,:) + p(2,:).*p(2,:));
        R(2,2,:) = 1 - s1 .* (p(3,:).*p(3,:) + p(1,:).*p(1,:));
        R(3,3,:) = 1 - s1 .* (p(1,:).*p(1,:) + p(2,:).*p(2,:));
        
        % Make the remaining terms.
        s2 = f2 - pm2;
        s2 = (0.5/f) * s2 .* s1;
        R(1,2,:) =  s2 .* p(3,:) + s1 .* p(1,:) .* p(2,:);
        R(1,3,:) = -s2 .* p(2,:) + s1 .* p(1,:) .* p(3,:);
        R(2,3,:) =  s2 .* p(1,:) + s1 .* p(2,:) .* p(3,:);
        R(2,1,:) = -s2 .* p(3,:) + s1 .* p(2,:) .* p(1,:);
        R(3,1,:) =  s2 .* p(2,:) + s1 .* p(3,:) .* p(1,:);
        R(3,2,:) = -s2 .* p(1,:) + s1 .* p(3,:) .* p(2,:);
        
    else % a ~= 1
        
        % In MATLAB?
        if isempty(coder.target)
            
            % Vectorize.
            R = q2dcm(grp2q(p, a, f));
            
        % In code?
        else
        
            % Loop.
            n = size(p, 2);
            R = zeros(3, 3, n, class(p));
            for k = 1:n
                R(:,:,k) = q2dcm(grp2q(p(:,k), a, f));
            end
            
        end
        
    end
    
end % grp2dcm
