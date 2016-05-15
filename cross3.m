function c = cross3(a, b)

% CROSS3  Cross product of two (sets of) vectors
% 
% Crosses each column of the first input with the corresponding column of
% the second input, where each input is 3-by-n. This is a little better in 
% generated C code than 'cross' and is specialized for 3-dimensional 
% vectors.
%
%   c = CROSS3(a, b)
%
% Inputs:
% 
% a  Left-hand-side vectors (3-by-n)
% b  Right-hand-side vectors (3-by-n)
%
% Outputs:
%
% c  Cross product of columns of a with corresponding columns of b (3-by-n)

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
