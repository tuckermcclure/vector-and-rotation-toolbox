function q = qprop(q, w, dt)

% QPROP  Quaternion propagation
%
% Discretely propagates a quaternion via its average rotation rate over a
% time step.
% 
%    q = QPROP(q, w, dt)
% 
% This function is vectorized to operate on numerous quaternions and 
% rotation rates simultaneously.
%
% Input:
%
% q   Quaternion to propagate (scalar last) (4-by-1 or 4-by-n)
% w   Rotation rate (rad/s) (3-by-1 or 3-by-n)
% dt  Time step (s) (scalar or 1-by-n)
%
% Output:
%
% q   Propagated quaternion (4-by-1 or 4-by-n)
% 

% Copyright 2016-2017 An Uncommon Lab

%#codegen

    [w, w_mag] = normalize(w);       % Rot. unit vector and speed
    w_mag      = 0.5 * w_mag .* dt;  % Half rotation angle
    swm        = sin(w_mag);
    qr         = [swm .* w(1,:); ... % Rotation quaternion
                  swm .* w(2,:); ...
                  swm .* w(3,:); ...
                  cos(w_mag)];
    q          = qcomp(qr, q);       % Updated quaternion
        
end % qprop
