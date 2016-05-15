% Vectors and Rotations Toolbox
% Version 1.0 15-May-2016
%
% Axis-Angle Functions
% 
%   aa2dcm                        - Angle-axis to direction cosine matrix
%   aa2mrp                        - Angle-axis to modified Rodrigues parameters
%   aa2q                          - Angle-axis to quaternion
%   aashort                       - Shortest equivalent angle of rotation and corresponding axis
% 
% Direction Cosine Matrix Functions
% 
%   dcm2aa                        - Direction cosine matrix to angle-axis representation
%   dcm2ea                        - Direction cosine matrix to Euler angles
%   dcm2q                         - Direction cosine matrix to quaternion
%   Rx                            - Direction cosine matrix of rotation about +x
%   Ry                            - Direction cosine matrix of rotation about +y
%   Rz                            - Direction cosine matrix of rotation about +z
%
% Euler Angle Functions
% 
%   ea2dcm                        - Euler angles to direction cosine matrix
%   ea2q                          - Euler angles to rotation quaternion
% 
% Modified Rodrigues Parameter Functions
% 
%   mrp2aa                        - Modified Rodrigues parameters to angle-axis representation
%   mrp2dcm                       - Modified Rodrigues parameters to direction cosine matrix
%   mrp2q                         - Modified Rodrigues parameters to rotation quaternion
%   mrpalt                        - Shadow set of given MRPs
%   mrpcomp                       - Modified Rodrigues parameter composition
%   mrpdiff                       - Difference between two sets of modified Rodrigues parameters
%   mrperr                        - Angle between two sets of modified Rodrigues parameters
%
% Quaternion Functions
% 
%   q2aa                          - Rotation quaternion to angle-axis representation
%   q2dcm                         - Rotation quaternion to direction cosine matrix
%   q2ea                          - Rotation quaternion to Euler angles with the given sequence
%   q2mrp                         - Rotation quaternion to modified Rodrigues parameters
%   qcomp                         - Rotation quaternion composition
%   qdiff                         - Difference of one rotation quaternion wrt another
%   qdot                          - Quaternion derivative
%   qerr                          - Angle of one rotation quaternion wrt another
%   qinterp                       - Rotation quaternion interpolation, given independent variables
%   qinterpf                      - Rotation quaternion interpolation, given interpolation fraction
%   qinv                          - Rotation quaternion inverse
%   qpos                          - Positive form of the rotation quaternion
%   qrot                          - Vector rotation by rotation quaternion
% 
% Vector Functions
% 
%   cross3                        - Cross product of two (sets of) vectors
%   crs3                          - Cross product matrix
%   normalize                     - Safe normalization of the columns of the input matrix
%   rae2xyz                       - Range-azimuth-elevation to Cartesian coordinates
%   randunit                      - Creates random unit vectors
%   vecplot                       - Plot a 3-by-n vector without breaking it up
%   vmag                          - Magnitude (2-norm) of each vector (column) of the input
%   vmag2                         - Squares of magnitudes (2-norm) of each vector (column) of input
%   xyz2rae                       - Convert Cartesian points to range-azimuth-elevation
%
% Utilities
% 
%   build_vectors_and_rotations   - Builds MEX files for the various functions
%   example_vectors_and_rotations - Examples for Vectors and Rotations Toolbox
%
