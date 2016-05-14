classdef RotationConversionUnitTests < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%%%%%%%%%%
% Rx, Ry, and Rz %
%%%%%%%%%%%%%%%%%%
    
function test_RxRyRz(test)

    % Matches intuition?
    test.verifyEqual(Ry(pi/4) * [1; 0; 0], ...
                     1/sqrt(2) * [1; 0; 1], ...
                     'AbsTol', eps);
                 
	% And aa2dcm?
    test.verifyEqual(Ry(pi/4) * [1; 0; 0], ...
                     aa2dcm([0; 1; 0], pi/4) * [1; 0; 0], ...
                     'AbsTol', eps);
    
    % A bunch of cases
    theta = [pi 2*pi -2*pi+4*rand(1, 10)];
    x = repmat([1; 0; 0], 1, length(theta));
    y = repmat([0; 1; 0], 1, length(theta));
    z = repmat([0; 0; 1], 1, length(theta));
    test.verifyEqual(Rx(theta), aa2dcm(x, theta), 'AbsTol', eps);
    test.verifyEqual(Ry(theta), aa2dcm(y, theta), 'AbsTol', eps);
    test.verifyEqual(Rz(theta), aa2dcm(z, theta), 'AbsTol', eps);

end % Rx, Ry, and Rz

%%%%%%%%%%
% aa2dcm %
%%%%%%%%%%

function test_aa2dcm(test)
    
    % Get the basic set of test axes and angles.
    [r, theta] = get_aa_combos();
    
    % Convert directly and through quaterion.
    R   = aa2dcm(r, theta);
    R_0 = q2dcm(aa2q(r, theta));
    
    % Compare directly.
    test.verifyEqual(R, R_0, 'AbsTol', 1e-12);
    
end % aa2dcm

%%%%%%%%%%
% aa2mrp %
%%%%%%%%%%

function test_aa2mrp(test)
    
    % Get the basic set of test axes and angles.
    [r, theta] = get_aa_combos();
    valid      = theta > -2*pi & theta < 2*pi;
    r          = r(:,valid);
    theta      = theta(valid);
    
    tol = 1e-12;
        
    % MRP (f = 1)
    if ~test_mex_only(mfilename())
        
        p       = aa2mrp(r, theta);
        p_0     = q2mrp(aa2q(r, theta));
        p_0_alt = mrpalt(p_0);
    
        % The result is right if it matches either form of the MRPs.
        test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                            | all(abs(p - p_0_alt) < tol, 1)));
                        
    end
    
    % MRP
    f       = 4;
    p       = aa2mrp(r, theta, f);
    p_0     = q2mrp(aa2q(r, theta), f);
    p_0_alt = mrpalt(p_0, f);
    
    % The result is right if it matches either form of the MRPs.
    test.verifyTrue(all(  all(abs(p - p_0)     < tol, 1) ...
                        | all(abs(p - p_0_alt) < tol, 1)));
        
end % aa2mrp

%%%%%%%%%%
% dcm2aa %
%%%%%%%%%%

function test_dcm2aa(test)
    
    % Get the basic set of quaternions.
    q = get_q_combos();
    
    % Create the rotation matrices for the test, and then convert to axes
    % and angles of rotation. Form the baseline via the quaternion, and use
    % the DCM to get the quaternion.
    R = q2dcm(q);
    [theta,   r]   = dcm2aa(R);
    [theta_0, r_0] = q2aa(dcm2q(R));
    
    % Compare positive angles (actually, no need).
    % r(:,theta < 0)     = -r(:,theta < 0);
    % theta              = abs(theta);
    % r_0(:,theta_0 < 0) = -r_0(:,theta_0 < 0);
    % theta_0            = abs(theta_0);

    % Where theta == pi, the rotation axis could go either way. Make them
    % consistent.
    swap = dot(r, r_0) < 0 & theta == pi;
    r(:, swap) = -r(:, swap);
    
    % Compare rotation vectors.
    test.verifyEqual(bsxfun(@times, theta,   r), ...
                     bsxfun(@times, theta_0, r_0), ...
                     'AbsTol', 1e-11);
    
end % dcm2aa

%%%%%%%%%%
% dcm2ea %
%%%%%%%%%%

function test_dcm2ea(test)
    
    % Get the basic set of quaternions.
    q = get_q_combos();
    
    % Create the rotation matrices for the test, and then convert to axes
    % and angles of rotation. Form the baseline via the quaternion, and use
    % the DCM to get the quaternion.
    R = q2dcm(q);
    
    % Test the default sequence.
    if ~test_mex_only(mfilename())
        
        ea   = dcm2ea(R);
        ea_0 = q2ea(dcm2q(R));

        % Compare via the (positive) quaternion that's built from the Euler
        % angles, because comparing Euler angles sucks.
        q_from_ea   = qpos(ea2q(ea));
        q_from_ea_0 = qpos(ea2q(ea_0));

        % Since Euler angles are a mess, we'll convert *back* to quaterions
        % and then compare the angles between the quaternions.
        test.verifyEqual(qerr(q_from_ea, q_from_ea_0), ...
                         zeros(1, size(q, 2)), ...
                         'AbsTol', 1e-6);
                     
    end
    
    % Get the various sequences to use.
    seq = get_ea_sequences();
    
    % Do it again, with every remaining sequence.
    for k = 1:size(seq, 1)
        ea          = dcm2ea(R, seq(k,:));
        ea_0        = q2ea(dcm2q(R), seq(k,:));
        q_from_ea   = ea2q(ea,   seq(k,:));
        q_from_ea_0 = ea2q(ea_0, seq(k,:));
        test.verifyEqual(qerr(q_from_ea, q_from_ea_0), ...
                         zeros(1, size(q, 2)), ...
                         'AbsTol', 1e-6);
    end
    
end % dcm2ea

%%%%%%%%%%
% ea2dcm %
%%%%%%%%%%

function test_ea2dcm(test)
    
    % Get the basic set of Euler angles.
    ea = get_ea_combos();
    
    if ~test_mex_only(mfilename())

        % Convert directly and through quaterion.
        R   = ea2dcm(ea);
        R_0 = q2dcm(ea2q(ea));

        % Compare directly.
        test.verifyEqual(R, R_0, 'AbsTol', 1e-12);
        
    end
    
    % Get the various sequences to use.
    seq = get_ea_sequences();
    
    % Do it again, with every remaining sequence.
    for k = 1:size(seq, 1)
        R   = ea2dcm(ea, seq(k,:));
        R_0 = q2dcm(ea2q(ea, seq(k,:)));
        test.verifyEqual(R, R_0, 'AbsTol', 1e-12);
    end
    
end % ea2dcm

%%%%%%%%%%
% mrp2aa %
%%%%%%%%%%

function test_mrp2aa(test)
    
    % Start with the test set of quaternions.
    q = get_q_combos();
    
    % Get the right answers.
    [theta_0, r_0] = q2aa(q);
    
    % MRP (f = 1)
    if ~test_mex_only(mfilename())
        p          = q2mrp(q);
        [theta, r] = mrp2aa(p);
        [theta, r] = aashort(theta, r);
        test.verifyEqual(theta, theta_0, 'AbsTol', 1e-9);
        test.verifyEqual(r,     r_0,     'AbsTol', 1e-9);
    end
    
    % MRP (f = 4)
    f          = 4;
    p          = q2mrp(q, f);
    [theta, r] = mrp2aa(p, f);
    [theta, r] = aashort(theta, r);
    test.verifyEqual(theta, theta_0, 'AbsTol', 1e-9);
    test.verifyEqual(r,     r_0,     'AbsTol', 1e-9);
    
end % mrp2aa

%%%%%%%%%%%
% mrp2dcm %
%%%%%%%%%%%

function test_mrp2dcm(test)
    
    % Start with the test set of quaternions.
    q = get_q_combos();
    
    % Get the right answers.
    R_0 = q2dcm(q);
    
	% MRP
    if ~test_mex_only(mfilename())
        p = q2mrp(q);
        R = mrp2dcm(p);
        tol = 1e-12;
        test.verifyEqual(R, R_0, 'AbsTol', tol);
    end
    
	% MRP (f = 4)
    f = 4;
    p = q2mrp(q, f);
    R = mrp2dcm(p, f);
    tol = 1e-12;
    test.verifyEqual(R, R_0, 'AbsTol', tol);
    
end % mrp2dcm
    
end % methods
    
end % class

%%%%%%%%%%%%%%%%%
% get_aa_combos %
%%%%%%%%%%%%%%%%%

function [r_c, theta_c] = get_aa_combos()
    n     = 10; % Number of random vectors
    r     = [eye(3), -eye(3), randunit(3, n)];
    theta = [0, pi, -pi, 2*pi, -2*pi, 4*pi*rand(1, n)-2*pi];
    nc = size(r, 2)*size(theta, 2);
    r_c     = zeros(3, nc);
    theta_c = zeros(1, nc);
    k = 0;
    for ri = 1:size(r, 2)
        for ti = 1:size(theta, 2)
            k = k + 1;
            r_c(:,k)     = r(:,ri);
            theta_c(:,k) = theta(:,ti);
        end
    end
end % get_aa_combos

%%%%%%%%%%%%%%%%
% get_q_combos %
%%%%%%%%%%%%%%%%

function q = get_q_combos()
    q = [eye(4), -eye(4), randunit(4, 10)];
end % get_q_combos

%%%%%%%%%%%%%%%%%%%%
% get_ea_sequences %
%%%%%%%%%%%%%%%%%%%%

function seq = get_ea_sequences()
    seq = [1 2 1; ...
           2 3 2; ...
           3 1 3; ...
           1 3 1; ...
           2 1 2; ...
           3 2 3; ...
           1 2 3; ...
           2 3 1; ...
           3 1 2; ...
           1 3 2; ...
           2 1 3]; % Skips [3 2 1], since this is the function default.
    seq = uint8(seq);
end % get_ea_sequences

%%%%%%%%%%%%%%%%%
% get_ea_combos %
%%%%%%%%%%%%%%%%%

function ea = get_ea_combos()
    n = 10;
    phi   = [0 pi/2 -pi/2 pi -pi 2*pi -2*pi 4*pi*rand(1, n)-2*pi];
    theta = [0 pi/2 -pi/2 pi -pi pi*rand(1, n)-pi/2];
    psi   = [0 pi/2 -pi/2 pi -pi 2*pi -2*pi 4*pi*rand(1, n)-2*pi];
    ea = zeros(3, size(phi, 2) * size(theta, 2) * size(psi, 2));
    k = 0;
    for i1 = 1:size(phi, 2)
        for i2 = 1:size(theta, 2)
            for i3 = 1:size(psi, 2)
                k = k + 1;
                ea(1,k) = phi(i1);
                ea(2,k) = theta(i2);
                ea(3,k) = psi(i3);
            end
        end
    end
end % get_ea_combos
