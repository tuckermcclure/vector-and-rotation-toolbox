function R = ea2dcm(ea, seq)

    if nargin < 2 || isempty(seq), seq = [3 2 1]; end;
    
    % TODO: Vectorize.
    
    switch seq(1)
        case {1, 'x'}
            R = Rx(ea(1));
        case {2, 'y'}
            R = Ry(ea(1));
        case {3, 'z'}
            R = Rz(ea(1));
        otherwise
            error('Invalid sequence identifier.');
    end
    for k = 2:3
        switch seq(k)
            case {1, 'x'}
                R = Rx(ea(k)) * R;
            case {2, 'y'}
                R = Ry(ea(k)) * R;
            case {3, 'z'}
                R = Rz(ea(k)) * R;
            otherwise
                error('Invalid sequence identifier.');
        end
    end
    
%     % If symmetric...
%     if seq(1) == seq(3)
%        
%         i = seq(1);
%         j = seq(2);
%         if i == 1 || j == 1
%             if i == 2 || j == 2
%                 k = 3;
%             else
%                 k = 2;
%             end
%         else
%             k = 1;
%         end
%         R(i, j) = cos(ea(2));
%         
%     % Otherwise, must be asymmetric.
%     else
%         i = seq(1);
%         j = seq(2);
%         k = seq(3);
%     end

end
