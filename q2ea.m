function ea = q2ea(q, seq)


% Copyright 2016 An Uncommon Lab

%#codegen

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

    % Pre-allocate.
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
                       - q(k,:).*q(k,:) + q(1,:).*q(1,:));
                 
        for z = 1:n
            if sin(ea(2,z)) ~= 0
                a1 = atan2(q(i,z), q(4,z));
                a2 = atan2(alpha * q(i,z), q(j,z));
                ea(1,z) = a1 + a2;
                ea(3,z) = a1 - a2;
            else
                if ea(2,z) == 0
                    ea(1,:) = atan2(q(i,z), q(4,z));
                else
                    ea(1,:) = atan2(alpha * q(i,z), q(j,z));
                end
            end
        end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
            
        ea(2,:) = asin(2 * (q(4,:) .* q(j,:) + alpha * q(k,:) .* q(i,:)));
                 
        for z = 1:n
            if ea(2,k) == pi/2
                ea(1,:) = atan2(q(i,z) + alpha * q(k,z), ...
                                q(4,z) + alpha * q(j,z));
            elseif ea(2,k) == -pi/2
                ea(1,:) = atan2(q(i,z) - alpha * q(k,z), ...
                                q(4,z) - alpha * q(j,z));
            else
                a1 = atan2(q(i,z) + q(k,z), q(4,z) + alpha * q(j,z));
                a2 = atan2(q(i,z) - q(k,z), q(4,z) - alpha * q(j,z));
                ea(1,z) = a1 + a2;
                ea(3,z) = a1 - a2;
            end
        end
        
    end
    
%     % If it's the 3-2-1 sequence (standard aerospace heading, elevation,
%     % bank or yaw, pitch, roll), then use compact form.
%     if nargin < 2 || isempty(seq) || all(seq == [3 2 1])
%        
%         m11 = 2 * q(1,:).^2 + 2 * q(2,:).^2 - 1;
%         m12 = 2 * q(2,:) .* q(3,:) + 2 * q(1,:) .* q(4,:);
%         m13 = 2 * q(2,:) .* q(4,:) - 2 * q(1,:) .* q(3,:);
%         m23 = 2 * q(3,:) .* q(4,:) + 2 * q(1,:) .* q(2,:);
%         m33 = 2 * q(1,:).^2 + 2 * q(4,:).^2 - 1;
%         ea(1,:) = atan2(m12, m11);
%         ea(2,:) = asin(-m13);
%         ea(3,:) = atan2(m23, m33);
%         
%     % Otherwise, use a general form.
%     else
%     end
    
end % q2ea
