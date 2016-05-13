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

% TODO: grperr, grpdiff

end % methods

end % class
