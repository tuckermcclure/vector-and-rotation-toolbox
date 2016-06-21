function v1 = vadd(v1, v2)

% vadd
% 
% Adds two column vectors, potentially with implicit binary singleton
% expansion of the second input.
% 
%    c = vadd(a, b)
% 
% (Because this is a common operation, and bsxfun(...) is cumbersome.)
%
% Inputs:
%
% v1   An m-by-n set of column vectors
% v2   An m-by-1 or m-by-n set of column vectors to add to v1
%
% Outputs:
%
% v3   The sum v1 + v2

% Copyright 2016 An Uncommon Lab

%#codegen

    % Check that this makes sense.
    assert(size(v1,2) == size(v2,2) || size(v2,2) == 1, ...
           ['%s: The second input must have dimensions matching the ' ...
            'first or be a column vector.'], mfilename);
    assert(size(v1,1) == size(v2,1), ...
           '%s: The two inputs must have the same number of rows.', ...
           mfilename);

    % Add up each row. This will implicitly "expand" v2(k,:) if it is a
    % singleton.
    for k = 1:size(v1, 1)
        v1(k,:) = v1(k,:) + v2(k,:);
    end

end % vadd
