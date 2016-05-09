function qi = qinterp(t, q, ti)

% qi = qinterp(t, q, ti);

% Copyright 2016 An Uncommon Lab

%#codegen

    n  = size(ti, 2);
    qi = zeros(4, n, class(q));
    for k = 1:n

        % TODO: Use an intelligent search. (..., 'Ordered', true, ...).
        index = find(t < ti(k), 1, 'last');
        if isempty(index)
            qi(:,k) = q(:,1);
        elseif index == n
            qi(:,k) = q(:,end);
        else
            f = (ti(k) - t(index)) / (t(index+1) - t(index));
            qi(:,k) = qinterpf(q(:,index), q(:,index+1), f);
        end

    end
       
end % qinterp
