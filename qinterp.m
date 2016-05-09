function qi = qinterp(varargin)

% qi = qinterp(t, q, ti);

% Copyright 2016 An Uncommon Lab

%#codegen

    % qi = qinterp(t, q, ti); 
    % TODO: Make a better test for this or make qinterpf its own thing.
    if size(varargin{1}, 1) == 1
        
        t  = varargin{1};
        q  = varargin{2};
        ti = varargin{3};
        n  = size(ti, 2);
        qi = zeros(4, n);
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
        
    % qi = qinterp(qa, qb, f);
    else
        qi = qinterpf(varargin{:});
    end

end % qinterp
