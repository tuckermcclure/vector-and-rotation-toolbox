function q = ea2q(ea, seq)

% ea2q

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
    n = size(ea, 2);
    q = zeros(4, n, class(ea));
    
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
        
        a = cos(ea(2,:));
        q(i,:) =         a .* sin(ea(1,:) + ea(3,:));
        q(4,:) =         a .* cos(ea(1,:) + ea(3,:));
        a = sin(ea(2,:));
        q(j,:) =         a .* cos(ea(1,:) - ea(3,:));
        q(k,:) = alpha * a .* sin(ea(1,:) - ea(3,:));
    
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
            
        cphi   = cos(ea(1,:));
        ctheta = cos(ea(2,:));
        cpsi   = cos(ea(3,:));

        sphi   = sin(ea(1,:));
        stheta = sin(ea(2,:));
        spsi   = sin(ea(3,:));
        
        q(i,:) = cpsi .* ctheta .* sphi + alpha * spsi .* stheta .* cphi;
        q(j,:) = cpsi .* stheta .* cphi - alpha * spsi .* ctheta .* sphi;
        q(k,:) = spsi .* ctheta .* cphi + alpha * cpsi .* stheta .* sphi;
        q(4,:) = cpsi .* ctheta .* cphi - alpha * spsi .* stheta .* cphi;
        
    end
    
end % ea2q
