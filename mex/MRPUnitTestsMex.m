classdef MRPUnitTestsMex < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%%%
% mrpcomp_mex %
%%%%%%%%%%%

function test_mrpcomp(test)
    
    n   = 5;
    qa  = randunit(4, n);
    qb  = randunit(4, n);
    q   = qcomp_mex(qa, qb);
    tol = 1e-9;
    
    % MRP (f = 1)
    if ~test_mex_only(mfilename())
        pa      = q2mrp_mex(qa);
        pb      = q2mrp_mex(qb);
        p       = mrpcomp_mex(pa, pb);
        p_0     = q2mrp_mex(q);
        p_0_alt = mrpalt_mex(p_0);
        test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                            | all(abs(p - p_0_alt) < tol, 1)));
    end
    
    % MRP (f = 4)
    f       = 4;
    pa      = q2mrp_mex(qa, f);
    pb      = q2mrp_mex(qb, f);
    p       = mrpcomp_mex(pa, pb, f);
    p_0     = q2mrp_mex(q, f);
    p_0_alt = mrpalt_mex(p_0, f);
    test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                        | all(abs(p - p_0_alt) < tol, 1)));
    
end % mrpcomp_mex

%%%%%%%%%%%
% mrpdiff_mex %
%%%%%%%%%%%

function test_mrpdiff(test)
    
    n   = 10;
    q1  = randunit(4, n);
    q2  = randunit(4, n);
    q3  = qcomp_mex(q1, qinv_mex(q2));
    tol = 1e-9;
    theta_0               = qerr_mex(q1, q2);
    theta_0(theta_0 > pi) = 2*pi - theta_0(theta_0 > pi);
    
    % MRPs (f = 1)
    if ~test_mex_only(mfilename())
        p1       = q2mrp_mex(q1);
        p2       = q2mrp_mex(q2);
        p3       = mrpdiff_mex(p1, p2);
        p3_0     = q2mrp_mex(q3);
        p3_alt_0 = mrpalt_mex(p3_0);
        test.verifyTrue(all(  all(abs(p3 - p3_0)     < tol, 1) ...
                            | all(abs(p3 - p3_alt_0) < tol, 1)));
                    
        % Test mrperr_mex too.
        theta             = mrperr_mex(p1, p2);
        theta(theta > pi) = 2*pi - theta(theta > pi);
        test.verifyEqual(theta, theta_0, 'AbsTol', 1e-12);

    end
    
    % MRPs (f = 4)
    f        = 4;
    p1       = q2mrp_mex(q1, f);
    p2       = q2mrp_mex(q2, f);
    p3       = mrpdiff_mex(p1, p2, f);
    p3_0     = q2mrp_mex(q3, f);
    p3_alt_0 = mrpalt_mex(p3_0, f);
    test.verifyTrue(all(  all(abs(p3 - p3_0)     < tol, 1) ...
                        | all(abs(p3 - p3_alt_0) < tol, 1)));
                    
	% Test mrperr_mex too.
	theta             = mrperr_mex(p1, p2, f);
    theta(theta > pi) = 2*pi - theta(theta > pi);
    test.verifyEqual(theta, theta_0, 'AbsTol', 1e-12);
    
end % mrpdiff_mex

end % methods

end % class
