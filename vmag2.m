function vm2 = vmag2(v)

% vmag
%
% Calculate the 2-norm magnitude(s) of the input vector(s).
%
% See also: normalize

% Copyright 2016 An Uncommon Lab

%#codegen

    % 3D vectors are common, and this generates better code than for the
    % general case.
    if size(v, 1) == 3
        
        vm2 = v(1,:).*v(1,:) + v(2,:).*v(2,:) + v(3,:).*v(3,:);
        
    % Otherwise, for some other dimensionality...
    else

        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)

            vm2 = sum(v.*v, 1);

        % Otherwise, when running in some type of embedded code, use efficient
        % (non-vectorized) code.
        else

            n   = size(v, 2);
            vm2 = zeros(1, n, class(v));
            for k = 1:n
                vm2(k) = v(:,k).' * v(:,k);
            end

        end
        
    end

end % vmag2
