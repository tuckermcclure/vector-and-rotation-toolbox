function v = normalize(v, tol)

% normalize
% 
% Safe, vectorized normalization function. Normalizes each column vector in
% the input matrix. An optional tolerance can be provided; vectors with
% magnitudes below this tolerance will be unaffected.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Set default tolerance for divide-by-zero.
    if nargin < 2, tol = eps; end;
    
    % Where the magnitude is large enough, divide.
    for k = 1:size(v, 2)
        v_mag = vmag(v(:,k));         % Get the magnitude.
        if v_mag >= tol               % If it's above the tolerance...
            v(:,k) = v(:,k) ./ v_mag; % Divide it off.
        end
    end
    
end % normalize
