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
% aa2grp %
%%%%%%%%%%

function test_aa2grp(test)
    
    % Get the basic set of test axes and angles.
    [r, theta] = get_aa_combos();
    
    % Convert directly to Gibbs, MRP, and GRP (a=1,f=4) and through the
    % quaterion.
    valid_g   = theta > -pi   & theta < pi;
    valid_mrp = theta > -2*pi & theta < 2*pi;
    valid_grp = theta > -2*pi & theta < 2*pi;
    g     = aa2grp(r(:,valid_g),   theta(:,valid_g),   0, 1);
    mrp   = aa2grp(r(:,valid_mrp), theta(:,valid_mrp), 1, 1);
    grp   = aa2grp(r(:,valid_grp), theta(:,valid_grp));
    g_0   = q2grp(aa2q(r(:,valid_g),   theta(:,valid_g)),   0, 1);
    mrp_0 = q2grp(aa2q(r(:,valid_mrp), theta(:,valid_mrp)), 1, 1);
    grp_0 = q2grp(aa2q(r(:,valid_grp), theta(:,valid_grp)));
    
    % Create the errors of GRPs wrt either valid GRP form.
    dg1   = g - g_0;
    dg2   = g + bsxfun(@rdivide, g_0, sum(g_0.^2, 1));
    dmrp1 = mrp - mrp_0;
    dmrp2 = mrp + bsxfun(@rdivide, mrp_0, sum(mrp_0.^2, 1));
    dgrp1 = grp - grp_0;
    dgrp2 = grp/4 + 4*bsxfun(@rdivide, grp_0, sum(grp_0.^2, 1));
    
    % The result is right if it matches either form of the GRPs.
    test.verifyTrue(all(  all(abs(dg1)   < 1e-12, 1) ...
                        | all(abs(dg2)   < 1e-12, 1)));
    test.verifyTrue(all(  all(abs(dmrp1) < 1e-12, 1) ...
                        | all(abs(dmrp2) < 1e-12, 1)));
    test.verifyTrue(all(  all(abs(dgrp1) < 1e-12, 1) ...
                        | all(abs(dgrp2) < 1e-12, 1)));
        
end % aa2grp

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
    R    = q2dcm(q);
    ea   = dcm2ea(R);
    ea_0 = q2ea(dcm2q(R));
    
    % Compare via the (positive) quaternion that's built from the Euler
    % angles, because comparing Euler angles sucks.
    q_from_ea   = qpos(ea2q(ea));
    q_from_ea_0 = qpos(ea2q(ea_0));
    
    % Since Euler angles are a mess, we'll convert *back* to quaterions and
    % then compare the angles between the quaternions.
    test.verifyEqual(qerr(q_from_ea, q_from_ea_0), ...
                     zeros(1, size(q, 2)), ...
                     'AbsTol', 1e-6);
    
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
    
    % Convert directly and through quaterion.
    R   = ea2dcm(ea);
    R_0 = q2dcm(ea2q(ea));
    
    % Compare directly.
    test.verifyEqual(R, R_0, 'AbsTol', 1e-12);
    
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
% grp2aa %
%%%%%%%%%%

function grp2aa(test)
    
    % Start with the test set of quaternions.
    q = get_q_combos();
    
    % Get the right answers.
    theta_actual = q2aa(q);
    
    % Make the Gibbs, MRP, and GRP (a=1,f=4) vectors.
    g   = q2grp(q, 0, 1);
    mrp = q2grp(q, 1, 1);
    grp = q2grp(q);
    
    % Make the right axes and angles.
    [theta_0, r_0] = q2aa(grp2q(g, 0, 1));
    
    % Determine where the vectors are valid.
    valid = theta_actual > -pi & theta_actual < pi;
    
    % Convert to axis and angle.
    [theta, r] = grp2aa(g, 0, 1);

    % Where theta == pi, the rotation axis could go either way. Make them
    % consistent.
    swap = dot(r, r_0) < 0 & theta == pi;
    r(:, swap) = -r(:, swap);
    
    % Compare rotation vectors.
    tol = 1e-11;
    test.verifyEqual(bsxfun(@times, theta(:,valid),   r(:,valid)), ...
                     bsxfun(@times, theta_0(:,valid), r_0(:,valid)), ...
                     'AbsTol', tol);
    
	% Do it again for MRP.
    [theta_0, r_0] = q2aa(grp2q(mrp, 1, 1));
    valid = theta_actual > -2*pi & theta_actual < 2*pi;
    [theta, r] = grp2aa(mrp, 1, 1);
    swap = dot(r, r_0) < 0 & theta == pi;
    r(:, swap) = -r(:, swap);
    test.verifyEqual(bsxfun(@times, theta(:,valid),   r(:,valid)), ...
                     bsxfun(@times, theta_0(:,valid), r_0(:,valid)), ...
                     'AbsTol', tol);
    
	% Do it again for GRP.
    [theta_0, r_0] = q2aa(grp2q(grp));
    valid = theta_actual > -2*pi & theta_actual < 2*pi;
    [theta, r] = grp2aa(grp);
    swap = dot(r, r_0) < 0 & theta == pi;
    r(:, swap) = -r(:, swap);
    test.verifyEqual(bsxfun(@times, theta(:,valid),   r(:,valid)), ...
                     bsxfun(@times, theta_0(:,valid), r_0(:,valid)), ...
                     'AbsTol', tol);

end % grp2aa

%%%%%%%%%%%
% grp2dcm %
%%%%%%%%%%%

function grp2dcm(test)
    
    % Start with the test set of quaternions.
    q = get_q_combos();
    
    % Get the right answers.
    theta_0 = q2aa(q);
    R_0 = q2dcm(q);
    
    % Make the Gibbs, MRP, and GRP (a=1,f=4) vectors.
    g   = q2grp(q, 0, 1);
    mrp = q2grp(q, 1, 1);
    grp = q2grp(q);
    
    % Determine where the vectors are valid.
    valid = theta_0 > -pi & theta_0 < pi;
    
    % Convert to DCM.
    R = grp2dcm(g, 0, 1);
    
    % Compare directly.
    tol = 1e-12;
    test.verifyEqual(R(:,:,valid), R_0(:,:,valid), 'AbsTol', tol);

	% Do it again for MRP.
    valid = theta_0 > -2*pi & theta_0 < 2*pi;
    R = grp2dcm(mrp, 1, 1);
    test.verifyEqual(R(:,:,valid), R_0(:,:,valid), 'AbsTol', tol);
    
	% Do it again for GRP.
    valid = theta_0 > -2*pi & theta_0 < 2*pi;
    R = grp2dcm(grp);
    test.verifyEqual(R(:,:,valid), R_0(:,:,valid), 'AbsTol', tol);

end % grp2dcm
    
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
