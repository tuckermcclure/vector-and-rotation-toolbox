function ea = dcm2ea(R, seq)

% dcm2ea  direction cosine matrix to Euler angles
%
% Convert a direction cosine matrix (or several) to the corresponding Euler
% angles with the given sequence.
% 
%   ea = dcm2aa(R, seq)
%   ea = dcm2aa(R) % Defaults to [3 2 1] sequence
%
% Inputs:
%
% R    Direction cosine matrices (3-by-3-by-n)
% seq  Sequence for Euler angles, specified as, e.g., [3 1 2] or 'zxy'
% 
% Outputs:
%
% ea   Euler angles (radians, 3-by-n)

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

        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)
            
            ea(2,:) = acos(R(i,i,:));
            ind     = ea(2,:) == 0 | ea(2,:) == pi;
            if alpha > 0
                ea(1, ind) = atan2(R(j,k,ind),   R(j,j,ind));
                ea(1,~ind) = atan2(R(i,j,~ind), -R(i,k,~ind));
                ea(3,~ind) = atan2(R(j,i,~ind),  R(k,i,~ind));
            else
                ea(1, ind) = atan2(-R(j,k,ind),   R(j,j,ind));
                ea(1,~ind) = atan2( R(i,j,~ind),  R(i,k,~ind));
                ea(3,~ind) = atan2( R(j,i,~ind), -R(k,i,~ind));
            end
            
        % Otherwise, write out the loop.
        else
            
            if alpha > 0
                for c = 1:size(R, 3)
                    ea(2,c) = acos(R(i,i,c));
                    if ea(2,c) == 0 || ea(2,c) == pi
                        ea(1,c) = atan2(R(j,k,c), R(j,j,c));
                    else
                        ea(1,c) = atan2(R(i,j,c), -R(i,k,c));
                        ea(3,c) = atan2(R(j,i,c),  R(k,i,c));
                    end
                end
            else
                for c = 1:size(R, 3)
                    ea(2,c) = acos(R(i,i,c));
                    if ea(2,c) == 0 || ea(2,c) == pi
                        ea(1,c) = atan2(-R(j,k,c), R(j,j,c));
                    else
                        ea(1,c) = atan2(R(i,j,c), R(i,k,c));
                        ea(3,c) = atan2(R(j,i,c), -R(k,i,c));
                    end
                end
            end
            
        end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
        
        % If running in regular MATLAB, vectorize.
        if isempty(coder.target)
            
            if alpha > 0
                ea(2,:) = asin(R(k,i,:));
                ind = ea(2,:) == pi/2;
                ea(1, ind) = atan2( R(j,k,ind),  R(j,j,ind));
                ea(1,~ind) = atan2(-R(k,j,~ind), R(k,k,~ind));
                ea(3,~ind) = atan2(-R(j,i,~ind), R(i,i,~ind));
            else
                ea(2,:) = asin(-R(k,i,:));
                ind = ea(2,:) == pi/2;
                ea(1, ind) = atan2(-R(j,k,ind),  R(j,j,ind));
                ea(1,~ind) = atan2( R(k,j,~ind), R(k,k,~ind));
                ea(3,~ind) = atan2( R(j,i,~ind), R(i,i,~ind));
            end

        % Otherwise, write out the loop.
        else
            
            if alpha > 0
                for c = 1:size(R, 3)
                    ea(2,c) = asin(R(k,i,c));
                    if ea(2,c) == pi/2
                        ea(1,c) = atan2(R(j,k,c), R(j,j,c));
                    else
                        ea(1,c) = atan2(-R(k,j,c), R(k,k,c));
                        ea(3,c) = atan2(-R(j,i,c), R(i,i,c));
                    end
                end
            else
                for c = 1:size(R, 3)
                    ea(2,c) = asin(-R(k,i,c));
                    if ea(2,c) == pi/2
                        ea(1,c) = atan2(-R(j,k,c), R(j,j,c));
                    else
                        ea(1,c) = atan2(R(k,j,c), R(k,k,c));
                        ea(3,c) = atan2(R(j,i,c), R(i,i,c));
                    end
                end
            end
            
        end
        
    end
    
end % dcm2ea
