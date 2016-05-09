function ea = dcm2ea(R, seq)

% dcm2ea
%
% 

% Copyright 2016 An Uncommon Lab

%#codegen

    % Default to the aerospace sequence.
    if nargin < 2 || isempty(seq), seq = [3 2 1]; end;
    
    % Make sure it's a valid Euler angle sequence.
    assert(size(R, 1) == 3 && size(R, 2) == 3, ...
           '%s: The axes must be 3-by-n.', mfilename);
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
    
    % Pre-allocate.
    ea = zeros(3, size(R, 3), class(R));

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

        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)
            
            ea(1,:) = atan2(-alpha * R(i,j,:), R(i,k,:));
            ea(2,:) = acos(R(i,i,:));
            ea(3,:) = atan2(alpha * R(j,i,:), R(k,i,:));
            
        % Otherwise, write out the loop.
        else
            
            ea = zeros(3, size(R, 3), class(R));
            for k = 1:size(R, 3)
                ea(1,k) = atan2(-alpha * R(i,j,k), R(i,k,k));
                ea(2,k) = acos(R(i,i,k));
                ea(3,k) = atan2(alpha * R(j,i,k), R(k,i,k));
            end
            
        end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
        
        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)
            
            ea(1,:) = atan2(R(k,j,:), -alpha * R(k,k,:));
            ea(2,:) = asin(R(k,i,:)/alpha);
            ea(3,:) = atan2(R(j,i,:), -alpha * R(i,i,:));

        % Otherwise, write out the loop.
        else
            
            ea = zeros(3, size(R, 3), class(R));
            for k = 1:size(R, 3)
                ea(1,k) = atan2(R(k,j,k), -alpha * R(k,k,k));
                ea(2,k) = asin(R(k,i,k)/alpha);
                ea(3,k) = atan2(R(j,i,k), -alpha * R(i,i,k));
            end
            
        end
        
    end
    
end % dcm2ea
