function [v_mag, v_mag_2] = vmag(v)

% VMAG  Magnitude (2-norm) of each vector (column) of the input
%
% Calculate the magnitude (2-norm) of each vector (column) of the input.
% This operates on vectors with any dimension, but contains efficient code
% specially for 3-dimensional vectors.
% 
%    v_mag            = VMAG(v)
%    [v_mag, v_mag_2] = VMAG(v)
%
% As a convenient byproduct, it can also output the square of the
% magnitudes.
%
% Inputs:
%
% v  Set of vectors to normalize (m-by-n)
% 
% Outputs:
%
% v_mag    Magnitudes (2-norm) of the vectors (1-by-n)
% v_mag_2  Squares of the magnitudes (1-by-n)
%
% See also: vmag2, normalize

% Copyright 2016 An Uncommon Lab

%#codegen

    % 3D vectors are common, and this generates better code than for the
    % general case.
    if size(v, 1) == 3
        
        v_mag_2 = vmag2(v);
        v_mag   = sqrt(v_mag_2);
        
    else

        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)

            v_mag = sqrt(dot(v, v, 1));

        % Otherwise, when running in some type of embedded code, use
        % efficient (non-vectorized) code.
        else

            n     = size(v, 2);
            v_mag = zeros(1, n, class(v));
            
            if nargout >= 2
                v_mag_2 = zeros(1, n, class(v));
                for k = 1:n
                    v_mag_2(k) = v(:,k).' * v(:,k);
                    v_mag(k)   = sqrt(v_mag_2(k));
                end
            else
                for k = 1:n
                    v_mag(k) = sqrt(v(:,k).' * v(:,k));
                end
            end

        end
        
    end

end % vmag
