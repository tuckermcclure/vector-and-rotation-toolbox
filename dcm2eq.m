function ea = dcm2eq(R, seq)

    % If symmetric...
    if seq(1) == seq(3)
       
        i = seq(1);
        j = seq(2);
        if i == 1 || j == 1
            if i == 2 || j == 2
                k = 3;
            else
                k = 2;
            end
        else
            k = 1;
        end
        
        if    (i == 1 && j == 2) ...
           || (i == 2 && j == 3) ...
           || (i == 3 && j == 1)
            alpha = 1;
        else
            alpha = -1;
        end
        
        ea(1) = atan2(-alpha * R(i,j), R(i,k));
        ea(2) = acos(R(i,i));
        ea(3) = atan2(alpha * R(j,i), R(k,i));
        
    % Otherwise, must be asymmetric.
    else
        i = seq(1);
        j = seq(2);
        k = seq(3);
        error('TODO');
    end
    
end
