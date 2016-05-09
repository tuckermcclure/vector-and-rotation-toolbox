function v_mag = vmag(v)

% vmag
%
% Calculate the 2-norm magnitude(s) of the input vector(s).
%
% See also: normalize

% Copyright 2016 An Uncommon Lab

%#codegen

    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)

        v_mag = sqrt(sum(v.*v, 1));
    
    % Otherwise, when running in some type of embedded code, use efficient
    % (non-vectorized) code.
    else
        
        n     = size(v, 2);
        v_mag = zeros(1, n, class(v));
        for k = 1:n
            v_mag(k) = v(:,k).' * v(:,k);
            v_mag(k) = sqrt(v_mag(k));
        end
        
    end

end % vmag
