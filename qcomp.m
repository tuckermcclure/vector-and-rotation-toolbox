function c = qcomp(a, b)

% qcomp
%
% Composition (multiplication) of two quaternions. Note that this function
% preserves the order of multiplied direction cosine matrices, and so the
% order is backwards from Hamilton's quaternion multiplication.
%
% This function takes the convention that the first element of the
% quaternion is the scalar part and the subsequent three are the vector
% parts.
%
% q_CA = qcomp(q_CB, q_BA);

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    if size(a, 1) ~= 4 && size(a, 2) == 4, a = a.'; end;
    if size(b, 1) ~= 4 && size(b, 2) == 4, b = b.'; end;
    assert(size(a, 1) == 4 && size(b, 1) == 4, ...
           '%s: The quaternions must be 4-by-n.', mfilename);

    % c = ([-crs3(a(1:3)), a(1:3); -a(1:3).', 0] + a(4) * eye(4)) * b;
    c = [ a(4,:).*b(1,:) + a(3,:).*b(2,:) - a(2,:).*b(3,:) + a(1,:).*b(4,:); ...
         -a(3,:).*b(1,:) + a(4,:).*b(2,:) + a(1,:).*b(3,:) + a(2,:).*b(4,:); ...
          a(2,:).*b(1,:) - a(1,:).*b(2,:) + a(4,:).*b(3,:) + a(3,:).*b(4,:); ...
         -a(1,:).*b(1,:) - a(2,:).*b(2,:) - a(3,:).*b(3,:) + a(4,:).*b(4,:)];
     
end % qcomp
