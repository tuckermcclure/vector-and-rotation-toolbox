%% Examples for Vectors and Rotations Toolbox
%
% This file shows examples of using this toolbox to manipulate vectors and
% rotations (in various parameterizations). The functions are consistent,
% so once one knows how to use, e.g., a quaternion in one function, it is
% the same everywhere.

%%
% Let's suppose frame B is rotated from frame A by pi/4 about the y axis.
% We can express this rotation in several ways, but let's start with the
% axis and angle directly. Here's the axis (note that vectors should always
% be 3-by-n).

r = [0; 1; 0];

%%
% And the angle of B with respect to (wrt) A:

theta = pi/4;

%%
% If something were along the x axis in A, then we'd expect to see it
% equally on the x and z axes of B. Let's make sure that happens by
% converting the axis and angle to a direction cosine matrix (DCM) and
% translate a vector known in A to the B frame.

r_A  = [1; 0; 0];               % a vector in the A frame
R_BA = aa2dcm(theta, r)         % rotation matrix of B wrt A
r_B  = R_BA * r_A               % the vector, as seen in B

%%
% That looks right. Of course, rotations about x, y, or z are common, so
% there are special functions (Rx, Ry, and Rz) for those. Let's make sure
% Ry agrees with aa2dcm.

R_BA = Ry(theta)

%%
% We can get the axis and angle back from the DCM. Note that the angle is
% returned first; this is for convenience, allowing the function to be used
% to return only the angle of rotation, which saves some calculations.

[theta, r] = dcm2aa(R_BA)

%%
% We can express the rotation as a quaternion too.

q_BA = aa2q(theta, r) % quaternion of B wrt A

%%
% We can also calculate the quaternion from the rotation matrix.

q_BA = dcm2q(R_BA)

%%
% Naturally, the quaternion should convert back to the rotation matrix and
% to the original axis and angle.

R_BA = q2dcm(q_BA)
[theta, r] = q2aa(q_BA)

%%
% Our rotation about the y axis is easy to understand as an Euler angle.
% Using the [3 2 1] (z y x) sequence of Euler angles (common), we should
% have Euler angles that are 0 around the 3 and 1 axes (z and x) and pi/4
% around the 2 axis (y).

ea_BA = q2ea(q_BA, [3 2 1])

%%
% In fact, because the [3 2 1] sequence is common, it's the default, so we
% can omit it.

ea_BA = q2ea(q_BA)

%%
% We could have calculated the Euler angles from the DCM as well.

ea_BA = dcm2ea(R_BA)

%%
% We can recover the quaternion and DCM from the Euler angles too:

q_BA = ea2q(ea_BA)
R_BA = ea2dcm(ea_BA)

%%
% Generalized Rodrigues parameters are not as intuitive as the other forms,
% but they have their uses. Let's create the Gibbs vector for this
% rotation:

g_BA = aa2grp(theta, r, 0, 1)

%%
% We could have used the quaterion as well:

g_BA = q2grp(q_BA, 0, 1)

%%
% And then back to the axis and angle, DCM, and quaternion:

[theta, r] = grp2aa(g_BA, 0, 1)
R_BA = grp2dcm(g_BA, 0, 1)
q_BA = grp2q(g_BA, 0, 1)

%%
% And the modified Rodrigues parameters:

mrp_BA = q2grp(q_BA, 1, 1)
[theta, r] = grp2aa(mrp_BA, 1, 1)
R_BA = grp2dcm(mrp_BA, 1, 1)
q_BA = grp2q(mrp_BA, 1, 1)
