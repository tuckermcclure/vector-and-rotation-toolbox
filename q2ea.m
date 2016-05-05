function ea = q2ea(q, seq)

    % If it's the 3-2-1 sequence (standard aerospace heading, elevation,
    % bank or yaw, pitch, roll), then use compact form.
    if nargin < 2 || isempty(seq) || all(seq == [3 2 1])
       
        m11 = 2 * q(1,:).^2 + 2 * q(2,:).^2 - 1;
        m12 = 2 * q(2,:) .* q(3,:) + 2 * q(1,:) .* q(4,:);
        m13 = 2 * q(2,:) .* q(4,:) - 2 * q(1,:) .* q(3,:);
        m23 = 2 * q(3,:) .* q(4,:) + 2 * q(1,:) .* q(2,:);
        m33 = 2 * q(1,:).^2 + 2 * q(4,:).^2 - 1;
        ea(1,:) = atan2(m12, m11);
        ea(2,:) = asin(-m13);
        ea(3,:) = atan2(m23, m33);
        
    % Otherwise, use a general form.
    else
        error('TODO');
    end
    
end % q2ea
