function qi = qinterp(t, q, ti)

% QINTERP  Rotation quaternion interpolation, given independent variables
%
% Interpolates between rotation quaternions at various values of the
% independent variable, t, (usually tim) according to new values, ti (other
% times). Both t and ti should be in ascending order.
% 
%   qi = QINTERP(t, q, ti);
%
% This type of interpolation preserves the rotational meaning of the
% quaternion. That is, interpolating 10% of the way from qa to qb
% corresponding to rotating 10% of the angle through the rotation of qa wrt
% qb. This is analogous to linear interpolation but in a rotational sense.
%
% Inputs:
%
% t   Independent variable, usually time (1-by-n)
% q   Quaternions corresponding to t (4-by-n)
% ti  Values for the independent variable at which to interpolate (1-by-m)
%
% Outputs:
%
% qi  Interpolated quaternions corresponding to ti (4-by-m)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(t, 1)  ~= 1 && size(t, 2)  == 1, t  = t.';  end;
    if size(q, 1)  ~= 4 && size(q, 2)  == 4, q  = q.';  end;
    if size(ti, 1) ~= 1 && size(ti, 2) == 1, ti = ti.'; end;
    assert(size(t, 1) == 1 && size(ti, 1) == 1, ...
           '%s: The time inputs must be 1-by-n.', mfilename);
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    assert(size(t, 2) == size(q, 2), ...
           ['%s: The time inputs and quaternions must have the ' ...
            'same number of columns.'], mfilename);

    n  = size(ti, 2);
    qi = zeros(4, n, class(q));
    for k = 1:n

        % TODO: Use an intelligent search. (..., 'Ordered', true, ...).
        if ti(k) <= t(1)
            qi(:,k) = q(:,1);
        elseif ti(k) >= t(end)
            qi(:,k) = q(:,end);
        else
            index = find(t < ti(k), 1, 'last');
            f = (ti(k) - t(index)) / (t(index+1) - t(index));
            qi(:,k) = qinterpf(q(:,index), q(:,index+1), f);
        end

    end
       
end % qinterp
