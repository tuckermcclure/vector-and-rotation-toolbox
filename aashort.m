function [theta, r] = aashort(theta, r)
    % TODO: If keeping, vectorize.
    theta      = mod(theta, 2*pi);
    ind        = theta >= pi;
    theta(ind) = 2*pi - theta(ind);
    if nargout >= 2
        r(:,ind) = -r(:,ind);
    end
end
