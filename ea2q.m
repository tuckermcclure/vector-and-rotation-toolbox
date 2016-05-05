function q = ea2q(ea, seq)

    % If it's the 3-2-1 sequence (standard aerospace heading, elevation,
    % bank or yaw, pitch, roll), then use compact form.
    if nargin < 2 || isempty(seq) || all(seq == [3 2 1])
        
        c1 = cos(0.5*ea(1,:));
        c2 = cos(0.5*ea(2,:));
        c3 = cos(0.5*ea(3,:));
        s1 = sin(0.5*ea(1,:));
        s2 = sin(0.5*ea(2,:));
        s3 = sin(0.5*ea(3,:));
        q = [c1.*c2.*c3 + s1.*s2.*s3; ...
             c1.*c2.*s3 - s1.*s2.*c3; ...
             c1.*s2.*c3 + s1.*c2.*s3; ...
             s1.*c2.*c3 - c1.*s2.*s3];
        
    % Otherwise, for other sequences, use Rx, Ry, and Rz.
    else

        % Set the initial quaternion.
        n = size(ea, 2);
        q = zeros(4, n);
        q(1,:) = cos(0.5*ea(1,:));
        switch seq(1)
            case {1, 'x'}
                q(2,:) = sin(0.5*ea(1,:));
            case {2, 'y'}
                q(3,:) = sin(0.5*ea(1,:));
            case {3, 'z'}
                q(4,:) = sin(0.5*ea(1,:));
            otherwise
                error('Invalid sequence identifier.');
        end
        
        % Perform the subsequent two rotations
        for k = 1:2
            qk = zeros(4, n);
            qk(1,:) = cos(0.5*ea(k,:));
            switch seq(k)
                case {1, 'x'}
                    qk(2,:) = sin(0.5*ea(k,:));
                case {2, 'y'}
                    qk(3,:) = sin(0.5*ea(k,:));
                case {3, 'z'}
                    qk(4,:) = sin(0.5*ea(k,:));
                otherwise
                    error('Invalid sequence identifier.');
            end
            q = qcomp(qk, q);
        end
        
    end

end % ea2q
