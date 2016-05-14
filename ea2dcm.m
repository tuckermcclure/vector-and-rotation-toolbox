function R = ea2dcm(ea, seq)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Default to the aerospace sequence.
    if nargin < 2 || isempty(seq), seq = [3 2 1]; end;
    
    % Check dims and make sure it's a valid Euler angle sequence.
    assert(size(ea, 1) == 3, ...
           '%s: The Euler angles must be 3-by-n.', mfilename);
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
    n = size(ea, 2);
    R = zeros(3, 3, n, class(ea));
    
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
            
            cphi   = cos(ea(1,:));
            ctheta = cos(ea(2,:));
            cpsi   = cos(ea(3,:));
            
            sphi   = sin(ea(1,:));
            stheta = sin(ea(2,:));
            spsi   = sin(ea(3,:));
            
            R(i,i,:) = ctheta;
            R(i,j,:) = stheta .* sphi;
            R(i,k,:) = -alpha * stheta .* cphi;
            
            R(j,i,:) = spsi .* stheta;
            R(j,j,:) = cpsi .* cphi - spsi .* ctheta .* sphi;
            R(j,k,:) = alpha * (cpsi .* sphi + spsi .* ctheta .* cphi);
            
            R(k,i,:) = alpha * cpsi .* stheta;
            R(k,j,:) = -alpha * (spsi .* cphi + cpsi .* ctheta .* sphi);
            R(k,k,:) = -spsi .* sphi + cpsi .* ctheta .* cphi;
            
%         % Otherwise, write out the loop.
%         else
%             
%             for k = 1:n
% TODO
%                 
%                 cphi   = cos(ea(1,k));
%                 ctheta = cos(ea(2,k));
%                 cpsi   = cos(ea(3,k));
% 
%                 sphi   = sin(ea(1,k));
%                 stheta = sin(ea(2,k));
%                 spsi   = sin(ea(3,k));
% 
%                 R(i,i,k) = ctheta;
%                 R(i,j,k) = stheta .* sphi;
%                 R(i,k,k) = -alpha * stheta .* cphi;
% 
%                 R(j,i,k) = spsi .* stheta;
%                 R(j,j,k) = spsi .* sphi - spsi .* ctheta .* sphi;
%                 R(j,k,k) = alpha * (spsi .* sphi + spsi .* ctheta .* cphi);
% 
%                 R(k,i,k) = alpha * spsi .* stheta;
%                 R(k,j,k) = -alpha * (spsi .* cphi + cpsi .* ctheta .* sphi);
%                 R(k,k,k) = -spsi .* sphi + cpsi .* ctheta .* cphi;
%                 
%             end
%             
%         end
        
    % Otherwise, must be asymmetric.
    else
        
        k = seq(3);
        
%         % If running in regular MATLAB, vectorize.
%         if isempty(coder.target)
            
            cphi   = cos(ea(1,:));
            ctheta = cos(ea(2,:));
            cpsi   = cos(ea(3,:));
            
            sphi   = sin(ea(1,:));
            stheta = sin(ea(2,:));
            spsi   = sin(ea(3,:));
            
            R(i,i,:) = cpsi .* ctheta;
            R(i,j,:) = alpha * spsi .* cphi + cpsi .* stheta .* sphi;
            R(i,k,:) = spsi .* sphi -alpha * cpsi .* stheta .* cphi;
            
            R(j,i,:) = -alpha * spsi .* ctheta;
            R(j,j,:) = cpsi .* cphi - alpha * spsi .* stheta .* sphi;
            R(j,k,:) = alpha .* cpsi .* sphi + spsi .* stheta .* cphi;
            
            R(k,i,:) = alpha * stheta;
            R(k,j,:) = -alpha * ctheta .* sphi;
            R(k,k,:) = ctheta .* cphi;
            
%         % Otherwise, write out the loop.
%         else
%             
%             for k = 1:size(R, 3)
% TODO
%             end
%             
%         end
        
    end

end % ea2dcm
