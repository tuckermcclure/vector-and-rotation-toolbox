function R = aa2dcm(ax, angle)

% aa2dcm
%
% Convert axis-angle notation to a direction cosine matrix.
%
% Inputs:
%
% ax     Unit axis of rotation (3-by-1)
% angle  Angle of frame A wrt frame B
%
% Outputs:
%
% R      Direction cosine matrix representing A wrt B (v_A = R * v_B)

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % M = eye(3)*cos(an) + (1-cos(an))*(ax*ax') - crs(ax)*sin(an);

    % TODO: Vectorize for multiple axis-angle inputs
    c   = cos(angle);
    sax = sin(angle) * ax;
    R = ((1 - c) * ax) * ax.';
    R(1, 1) = R(1, 1) + c;
    R(2, 2) = R(2, 2) + c;
    R(3, 3) = R(3, 3) + c;
    R(1, 2) = R(1, 2) + sax(3);
    R(1, 3) = R(1, 3) - sax(2);
    R(2, 3) = R(2, 3) + sax(1);
    R(2, 1) = R(2, 1) - sax(3);
    R(3, 1) = R(3, 1) + sax(2);
    R(3, 2) = R(3, 2) - sax(1);
    
end % aa2dcm
