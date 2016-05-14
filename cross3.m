function c = cross3(a, b)

% cross3
% 
% Crosses 3-dimensional vector(s) a (3-by-n) with b (3-by-n). This is a
% little better in generated C code than 'cross' and can handle vectorized 
% sets of vectors.
% 
% cross3(a, b) == cross(a, b)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check dimensions.
    assert(size(a, 1) == 3 && size(b, 1) == 3, ...
           '%s: The vectors must be 3-by-n.', mfilename);
    assert(size(a, 2) == size(b, 2), ...
           ['%s: The number of input axes must match the number of ' ...
            'input angles.'], mfilename);

    c = [a(2,:) .* b(3,:) - a(3,:) .* b(2,:); ...
         a(3,:) .* b(1,:) - a(1,:) .* b(3,:); ...
         a(1,:) .* b(2,:) - a(2,:) .* b(1,:)];

end % cross3
