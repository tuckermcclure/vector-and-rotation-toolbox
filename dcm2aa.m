function [theta, r] = dcm2aa(a)

% [ax, an] = dcm2aa(a)
%
% Kuipers, Jack B., _Quaternions and Rotation Sequences: A Primer with
% Applications to Orbits, Aerospace, and Virtual Reality_. Princeton:
% Princeton University Press. 1999. Book. Page 66.

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    theta = acos(0.5*(trace(a) - 1));
    if theta < eps
        r = [0; 0; 0];
    else
        r = normalize([a(2, 3) - a(3, 2); ...
                       a(3, 1) - a(1, 3); ...
                       a(1, 2) - a(2, 1)]);
    end

end % dcm2aa
