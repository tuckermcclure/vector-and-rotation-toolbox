function qd = qdot(q, w, k)

% qdot
%
% Quaternion derivative which maintains the unit norm of the quaternion
% during simulation using the "trick" from [Zipfel 372].
%
%    qd = qdot(q, w, k)
%
% To maintain the unit norm of the quaternion, k*dt should be less than 1,
% where k is the orthonormality correction factor. The default value is 
% 0.5.
%
% This function takes the convention that the first element of the
% quaternion is the scalar part and the subsequent three are the vector
% parts.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Set default orthonormality correction factor.
    if nargin < 3, k = 0.5; end;

    % Propagate.
    qd = 0.5 * [0, -w.'; w, -skew(w)] * q;
        
    % Preserve unit norm in simulation.
    qd = qd + k * (1 - sum(q.^2)) * q;

    % Alternately (for reference only):
    % 
    %   qd = 0.5 * [skew(q(1:3)) + q(0)*eye(3); -q(1:3).'] * w;
    % 
    
end
