function q = qinv(q)

% QINV  Rotation quaternion inverse
%
% Inverts the input rotation quaternion(s), representing the opposite
% rotation(s). The scalar term is not modified, but the axis of rotation is
% reversed. This allows the scalar part to preserve its sign, therefore
% preserving whether this rotation refers to the "near" rotation or the
% "long way around".
%
%   qi = QINV(q)
%
% Inputs: 
% 
% q   Quaternions to invert (4-by-n)
%
% Outputs:
%
% qi  Inverted quaternions (4-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(q, 1) ~= 4 && size(q, 2) == 4, q = q.'; end;
    assert(size(q, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % Invert the vector part.
    q(1:3,:) = -q(1:3,:);
    
end % qinv
