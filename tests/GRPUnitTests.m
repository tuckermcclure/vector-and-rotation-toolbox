classdef GRPUnitTests < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%%%
% grpcomp %
%%%%%%%%%%%

function test_grpcomp(test)
    
    n   = 100;
    qa  = randunit(4, n);
    qb  = randunit(4, n);
    q   = qcomp(qa, qb);
    tol = 1e-9;
    
    % Gibbs
    a       = 0;
    f       = 1;
    pa      = q2grp(qa, a, f);
    pb      = q2grp(qb, a, f);
    p       = grpcomp(pa, pb, a, f);
    p_0     = q2grp(q, a, f);
    test.verifyEqual(p, p_0, 'AbsTol', tol);
                
    % MRP
    a       = 1;
    f       = 1;
    pa      = q2grp(qa, a, f);
    pb      = q2grp(qb, a, f);
    p       = grpcomp(pa, pb, a, f);
    p_0     = q2grp(q, a, f);
    p_0_alt = grpalt(p_0, a, f);
    test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                        | all(abs(p - p_0_alt) < tol, 1)));
    
    % GRP
    a        = 0.5;
    f        = 1;
    [pa, sa] = q2grp(qa, a, f);
    [pb, sb] = q2grp(qb, a, f);
    [p,       s]       = grpcomp(pa, pb, a, f, sa, sb);
    [p_0,     s_0]     = q2grp(q, a, f);
    [p_0_alt, s_0_alt] = grpalt(p_0, a, f, s_0); %#ok<ASGLU>
    test.verifyTrue(   all(all(abs(p(:,~s) - p_0(:,~s))    < tol, 1)) ...
                    && all(all(abs(p(:,s)  - p_0_alt(:,s)) < tol, 1)));
    
    % GRP (use default a and f, and we should never actually need s).
    pa      = q2grp(qa);
    pb      = q2grp(qb);
    p       = grpcomp(pa, pb);
    p_0     = q2grp(q);
    p_0_alt = grpalt(p_0);
    test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                        | all(abs(p - p_0_alt) < tol, 1)));

end % grpcomp

%%%%%%%%%%%
% grpdiff %
%%%%%%%%%%%

function test_grpdiff(test)
    
    n   = 10;
    q1  = randunit(4, n);
    q2  = randunit(4, n);
    q3  = qcomp(q1, qinv(q2));
    tol = 1e-9;
    
    % Gibbs
    a    = 0;
    f    = 1;
    p1   = q2grp(q1, a, f);
    p2   = q2grp(q2, a, f);
    p3   = grpdiff(p1, p2, a, f);
    p3_0 = q2grp(q3, a, f);
    test.verifyEqual(p3, p3_0, 'AbsTol', tol);
    
    % Check qerr while we're at it.
    theta   = grperr(p1, p2, a, f);
    theta_0 = qerr(q1, q2);
    test.verifyEqual(theta, theta_0, 'AbsTol', tol);
    
    % MRPs
    a        = 1;
    f        = 1;
    p1       = q2grp(q1, a, f);
    p2       = q2grp(q2, a, f);
    p3       = grpdiff(p1, p2, a, f);
    p3_0     = q2grp(q3, a, f);
    p3_alt_0 = grpalt(p3_0, a, f);
    test.verifyTrue(all(  all(abs(p3 - p3_0)     < tol, 1) ...
                        | all(abs(p3 - p3_alt_0) < tol, 1)));
    
    % GRPs
    a    = 0.5;
    f    = 3;
    p1   = q2grp(q1, a, f);
    p2   = q2grp(q2, a, f);
    p3   = grpdiff(p1, p2, a, f);
    p3_0 = q2grp(q3, a, f);
    test.verifyEqual(p3, p3_0, 'AbsTol', tol);
    
    % MRPs (random swaps)
    a        = 1;
    f        = 1;
    [p1, s1] = q2grp(q1, a, f);
    [p2, s2] = q2grp(q2, a, f);
    
    % Swap some indices.
    swap = logical(randi(2, 1, n) - 1);
    [p1(:,swap), s1(swap)] = grpalt(p1(:,swap), a, f, s1(swap));
    
    % Create the composition, noting the swaps.
    [p3, s3] = grpdiff(p1, p2, a, f, s1, s2);
    % p3 = grpdiff(p1, p2, a, f); % For a = 1, this doesn't really matter.
    
    % Test that s3 stayed with s1.
    test.verifyEqual(s1, s3);
    
    % After the composition, the MRPs may refer to "far" rotations. Figure
    % out if this is the case.
    far = vmag(p3) > f;
    
    p3_0     = q2grp(q3, a, f);    % Near rotations
    p3_alt_0 = grpalt(p3_0, a, f); % Far rotations
    test.verifyTrue(  all(all(abs(p3(:,~far) - p3_0(:,~far))     < tol, 1)) ...
                    & all(all(abs(p3(:, far) - p3_alt_0(:, far)) < tol, 1)));
                
    % GRPs (random swaps)
    a        = 0.5;
    f        = 3;
    [p1, s1] = q2grp(q1, a, f);
    [p2, s2] = q2grp(q2, a, f);
    
    % Swap some indices.
    swap = logical(randi(2, 1, n) - 1);
    [p1(:,swap), s1(swap)] = grpalt(p1(:,swap), a, f, s1(swap));
    
    % Create the composition, noting the swaps.
    s1
    p3 = grpdiff(p1, p2, a, f, s1, s2);
    
    % After the composition, the MRPs will only refer to "near" rotations,
    % since a = 0.5 and the operation uses the quaternion.
    p3_0 = q2grp(q3, a, f);
    p3
    p3_0
    p3_alt_0 = grpalt(p3_0, a, f)
    test.verifyEqual(p3, p3_0, 'AbsTol', tol);
                
end % qdiff

end % methods

end % class
