function qi = qinterpf(qa, qb, f)

% QINTERPF  Rotation quaternion interpolation, given interpolation fraction
%
% Interpolates between rotation quaternions given the fractional "amount" 
% from the first to the second.
% 
%   qi = QINTERPF(qa, qb, f);
%
% This type of interpolation preserves the rotational meaning of the
% quaternion. That is, interpolating 10% of the way from qa to qb
% corresponding to rotating 10% of the angle through the rotation of qa wrt
% qb. This is analogous to linear interpolation but in a rotational sense.
%
% Inputs:
%
% qa  The "from" set of quaternions (4-by-n)
% qb  The "to" set of quaternions (4-by-n)
% f   Fraction of distance to move from qa to qb (1-by-1 or 1-by-n)
%
% Outputs:
%
% qi  Interpolated quaternions (4-by-n)

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

    % MATLAB
    if isempty(coder.target)
        
        qi = qdiff(qb, qa);
        [theta, r] = q2aa(qi);
        qi = qcomp(aa2q(f .* theta, r), qa);
        
    % codegen
    else
        
        n  = size(qa, 2);
        qi = zeros(4, n, class(qa));
        for k = 1:size(qa, 2)
            qt = qdiff(qb(:,k), qa(:,k));
            [theta, r] = q2aa(qt);
            qi(:,k) = qcomp(aa2q(f .* theta, r), qa(:,k));
        end
        
    end
    
end % qinterpf
