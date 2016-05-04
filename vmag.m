function v_mag = vmag(v)

% vmag
%
% Calculate the 2-norm magnitude(s) of the input vector(s).
%
% See also: normalize

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    v_mag = sqrt(sum(v.^2, 1));

end % vmag
