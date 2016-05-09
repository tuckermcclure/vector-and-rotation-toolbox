function qi = qinterpf(qa, qb, f)

% qinterpf
% 
% Interpolate from qa to qb according to fraction f.
% 
%   qi = qinterpf(qa, qb, f);

% Copyright 2016 An Uncommon Lab

%#codegen

    % TODO: Is there a better way?

    qi = qinv(qa);
    qi = qcomp(qb, qi);
    [theta, r] = q2aa(qi);
    qi = qcomp(aa2q(r, f * theta), qa);
    
end % qinterpf
