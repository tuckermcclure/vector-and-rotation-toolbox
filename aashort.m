function [theta, r] = aashort(theta, r)

    % Check dimensions.
    assert(size(theta, 1) == 1, ...
           '%s: The angles must be 1-by-n.', mfilename);
    assert(size(r, 1) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
    assert(size(r, 2) == size(theta, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);
        
    % TODO: Vectorize. Name?
    theta      = mod(theta, 2*pi);
    ind        = theta >= pi;
    theta(ind) = 2*pi - theta(ind);
    if nargout >= 2
        r(:,ind) = -r(:,ind);
    end
    
end % aashort
