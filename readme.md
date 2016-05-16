Vector and Rotation Tools
=========================

This repository contains files for using 3D vectors and rotations in MATLAB. The functions contain vectorized code for speed in MATLAB *and* code that generates good C code when used with Simulink or MATLAB Coder. Rotation types include direction cosine matrices, rotation quaternions (Euler-Rodrigues symmetric parameters), modified Rodrigues parameters, axis-angle representations, and Euler angles. These are all discussed more below.

All rotation operations correspond to frame rotations. That is, they rotate the viewpoint, not the thing being view. See the quick example below for more.

It supports MATLAB R2011a and newer.

TODO
----
Examples.
Put on aul? Convert to doc_?


Quick Example
-------------

To see how the rotations rotate the viewpoint and not the vector, consider:

  % In frame A, let's say the vector is aligned with the x axis.
  v_A = [1; 0; 0];

  % Frame B is rotated from frame A by a 45 degree rotation about the y axis.
  R_BA = Ry(pi/4);

  % We therefore expect the vector to appear on the positive x and z axes when viewed in frame B. Is it?
  v_B = R_BA * v_A
  
  v_B =
      0.7071
           0
      0.7071

Vector rotations are the opposite (inverses) of frame rotations. For instance, to rotate a vector by 45 degrees around the y axis, we can use the transpose of the rotation matrix (the transpose of a rotation matrix is its inverse):

  v         = [1; 0; 0];
  v_rotated = Ry(pi/4).' * v

  v_rotated =
      0.7071
           0
     -0.7071


Axis-Angle Representations
--------------------------

All rotations can be specified as a unique, right-handed rotation axis and corresponding angle of rotation between 0 and 2*pi. That is, any rotation can be described as a single rotation about some fixed axis. Of course, when the rotation angle is 0, then the rotation axis arbitrary; any function that returns a rotation axis will use therefore use [1; 0; 0] when the rotation angle is 0.

Axis-Angle functions:

  aa2dcm   Convert to a direction cosine matrix.
  aa2mrp   Convert to modified Rodrigues parameters.
  aa2q     Convert to a rotation quaternion (Euler-Rodrigues symmetric parameters).
  aashort  Return the smallest angle of rotation and corresponding axis.
  
All functions that accept or return axis-angle representations use the angle first and the axis second. This can be most efficient, for instance, when only the angles are needed as an output; the rotation axes need never be calculated.


Direction Cosine Matrices
-------------------------

Direction cosine matrices (rotation matrices) are the classic, unambiguous, and easy-to-use rotation representation. Multiplying a DCM with a vector rotates the frame in which that vector is seen.

  dcm2aa  Convert to axis-angle notation.
  dcm2ea  Convert to Euler angles with the specified sequence.
  dcm2q   Convert to a rotation quaternion.

Each column has a unit 2-norm, and the cross product of the first two columns yields the third column.


Quaternions (Euler-Rodrigues Symmetric Parameters)
--------------------------------------------------

Rotation quaternions (Euler-Rodrigues symmetric parameters) can represent any rotation without singularity. Operations with quaternions are fast and generally stable. Further, their time derivatives are easy to calculate, and keeping a quaternion valid (with a unit 2-norm) is easy. For all of these reasons, quaternions are well suited to representing the orientation of a body over time in simulations. Functions for simulation and conversion between other rotation forms are included in this toolbox.

Perhaps the only drawback to quaternions is that they are not as intuitive for most people as Euler angles or direction cosine matrices.

In terms of the axis, r, and angle of rotation:

  q = [sin(theta/2) * r; cos(theta/2)];

Clearly, [0; 0; 0; 1] is the identity rotation (no rotation).

Note that quaternions q and -q refer to the same rotation, and this can be a useful property. No attempt is made to ensure that a quaternion is in its "positive" form (that the scalar part is positive). However, this can be accomplished with the qpos function when necessary.

Operations on quaternions (ERSPs):

    q2aa      Convert to axis-angle representation.
    q2dcm     Convert to a direction cosine matrix.
    q2ea      Convert to Euler angles with the specified sequence.
    q2mrp     Convert to the modified Rodrigues parameters.
    qcomp     Calculate rotation resulting from two quaternion rotations.
    qdiff     Calculate the difference of a rotation quaternion wrt another.
    qdot      Calculate the time derivative of a quaternion given a rotation rate.
    qerr      Calculate the rotation angle between two quaternions.
    qinterp   Interpolate between quaternions, given an independent variable.
    qinterpf  Interpolate between quaternions, given a fraction from one to the other.
    qinv      Invert a rotation quaternion (quaternion conjugate).
    qpos      Return the equivalent quaternions with positive scalar part.
    qrot      Rotate the frame for a vector using a quaternion.

Quaternion conventions differ from source to source, and in fact quaternions do not intrinsically have anything to do with rotations. It so happens that Euler-Rodrigues symmetric parameters, which were created for handling rotations and predate quaternions, line up well with a subset of operations on unit quaternions, and so quaternions were adopted for this purpose. However, there's one big caveat: Hamilton's original notion of quaternion multiplication results in operations that are backwards from modern conventions regarding rotations. This becomes cumbersome when dealing with rotations. In order to be consistent with modern sources and to distinguish the "quaternions" used in this toolbox from Hamilton's more general form, this toolbox takes the following conventions:

First, "quaterions" in this toolbox means "rotation quaternions", and these are also referred to as "Euler-Rodrigues symmetric parameters". This is only a semantic difference.

Second, instead of "quaternion multiplication", which is backwards to conventions, this toolbox implements "quaternion composition" (qcomp) in a manner consistent with rotation conventions. Calling it "composition" acts as a red flag, to indicate that something is different from Hamilton's quaternion multiplication.

Third, the scalar part of the quaternion is stored as the fourth element of the vector. In this way, q(1:3) lines up with the vector part [q_1 q_2 q_3]^T and q(4) is the scalar. This is especially useful in a 1-indexed language such as MATLAB, because the indices line up with vector axes.

The function to invert a rotation quaternion lines up with Hamilton's quaternion conjugate, but the name "qinv" is used for clarity of intention.

These conventions are consistent with the literature on using quaternions for rotations. See the references below. Notably, each of these conventions differs from those of the Aerospace Toolbox, which implements Hamilton's quaternion operations and are not intrinsically about rotations. In summary, the differences are:

1. The scalar is the fourth element, whereas it is the first in that toolbox.
2. Quaternion "composition" is backwards from quaternion multiplication in that toolbox.
3. qinv should be used instead of quatconj.
4. Functions in this toolbox are created to ensure that quaternions retain a unit 2-norm.
5. This toolbox expects multiple quaternions to be a 4-by-n matrix, whereas it is n-by-4 in that toolbox.
6. The functions in this toolbox are both faster in MATLAB and better for C code generation.


Euler Angles
------------

This toolbox converts to and from Euler angles. There are 12 possible Euler angle sequences. One particularly common sequence is the 3-2-1 sequence or "aerospace sequence". This says to first rotate about the 3 axis, then about the new 2 axis, then about the new 1 axis, by the given angles. This is also referred to as the yaw-pitch-roll sequence or heading-elevation-bank, and it is used as a default. However, any sequence can be provided in functions that deal with Euler angles (e.g., ea2q(ea, [3 1 3])). Euler angles are primarily used for human input, since they are fairly intuitive. However, they have many terrible properties (ambiguity, gimbal-lock, poor numerical qualities).

Euler angle functions:

  ea2dcm  Convert to a direction cosine matrix.
  ea2q    Convert to a quaternion.

Euler angle sequences must have a form like [i j i] or [i j k]. For instance, [i i j] would be an invalid rotation sequence. The angles are conventionally expected to have ranges of [-pi, pi), [-pi/2, pi/2), [0, 2*pi).


Modified Rodrigues Parameters
-----------------------------

Modified Rodrigues parameters represent a rotation as a 3-element vector. This is generally defined directly in terms of the rotation quaternion, q, as:

  mrp = 1 / (1 + q(4)) * q(1:3);
  
This can represent all rotation quaternions except for q = [0; 0; 0; -1], where there is a singularity. However, [0; 0; 0; -1] refers to a rotation of 2*pi (hence, no rotation), and so of course [0; 0; 0; 1] (which also means "no rotation") could have been used instead.

In fact, since q and -q refer to the same rotation, we see that there are generally two possible MRPs that refer to the same rotation:

  mrp1 =  1 / (1 + q(4)) * q(1:3);
  mrp2 = -1 / (1 - q(4)) * q(1:3);
  
One is called the "shadow set" of the other, and it does not matter which is considered the "original" and which is the "shadow set". They converge near [0; 0; 0], but are generally different. One can convert to the shadow set of the given MRPs using the mrpalt function. One will represent the "near" rotation, and the other will represent the "far" rotation (the long way around). When the 2-norm of the MRPs is less than 1, the rotation represents the "near" form. When a scaling factor, f, is used (see below), then MRPs represent the near rotation when the 2-norm is less than f.

Because the MRPs go to [0; 0; 0] for "no rotation", MRPs are commonly used as orientation differences or errors, where [0; 0; 0] would conveniently mean "no difference".

For small rotations, the MRPs approach (4 * theta * r), where theta and r are the rotation angle and axis. It's therefore common to use a scaled set of MRPs, for instance so that the scaled MRPs approach the rotation vector (theta * r). If desired, a scaling parameter, f, can be provided to all MRP functions.

  mrp = f / (1 + q(4)) * q(1:3)
  
By default, the scaling is 1, giving the traditional MRPs. A scaling of 4 is also common. Remember that if it is provided to any function, then it should always be provided when using that set of MRPs.

MRPs are nearly as versatile as rotation quaternions, and hence many operations are included:

  mrp2aa   Convert to axis-angle representation.
  mrp2dcm  Convert to direction cosine matrix.
  mrp2q    Convert to rotation quaternion.
  mrpalt   Calculate the shadow set for the given MRPs.
  mrpcomp  Calculate the rotation resulting from two sets of MRPs.
  mrpdiff  Calculate the difference between two sets of MRPs.
  mrperr   Calculate the rotation angle between two sets of MRPs.


Range-Azimuth-Elevation
-----------------------

This is a spherical, as opposed to Cartesian, representation of vectors. The convensions used in this toolbox are as follows:

The elevation angle, theta, measures the rotation from the x-y plane to the point in question.

The azimuth angle, psi, measures the rotation of the point from x about +z.

Range, r, measures the distance to the point.

In other words, to convert a point given in range-azimuth-elevation to Cartesian, you would start with a point at [r; 0; 0] and rotate it (not the frame, but the vector) about the +y axis by the elevation angle, theta. You would then rotate the result about the +z axis by the azimuth angle, psi.

   xyz = Rz(psi).' * Ry(theta).' * [r; 0; 0];

The angles, as always, are given in radians. The units of the range can be anything.


Vector Tools
------------

These include convenience functions for working with 3D vectors in MATLAB. For instance, the magnitudes of each vector (column) in a 3-by-n matrix can be computed with sqrt(sum(v.^2, 1)) in normal MATLAB, but it's easier to just write vmag(v), and vmag will also generate better code in Simulink and MATLAB Coder.

  cross3     Cross each column of input 1 with corresponding column of input 2.
  crs3       Create 3-by-3-by-n "cross product matrix", such that crs3(a) * b = cross3(a, b).
  normalize  Normalize each column of the input matrix.
  rae2xyz    Convert range-azimuth-elevation to Cartesian coordinates.
  randunit   Create random unit vector(s) of specified dimension.
  vecplot    Allows vecplot(x, ...) instead of plot(x(1,:), x(2,:), x(3,:), ...).
  vmag       Calculate magnitude (2-norm) of each column.
  vmag2      Calculate the square of the magnitude (2-norm) of each column.
  xyz2rae    Convet Cartesian coordinates to range-azimuth-elevation.

Symbols
-------

The following symbols are used throughout for consistency. They can always represent a single vector or rotation or n vectors or rotations.

  ea      Euler angles (3-by-n)
  f       Modified Rodrigues parameter scaling factor (default 1)
  p       Modified Rodrigues parameters (3-by-n)
  q       Quaternion (4-by-n)
  q123    Vector part of rotation quaternion (3-by-n)
  q4      Scalar part of rotation quaternion (1-by-n)
  R       Direction cosine matrix (3-by-3-by-n)
  r       Unit vector axis of right-handed rotation (3-by-n)
  rae     Range-azimuth-elevation (3-by-n)
  seq     Euler angle rotation sequence, specified as [3 1 2] or 'zxy'
  theta   Angle of rotation in radians (1-by-n)
  v       A general 3D vector (3-by-n)


Resources
---------

Shuster, Malcolm D. "A Survey of Attitude Representations." _The Journal of Astronautical Sciences_. Vol. 41. No. 4. October-December 1993. 439-517. http://malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf

Schaub, Hanspeter, and John L. Junkins. "Stereographic Orientation Parameters for Attitude Dynamics: A Generalization of the Rodrigues Parameters." _Journal of the Atronautical Sciences_. Vol. 44. No. 1. January-March 1996. 1-19. http://dnc.tamu.edu/drjunkins/yearwise/1996/Archival/JAS_44_1_1996_stereographic.pdf


Copyright 2016 An Uncommon Lab
