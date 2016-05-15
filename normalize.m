function [v, v_mag] = normalize(v)

% NORMALIZE  Safe normalization of the columns of the input matrix
% 
% Safely normalize the columns of the input vectors. When the magnitude is 
% exactly 0, the output vector will be [1; 0; 0]. This function can also 
% output the magnitude of each vector, as a useful byproduct.
%
%   [v, v_mag] = NORMALIZE(v)
%
% Inputs:
%
% v  Vector(s) (3-by-n)
%
%
% Outputs:
% 
% v      Unit vector(s) (3-by-n)
% v_mag  Magnitudes (2-norm) of each of the vectors

% Copyright 2016 An Uncommon Lab

%#codegen
    
    % If running in regular MATLAB, vectorize.
    if isempty(coder.target)
        
        v_mag = vmag(v);
        valid = v_mag > 0;
        v(1,     ~valid) = 1;
        v(2:end, ~valid) = 0;
        if any(valid)
            v(:, valid) = bsxfun(@times, v(:,valid), 1./v_mag(valid));
        end
        
    % Otherwise, when running in some type of embedded code, use efficient
    % (non-vectorized) code.
    else

        % If we need each v_mag...
        if nargout >= 2
            
            v_mag = vmag(v);
            for k = 1:size(v, 2)
                if v_mag(k) == 0
                    v(1,k)     = 1;
                    v(2:end,k) = 0;
                else
                    v(:,k) = v(:,k) ./ v_mag(k);
                end
            end
            
        % Otherwise, v_mag is disposible, so just use a scalar.
        else
            
            for k = 1:size(v, 2)
                v_mag = vmag(v(:,k));
                if v_mag == 0
                    v(1,k) = 1;
                    v(2:end,k) = 0;
                else
                    v(:,k) = v(:,k) ./ v_mag;
                end
            end
            
        end
    
    end
    
end % normalize
