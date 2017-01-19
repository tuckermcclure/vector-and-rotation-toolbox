classdef QuaternionUnitTestsMex < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%
% qcomp_mex %
%%%%%%%%%

function test_qcomp(test)

    n = 100;
    a = randunit(4, n);
    b = randunit(4, n);
    c = qcomp_mex(a, b);
    
    c_0 = zeros(4, n);
    for k = 1:n
        c_0(:,k) = dcm2q_mex(q2dcm_mex(a(:,k)) * q2dcm_mex(b(:,k)));
    end
    
    c_0 = qpos_mex(c_0);
    c   = qpos_mex(c);
    test.verifyEqual(sign(c(4,:)), ones(1, n));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qcomp_mex
    
%%%%%%%%
% qinv_mex %
%%%%%%%%

function test_qinv(test)

    n = 100;
    a = randunit(4, n);
    c = qinv_mex(a);
    
    c_0 = zeros(4, n);
    for k = 1:n
        c_0(:,k) = dcm2q_mex(q2dcm_mex(a(:,k)).');
    end
    
    c_0 = qpos_mex(c_0);
    c   = qpos_mex(c);
    test.verifyEqual(sign(c(4,:)), ones(1, n));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qinv_mex
        
%%%%%%%%
% qrot_mex %
%%%%%%%%

function test_qrot(test)

    n = 100;
    a = randunit(4, n);
    b = randunit(3, n);
    c = qrot_mex(a, b);
    
    c_0 = zeros(3, n);
    for k = 1:n
        c_0(:,k) = q2dcm_mex(a(:,k)) * b(:,k);
    end
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qrot_mex
        
%%%%%%%%%
% qdiff_mex %
%%%%%%%%%

function test_qdiff(test)
    
    n = 100;
    a = randunit(4, n);
    b = randunit(4, n);
    c = qdiff_mex(a, b);
    c_0 = qcomp_mex(a, qinv_mex(b));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);

    % Check qerr_mex while we're at it.
    theta   = qerr_mex(a, b);
    theta_0 = q2aa_mex(c_0);
    
    test.verifyEqual(theta, theta_0, 'AbsTol', 10*eps);
    
end % qdiff_mex

%%%%%%%%%%%
% qinterp %
%%%%%%%%%%%

function test_qinterp(test)

    r = randunit(3);
    w = randn();
    t = 0:1:10;
    n = length(t);
    q = zeros(4, n);
    for k = 1:n
        q(:,k) = aa2q_mex(w*t(k), r);
    end
    
    % Form the truth.
    ti   = [-1 0 0.5 1 7 7.5 8 10 10.1];
    qi_0 = zeros(4, length(ti));
    for k = 1:length(ti)
        qi_0(:,k) = aa2q_mex(w * max(min(ti(k), t(end)), 0), r);
    end
    
    % Results.
    qi = qinterp(t, q, ti, 'Ordered', true);    
    test.verifyEqual(qi, qi_0, 'AbsTol', 10*eps);
    
    % Now with out-of-order points.
    ti   = [-1 7 7.5 8 0 0.5 1 10 10.1];
    qi_0 = zeros(4, length(ti));
    for k = 1:length(ti)
        qi_0(:,k) = aa2q_mex(w * max(min(ti(k), t(end)), 0), r);
    end
    
    % Results.
    qi = qinterp(t, q, ti, 'ordered', false);
    test.verifyEqual(qi, qi_0, 'AbsTol', 10*eps);
    
    % Results (assumes unordered by default).
    qi = qinterp(t, q, ti);
    test.verifyEqual(qi, qi_0, 'AbsTol', 10*eps);
    
end % qinterp
        
%%%%%%%%
% qdot %
%%%%%%%%

function test_qdot(test)

    r = randunit(3);
    w = randn();
    t = 0:0.1:10;
    n = length(t);
    
    q_0 = zeros(4, n);
    for k = 1:n
        q_0(:,k) = aa2q_mex(w*t(k), r);
    end
    
    q = [q_0(:,1), zeros(4, n-1)];
    for k = 2:n
        dt  = (t(k) - t(k-1));
        qd1 = qdot(q(:,k-1),              w * r, 0.5);
        qd2 = qdot(q(:,k-1) + 0.5*dt*qd1, w * r, 0.5);
        qd3 = qdot(q(:,k-1) + 0.5*dt*qd2, w * r, 0.5);
        qd4 = qdot(q(:,k-1) +     dt*qd3, w * r, 0.5);
        qd  = 1/6 * (qd1 + 2*qd2 + 2*qd3 + qd4);
        q(:,k) = q(:,k-1) + qd * dt;
    end

    test.verifyEqual(q, q_0, 'AbsTol', 1e-5);
    
end % qdot

end % methods

end % class
