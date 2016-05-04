function q = grp2q(p, a, f)

% grp2q
%
% Convert generalized Rodriguez parameters (GRP) to a quaternion. 
% Generally, the parameters a and f are related such that f = 2 * (a + 1), 
% but this need not always be the case. The parameter a must be between 0 
% and 1, inclusively. This function is vectorized to accept 3-by-n sets of 
% n Rodriguez parameters and will return a 4-by-n set of quaternions.
%
% When a == 1 and f == 4, then small GRPs reduce to the "rotation angles".
% For example:
%
% q = grp2q([0.01; 0; 0], 1, 4)
%
% gives [0.005; 0; 0; 1]. Since the first quaternion element is
% sin(angle/2), and since sin(angle/2) approximately equals angle/2, we can
% see that angle/2 == 0.005, so angle approximately equals 0.01, which was
% the small value used to construct the original GRP.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Set some defaults.
    if nargin < 2, a = 1; end;
    if nargin < 3, f = 4; end;

    q         = zeros(4, size(p, 2));
    dp2       = sum(p.^2, 1);
    q(1, :)   =    (-a * dp2 + f * sqrt(f^2 + (1-a^2) * dp2)) ...
                ./ (f^2 + dp2);
	temp      = (a + q(1, :))/f;
	q(2, :)   = temp .* p(1, :);
	q(3, :)   = temp .* p(2, :);
	q(4, :)   = temp .* p(3, :);
    
end
