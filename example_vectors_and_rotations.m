%% Examples for Vectors and Rotations Toolbox
%
% This file shows examples of using this toolbox to manipulate vectors and
% rotations in various parameterizations. Once one knows how to use each
% rotation and vector type, the remaining functions become intuitive.
%
% These examples assume you've read the readme already. If not, start
% there.

%% Rotation Conversions
% 
% We'll start with functions for rotating from one representation of a
% rotation to another.

%%
% Let's suppose frame B is rotated from frame A by pi/4 about the y axis.
% We can express this rotation in several ways, but let's start with the
% axis and angle directly. Here's the axis (note that vectors should always
% be 3-by-n).

r = [0; 1; 0];

%%
% And the angle of frame B with respect to (wrt) A:

theta = pi/4;

%%
% If something were along the x axis in A, then we'd expect to see it
% equally on the x and z axes of B. Let's make sure that happens by
% converting the axis and angle to a direction cosine matrix (DCM) and
% converting a vector known in A to the B frame.

v_A  = [1; 0; 0];               % a vector in the A frame
R_BA = aa2dcm(theta, r)         % rotation matrix of B wrt A
v_B  = R_BA * v_A               % the vector, as seen in B

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
% We can express the rotation as a rotation quaternion (Euler-Rodrigues 
% symmetric parameters, with the scalar as the fourth element of q).

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
% Modified Rodrigues parameters are not as intuitive as the other forms,
% but they have their uses. Let's create them for this rotation:

p_BA = aa2mrp(theta, r)

%%
% We could have used the quaterion as well:

g_BA = q2mrp(q_BA)

%%
% And then back to the axis and angle, DCM, and quaternion:

[theta, r] = mrp2aa(g_BA)
R_BA = mrp2dcm(g_BA)
q_BA = mrp2q(g_BA)

%%
% We can also scale the MRPs by a constant factor. For instance, scaling
% them by a factor of 4 causes the MRPs to approach the rotation vector for
% small angles. For instance, let's look at three small rotations aboud
% three different axes:

theta = [0.01, 0.1, 0.5];
r     = [   1,   0,   0; ...
            0,   1,   0; ...
            0,   0,   1];

%%
% The rotation vectors are:

[theta(1) * r(:,1), theta(2) * r(:,2), theta(3) * r(:,3)]

%%
% Let's create the scaled MRPs for each of the three rotations (notice how
% we can pass in 1-by-n and 3-by-n values and get the vectorized results).

p = aa2mrp(theta, r, 4)

%%
% A scaling factor of 4 is clearly useful.
%
% Just like q and -q refer to the same rotation for quaternions, so too do
% the modified Rodrigues parameters have an alternate, or "shadow",
% representation.

s = mrpalt(p, 4)

%%
% And we can convert back with the same function. It doesn't need to "know"
% that it's now operating on the shadow set; the operations are the same.

p = mrpalt(s, 4)

%%
% In fact, neither really "is" the shadow set; they're both shadows of each
% other. And we can convert them to, e.g., the same rotation quaternion:

q1 = mrp2q(p, 4)
q2 = mrp2q(s, 4)

%%
% (They differ by sign, but q and -q refer to the same rotation for 
% rotation quaternions.)

%% Operations with Rotations
% 
% Direction cosine matrices are very easy to use. For instance, multiple
% rotations can be created by simply multiplying them together. If R_BA is
% the rotation of frame B wrt frame A, and R_CB is the rotation of frame C
% wrt frame B, then the composite rotation of C wrt A is:
% 
% R_CA = R_CB * R_BA
% 
% Let's check. Suppose B is rotated from A by a rotation of pi/3 about some
% axis, and then C is rotated from B by 2*pi/3 about the same axis. The
% composite rotation angle should be pi.

Rx(2*pi/3) * Rx(pi/3)

%%
% Let's try that again, rotating around some random vector.

r = randunit(3)
% r = [1; 1; 0] / sqrt(2)
% r = [1; 1; 1] / sqrt(3)
R_BA = aa2dcm(pi/3,   r);
R_CB = aa2dcm(2*pi/3, r);
R_CA = R_CB * R_BA

%%
% What's the composite angle and axis of rotation?

[theta, r] = dcm2aa(R_CA)

%%
% It's pi/3 + 2*pi/3 = pi about our original axis, like we'd expect.

%%
% For quaternions and modified Rodrigues parameters, the analogous 
% arithmetic is encapsulated in qcomp and mrpcomp.

q_BA = aa2q(  pi/3, r);
q_CB = aa2q(2*pi/3, r);
q_CA = qcomp(q_CB, q_BA)
[theta, r] = q2aa(q_CA)

p_BA = aa2mrp(  pi/3, r);
p_CB = aa2mrp(2*pi/3, r);
p_CA = mrpcomp(p_CB, p_BA)
[theta, r] = mrp2aa(p_CA)

%% TODO
% qrot
% qinv
% qpos
% qdiff, qerr, mrpdiff, mrperr
% qdot
% qinterp
% cross3, crs3, normalize, vmag, vmag2
% rae2xyz, xyz2rae
% vecplot
