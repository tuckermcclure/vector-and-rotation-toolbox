function v_mag = vmag(v)

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
        
        v_mag = sqrt(vmag2(v));
        
    else

        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)

            v_mag = sqrt(dot(v, v, 1));

        % Otherwise, when running in some type of embedded code, use
        % efficient (non-vectorized) code.
        else

            n     = size(v, 2);
            v_mag = zeros(1, n, class(v));
            for k = 1:n
                v_mag(k) = sqrt(v(:,k).' * v(:,k));
            end

        end
        
    end

end % vmag
