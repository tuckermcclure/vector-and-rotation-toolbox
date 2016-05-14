function qi = qinterpf(qa, qb, f)

% qinterpf
% 
% Interpolate from qa to qb according to fraction f.
% 
%   qi = qinterpf(qa, qb, f);

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(qa, 1) ~= 4 && size(qa, 2) == 4, qa = qa.'; end;
    if size(qb, 1) ~= 4 && size(qb, 2) == 4, qb = qb.'; end;
    if size(f,  1) ~= 1 && size(f,  2) == 1, f  = f.';  end;
    assert(size(qa, 1) == 4 && size(qb, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    assert(size(qa, 2) == size(qb, 2), ...
           ['%s: The two quaternion inputs must have the same ' ...
            'number of columns.'], mfilename);
	assert(   all(size(f) == 1) ...
           || (size(f, 1) == 1 && size(f, 2) == size(qa, 2)), ...
           ['%s: The interpolation fraction must be either a scalar ' ...
            'or have the same number of columns as the quaternions.'], ...
           mfilename);

    % TODO: Is there a better way?

    qi = qinv(qa);
    qi = qcomp(qb, qi);
    [theta, r] = q2aa(qi);
    qi = qcomp(aa2q(f .* theta, r), qa);
    
end % qinterpf
