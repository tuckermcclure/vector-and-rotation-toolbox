function qi = qinterp(t, q, ti, varargin)

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
%
% Option-Value Pairs:
%
% Ordered  Set to true when the input ti is already in ascending order.
%          Default is false.
% Binary   Set to true to use a binary search for each request value of ti
%          (faster for interpolating a few values inside a large dataset);
%          set to false to use a straightforward search (may be faster
%          otherwise). Default is true.

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

    % Get the dimensions.
    n  = size(t, 2);
    m  = size(ti, 2);
    
    % Process some options.
    ordered = m == 1; % Only assume ordered if there's 1 ti value.
    binary  = true;   % Use binary search by default.
    for k = 2:2:length(varargin)
        switch lower(varargin{k-1})
            case 'ordered'
                ordered = varargin{k};
            case 'binrary'
                binary = varargin{k};
            otherwise
                error('%s: Unknown option: %s.', mfilename, varargin{k-1});
        end
    end
    
    % If the requested times aren't sorted, sort them.
    if ~ordered
        [ti, ind] = sort(ti);
    end
    
    qi        = zeros(4, m, class(q)); %#ok<ZEROLIKE>
    left      = 1;
    last_left = 1;
    interval  = n - 1;
    for k = 1:m
        
        % The requested time is before the start; limit.
        if ti(k) <= t(1)
            
            qi(:,k) = q(:,1);
            
        % The requested time is after the end; limit.
        elseif ti(k) >= t(end)
            
            qi(:,k) = q(:,end);
            
        % Otherwise, find the first value of t that's greater than ti(k).
        else

            % Find the first element of t that's >= ti(k), using a binary
            % search if we can.
            if binary
            
                % Start the right hand side at the left plus the same
                % amount the search moved last time. Double it until the
                % right is > the requested time.
                right = left + interval;
                while right < n && t(right) < ti(k)
                    right = 2 * (right - left) + left;
                end
                if right > n
                    right = n;
                end

                % Search within the left and right bounds for the crossover
                % point.
                while left < right - 1
                    c = left + floor((right - left)/2);
                    if t(c) < ti(k)
                        left = c;
                    else
                        right = c;
                    end
                end

                % How far did we step this time?
                interval  = left - last_left + 1;
                last_left = left;
            
            % Otherwise, use a straightforward search.
            else
                
                while c <= n && t(c) < ti(k)
                    c = c + 1;
                end
                
            end
            
            % Calculate fraction from left to right and finally
            % interpolate.
            f = (ti(k) - t(left)) / (t(right) - t(left));
            if f >= 1
                qi(:,k) = q(:,right);
            elseif f <= 0
                qi(:,k) = q(:,left);
            else
                qi(:,k) = qinterpf(q(:,left), q(:,right), f);
            end
            
        end

    end
       
    % If they weren't sorted, give them back in the right order.
    if ~ordered
        qi(:,ind) = qi;
    end
    
end % qinterp
