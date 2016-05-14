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
           '%s: The DCMs must be 3-by-3-by-n.', mfilename);
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

%         % If running in regular MATLAB, vectorize.
%         if isempty(coder.target)
%             
%             ea(2,:) = acos(R(i,i,:));
%             
%             % TODO: Vectorize:
%             
%         % Otherwise, write out the loop.
%         else
            
            for c = 1:size(R, 3)
                ea(2,c) = acos(R(i,i,c));
                if ea(2,c) == 0 || ea(2,c) == pi
                    ea(1,c) = atan2(alpha * R(j,k,c), R(j,j,c));
                else
                    ea(1,c) = atan2(R(i,j,c), -alpha * R(i,k,c));
                    ea(3,c) = atan2(R(j,i,c),  alpha * R(k,i,c));
                end
            end
            
%         end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
        
%         % If running in regular MATLAB, vectorize.
%         if isempty(coder.target)
%             
%             ea(2,:) = asin(R(k,i,:)/alpha);
%             % TODO: Vectorize
% 
%         % Otherwise, write out the loop.
%         else
            
            for c = 1:size(R, 3)
                ea(2,c) = asin(alpha * R(k,i,c));
                if ea(2,c) == pi/2
                    ea(1,c) = atan2(alpha * R(j,k,c), R(j,j,c));
                else
                    ea(1,c) = atan2(-alpha * R(k,j,c), R(k,k,c));
                    ea(3,c) = atan2(-alpha * R(j,i,c), R(i,i,c));
                end
            end
            
%         end
        
    end
    
end % dcm2ea
