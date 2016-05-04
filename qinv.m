function qi = qinv(q)

% qinv
%
% Inverts the input quaternion(s), representing the opposite rotation(s).

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    qi = [q(1,:); -q(2:4,:)];
    
end % qinv
