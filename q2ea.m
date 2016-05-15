function ea = q2ea(q, seq)


% Copyright 2016 An Uncommon Lab

%#codegen

    if nargin < 2, seq = [3 2 1]; end;

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    assert(size(seq, 1) == 1 && size(seq, 2) == 3, ...
           '%s: The Euler angle rotation sequence must be 1-by-3.', ...
           mfilename);
    assert(seq(1) ~= seq(2) && seq(2) ~= seq(3), ...
           ['%s: The Euler angle sequence cannot repeat rotations ' ...
            'about the same axis.'], mfilename);

    % Determine signs.
    i = seq(1);
    j = seq(2);
    if    (i == 1 && j == 2) ...
       || (i == 2 && j == 3) ...
       || (i == 3 && j == 1)
        alpha = 1;
    else
        alpha = -1;
    end

    % Preallocate.
    n  = size(q, 2);
    ea = zeros(3, n, class(q));
    
    % If symmetric...
    if seq(1) == seq(3)
       
        % Determine the other axis.
        if (i == 1 && j == 2) || (i == 2 && j == 1)
            k = 3;
        elseif (i == 1 && j == 3) || (i == 3 && j == 1)
            k = 2;
        else
            k = 1;
        end
        
        ea(2,:) = acos(  q(i,:).*q(i,:) - q(j,:).*q(j,:) ...
                       - q(k,:).*q(k,:) + q(4,:).*q(4,:));
                 
        % MATLAB
        if isempty(coder.target)
            
            i1       = ea(2,:) == 0;
            i2       = ea(2,:) == pi;
            i3       = ~i1 & ~i2;
            ea(1,i1) = 2 * atan2(q(i,i1), q(4,i1));
            if alpha > 0
                ea(1,i2) = 2 * atan2(q(k,i2), q(j,i2));
                a2       = atan2(q(k,i3), q(j,i3));
            else
                ea(1,i2) = 2 * atan2(-q(k,i2), q(j,i2));
                a2       = atan2(-q(k,i3), q(j,i3));
            end
            a1       = atan2(q(i,i3), q(4,i3));
            ea(1,i3) = a1 + a2;
            ea(3,i3) = a1 - a2;
            
        % codegen
        else
                   
            if alpha > 0
                for z = 1:n
                    if ea(2,z) == 0
                        ea(1,z) = 2*atan2(q(i,z), q(4,z)); % Shuster misses a 2 here.
                    elseif ea(2,z) == pi
                        ea(1,z) = 2*atan2(q(k,z), q(j,z));
                    else
                        a1 = atan2(q(i,z), q(4,z));
                        a2 = atan2(q(k,z), q(j,z));
                        ea(1,z) = a1 + a2;
                        ea(3,z) = a1 - a2;
                    end
                end
            else
                for z = 1:n
                    if ea(2,z) == 0
                        ea(1,z) = 2*atan2(q(i,z), q(4,z)); % Shuster misses a 2 here.
                    elseif ea(2,z) == pi
                        ea(1,z) = 2*atan2(-q(k,z), q(j,z));
                    else
                        a1 = atan2(q(i,z), q(4,z));
                        a2 = atan2(-q(k,z), q(j,z));
                        ea(1,z) = a1 + a2;
                        ea(3,z) = a1 - a2;
                    end
                end
            end
            
        end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
            
        if alpha > 0
            ea(2,:) = asin(2 * (q(4,:) .* q(j,:) + q(k,:) .* q(i,:)));
        else
            ea(2,:) = asin(2 * (q(4,:) .* q(j,:) - q(k,:) .* q(i,:)));
        end
                 
        % MATLAB
        if isempty(coder.target)
            
            i1 = ea(2,:) ==  pi/2;
            i2 = ea(2,:) == -pi/2;
            i3 = ~i1 & ~i2;
            if alpha > 0
                ea(1,i1) = atan2(q(i,i1) + q(k,i1), ...
                                 q(4,i1) + q(j,i1));
                ea(1,i2) = atan2(q(i,i2) - q(k,i2), ...
                                 q(4,i2) - q(j,i2));
                a1 = atan2(q(i,i3) + q(k,i3), q(4,i3) + q(j,i3));
                a2 = atan2(q(i,i3) - q(k,i3), q(4,i3) - q(j,i3));
            else
                ea(1,i1) = atan2(q(i,i1) - q(k,i1), ...
                                 q(4,i1) - q(j,i1));
                ea(1,i2) = atan2(q(i,i2) + q(k,i2), ...
                                 q(4,i2) + q(j,i2));
                a1 = atan2(q(i,i3) + q(k,i3), q(4,i3) - q(j,i3));
                a2 = atan2(q(i,i3) - q(k,i3), q(4,i3) + q(j,i3));
            end
            ea(1,i3) = a1 + a2;
            ea(3,i3) = a1 - a2;
            
        % codegen
        else
            
            if alpha > 0
                for z = 1:n
                    if ea(2,z) == pi/2
                        ea(1,:) = atan2(q(i,z) + q(k,z), ...
                                        q(4,z) + q(j,z));
                    elseif ea(2,z) == -pi/2
                        ea(1,:) = atan2(q(i,z) - q(k,z), ...
                                        q(4,z) - q(j,z));
                    else
                        a1 = atan2(q(i,z) + q(k,z), q(4,z) + q(j,z));
                        a2 = atan2(q(i,z) - q(k,z), q(4,z) - q(j,z));
                        ea(1,z) = a1 + a2;
                        ea(3,z) = a1 - a2;
                    end
                end
            else
                for z = 1:n
                    if ea(2,z) == pi/2
                        ea(1,:) = atan2(q(i,z) - q(k,z), ...
                                        q(4,z) - q(j,z));
                    elseif ea(2,z) == -pi/2
                        ea(1,:) = atan2(q(i,z) + q(k,z), ...
                                        q(4,z) + q(j,z));
                    else
                        a1 = atan2(q(i,z) + q(k,z), q(4,z) - q(j,z));
                        a2 = atan2(q(i,z) - q(k,z), q(4,z) + q(j,z));
                        ea(1,z) = a1 + a2;
                        ea(3,z) = a1 - a2;
                    end
                end
            end
            
        end
        
    end
    
end % q2ea
