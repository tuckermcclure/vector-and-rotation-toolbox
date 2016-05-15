function v_hat = randunit(m, n)

% RANDUNIT  Creates random unit vectors
%
% Creates random unit vectors (m-by-n). This is a very simple convenience 
% function.
%
%   v_hat = RANDUNIT(m, n)
% 
% Inputs:
%
% m  Dimension of each vector (default is 3)
% n  Number of random unit vectors to create (default is 1)
%
% Outputs:
%
% v_hat  Matrix whose columns are the n random unit vectors (m-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Default to a 3-by-1 random vector.
    if nargin < 1, m = 3; end;
    if nargin < 2, n = 1; end;

    % Check dimensions.
    assert(isscalar(m) && isscalar(n), ...
           '%s: The input dimensions must be scalars.', mfilename);

    v_hat = normalize(randn(m, n));

end % randunit
