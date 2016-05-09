function vm2 = vmag2(v)

% vmag
%
% Calculate the 2-norm magnitude(s) of the input vector(s).
%
% See also: normalize

% Copyright 2016 An Uncommon Lab

%#codegen

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)

        vm2 = sum(v.*v, 1);
    
    % Otherwise, when running in some type of embedded code, use efficient
    % (non-vectorized) code.
    else
        
        n     = size(v, 2);
        vm2 = zeros(1, n, class(v));
        for k = 1:n
            vm2(k) = v(:,k).' * v(:,k);
        end
        
    end

end % vmag2
