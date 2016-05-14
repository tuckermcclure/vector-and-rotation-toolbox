Vector and Rotation Tools
=========================

This repository contains files for using 3D vectors and rotations in MATLAB. The functions contain vectorized code for speed in MATLAB *and* code that generates good C code when used with Simulink or MATLAB Coder.

All rotation operations correspond to _frame_ rotations. Vector rotations are the opposite (inverses) of frame rotations.

It supports MATLAB R2011a and newer.



TODO
----
Finish up vectorized/codegen code.
Re-test.
Update the headers.
Examples.
Put on aul? Convert to doc_?


Axis-Angle Representations
--------------------------



Direction Cosine Matrices
-------------------------



Quaternions (Euler-Rodrigues Symmetric Parameters)
--------------------------------------------------

When most people speak of quaternions as rotations, they're really referring to Euler-Rodrigues symmetric parameters (ERSP). These can be conveniently represented as unit quaternions, and a subset of quaternion arithmetic lines up well with operations on these ERSPs. However, there's one caveat: Hamilton's original notion of quaternion multiplication results in operations that are backwards from modern conventions regarding rotations. This becomes cumbersome when dealing with rotations. In order to be consistent with modern sources and to distinguish the "quaternions" used in this toolbox from Hamilton's more general form, this toolbox makes the following distinctions:

First, "quaterions" are also referred to in this toolbox as "Euler-Rodrigues symmetric parameters", which is a more specific name.

Second, instead of "quaternion multiplication", which is backwards to conventions, this toolbox implements "quaternion composition" (qcomp) in a manner consistent with rotation conventions. Calling it "composition" acts as a red flag, to indicate that some is different from Hamilton's quaternion multiplication.

Third, the scalar part of the quaternion is stored as the fourth element of the vector. In this way, q(1:3) lines up with the vector part [q_1 q_2 q_3]^T and q(4) is the scalar. This is especially useful in a 1-indexed language such as MATLAB, because the indices line up with vector axes.

The function to invert a rotation quaternion lines up with Hamilton's quaternion conjugate, but the name "qinv" is used for clarity of intention.

Quaternions q and -q refer to the same rotation, and this is a useful property. No attempt is made to "ensure" that a quaternion is in its "positive" form (that the scalar part is positive). However, this can be accomplished with the qpos function.

Operations on quaternions (ERSPs):

    qcomp    Calculate rotation resulting from two quaternion rotations
    qdot     Calculate the time derivative of a quaternion
    qinterp  Interpolate between quaternions
    qinv     Invert a quaternion
    qpos     Return the "positive" form of the quaternion
    qrot     Rotate a vector using a quaternion


Differences from the Aerospace Toolbox from The MathWorks:

1. The scalar is the fourth element, whereas it is the first in that toolbox.
2. Quaternion "composition" is backwards from quaternion multiplication in that toolbox.
3. qinv should be used instead of qcomp.
4. Additional, the functions in this toolbox are both better vectorized for use in MATLAB and better in C code generation.

Euler Angles
------------

This toolbox converts to and from Euler angles. There are 12 possible Euler angle sequences. One particularly common sequence is the 3-2-1 or aerospace sequence. This says to first rotate about the 3 axis, then about the new 2 axis, then about the new 1 axis, by the given angles. The 3-2-1 sequence is used as a default and will result in the most efficient operations (e.g., ea2q(ea)). However, a custom sequence can be specified in functions that deal with Euler angles (e.g., ea2q(ea, [3 1 3])), and these more general forms require more runtime and RAM.


Generalized Rodrigues Parameters
--------------------------------

There are many variations on 3-element Rodrigues parameters, including the original (commonly called the Gibbs vector) and the modified Rodrigues parameters. These can all be represented by the generalized Rodrigues parameters, using appropriate values for a and f in the parameterization.

grp = f / (a + q_0) * q_123

For the Rodrigues parameters or Gibbs vector, f = 1 and a = 0.

For the modified Rodrigues parameters, f = 1 and a = 1.

When a = 1 and f = 4, the GRPs correspond to the rotation vector for small angles of rotation. These values are used by default.


Symbols
-------

    ea      Euler angles
    seq     Euler angle rotation sequence, specified as [3 1 2] or 'zxy'
    g       Gibbs vector
    p       Generalized Rodrigues parameters
    a       Generalized Rodrigues parameters denominator offset (default 1)
    f       Generalized Rodrigues parameters scaling factor (default 4)
    q       Quaternion
    q123    Vector part of quaternion
    q4      Scalar part of quaternion
    R       Direction cosine matrix
    r       Axis of rotation
    theta   Angle of rotation


Resources
---------

Shuster, Malcolm D. "A Survey of Attitude Representations." _The Journal of Astronautical Sciences. Vol. 41. No. 4. October-December 1993. 439-517. http://malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf

??? http://dnc.tamu.edu/drjunkins/yearwise/1996/Archival/JAS_44_1_1996_stereographic.pdf


Copyright 2016 An Uncommon Lab.
