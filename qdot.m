function qd = qdot(q, w, k, dt)

% qdot
%
% Quaternion derivative which maintains the unit norm of the quaternion
% during simulation using the "trick" from [Zipfel 372].
%
%    qd = qdot(q, w)
%    qd = qdot(q, w, k)
%    qd = qdot(q, w, [], dt)
%
% To maintain the unit norm of the quaternion, k*dt should be less than 1,
% where k is the orthonormality correction factor. The default value is 
% 0.5.
%
% This function takes the convention that the first element of the
% quaternion is the scalar part and the subsequent three are the vector
% parts.

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set default orthonormality correction factor.
    if nargin < 3, k = 0.5; end;
    if nargin == 4 && isempty(k), k = 0.5/dt; end;

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);
    assert(size(w, 1) == 3, ...
           '%s: The rotation rates must be 3-by-n.', mfilename);
    assert(all(size(k) == 1) && k >= 0, ...
           '%s: The rotation rates must be 3-by-n.', mfilename);
        
    % Propagate.
    % qd = 0.5 * [-crs3(w), w; -w.', 0] * q;
    qd      = zeros(4, size(q, 2), class(q));
    qd(1,:) =                   w(3,:).*q(2,:) - w(2,:).*q(2,:) + w(1,:).*q(4,:);
    qd(2,:) = -w(3,:).*q(1,:)                  + w(1,:).*q(3,:) + w(2,:).*q(4,:);
    qd(3,:) =  w(2,:).*q(1,:) - w(1,:).*q(2,:)                  + w(3,:).*q(4,:);
    qd(4,:) = -w(1,:).*q(1,:) - w(2,:).*q(2,:) - w(3,:).*q(3,:);
    qd      = 0.5 * qd;

    % Preserve unit norm in simulation.
    % qd = qd + k * (1 - sum(q.^2)) * q;
    if k ~= 0
        s = q(1,:).*q(1,:) + q(2,:).*q(2,:) + q(3,:).*q(3,:) + q(4,:).*q(4,:);
        s = k * (1 - s);
        qd(1,:) = qd(1,:) + s .* q(1,:);
        qd(2,:) = qd(2,:) + s .* q(2,:);
        qd(3,:) = qd(3,:) + s .* q(3,:);
        qd(4,:) = qd(4,:) + s .* q(4,:);
    end

    % Alternately (for reference only):
    % 
    %   qd = 0.5 * [crs3(q(1:3)) + q(4)*eye(3); -q(1:3).'] * w;
    % 
    
end % qdot
