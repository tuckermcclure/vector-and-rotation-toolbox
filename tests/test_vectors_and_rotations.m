%% Tests
%
% +/- q
% Gibbs, MRP, 4*MRP
% +/- p
% extremes of each
% randomly in the ranges
% EA sequences
% coder and regular (via MEX)
% vectorization

% converstions = {     [],  @aa2dcm,      [], @aa2grp,  @aa2q; ...
%                 @dcm2aa,       [], @dcm2ea,      [], @dcm2q; ...
%                      [],  @ea2dcm,      [],      [],  @ea2q; ...
%                 @grp2aa, @grp2dcm,      [],      [], @grp2q; ...
%                   @q2aa,   @q2dcm,   @q2ea,  @q2grp,    []};
              
%% Axis-Angle to Other Stuff
% 
% Generate various combinations of axis and angles and convert to DCM. Then
% compare to conversions via the quaternion.

n     = 25; % Number of random vectors
r     = [eye(3), -eye(3), randunit(3, n)];
theta = [0, pi, -pi, 2*pi, -2*pi, 4*pi * rand(1, n) - 2*pi];

% For each axis and each angle...
for ri = 1:size(r, 2)
    for ti = 1:size(theta, 2)
        
        % 2dcm
        R  = aa2dcm(r(:,ri), theta(ti));
        R0 = q2dcm(aa2q(r(:,ri), theta(ti)));
        dR = R - R0;
        if any(abs(dR(:)) > 1e-12)
            R, R0, dR
            error('aa2dcm doesn''t work!');
        end
        
        % 2 Gibbs
        if theta(ti) < pi && theta(ti) > -pi
            p  = aa2grp(r(:,ri), theta(ti), 0, 1);
            p0 = q2grp(aa2q(r(:,ri), theta(ti)), 0, 1);
            dp1 = p - p0;
            dp2 = p + p0./sum(p0.^2);
            if any(abs(dp1) > 1e-12) && any(abs(dp2) > 1e-12)
                p, p0, dp1, dp2
                error('aa2 Gibbs doesn''t work!');
            end
        end
        
        % 2 MRP
        if theta(ti) < 2*pi && theta(ti) > -2*pi
            p  = aa2grp(r(:,ri), theta(ti), 1, 1);
            p0 = q2grp(aa2q(r(:,ri), theta(ti)), 1, 1);
            dp1 = p - p0;
            dp2 = p + p0./sum(p0.^2);
            if any(abs(dp1) > 1e-12) && any(abs(dp2) > 1e-12)
                p, p0, dp1, dp2
                error('aa2 MRP doesn''t work!');
            end
        end
        
        % 2 GRP
        if theta(ti) < 2*pi && theta(ti) > -2*pi
            p  = aa2grp(r(:,ri), theta(ti));
            p0 = q2grp(aa2q(r(:,ri), theta(ti)));
            dp1 = p - p0;
            dp2 = p/4 + 4 * p0./sum(p0.^2);
            if any(abs(dp1) > 1e-12) && any(abs(dp2) > 1e-12)
                p, p0, dp1, dp2
                error('aa2grp doesn''t work!');
            end
        end
        
    end
end

%% GRPs to Other Stuff
% 

q = [eye(4), -eye(4), randunit(4, 10)];

for qi = 1:size(q, 2)
    
    g   = q2grp(q(:,qi), 0, 1);
    mrp = q2grp(q(:,qi), 1, 1);
    grp = q2grp(q(:,qi));
    
    [theta_0, r_0] = q2aa(q(:,qi));
    
    [theta, r]     = grp2aa(g, 0, 1);
    if abs(theta * r - theta_0 * r_0) > 1e-12
        error('Gibbs 2 aa doesn''t work.');
    end
    
    [theta_0, r_0] = q2aa(q(:,qi));
    [theta, r]     = grp2aa(mrp, 1, 1);
    if abs(theta * r - theta_0 * r_0) > 1e-12
        error('MRP 2 aa doesn''t work.');
    end
    
    [theta_0, r_0] = q2aa(q(:,qi));
    [theta, r]     = grp2aa(grp);
    if abs(theta * r - theta_0 * r_0) > 1e-12
        error('grp2aa doesn''t work.');
    end

    R0 = q2dcm(q(:,qi));
    R = grp2dcm(g, 0, 1);
    dR = R - R0;
    if any(abs(dR(:)) > 1e-12)
        R, R0, dR
        error('gibbs2dcm doesn''t work!');
    end
    
    R0 = q2dcm(q(:,qi));
    R = grp2dcm(mrp, 1, 1);
    dR = R - R0;
    if any(abs(dR(:)) > 1e-12)
        R, R0, dR
        error('mrp2dcm doesn''t work!');
    end
    
    R0 = q2dcm(q(:,qi));
    R = grp2dcm(grp);
    dR = R - R0;
    if any(abs(dR(:)) > 1e-12)
        R, R0, dR
        error('grp2dcm doesn''t work!');
    end
    
    q0 = grp2q(g, 0, 1);
    if q2aa(qcomp(q0, qinv(q(:,qi)))) > 1e-7
        error('gibbs2q doesn''t work!');
    end
    
    q0 = grp2q(mrp, 1, 1);
    if q2aa(qcomp(q0, qinv(q(:,qi)))) > 1e-7
        error('mrp2q doesn''t work!');
    end
    
    q0 = grp2q(grp);
    if q2aa(qcomp(q0, qinv(q(:,qi)))) > 1e-7
        error('grp2q doesn''t work!');
    end
    
end

%% Euler Angles to Other Stuff

n = 10;
phi   = [0 pi/2 -pi/2 pi -pi 2*pi -2*pi 4*pi*rand(1, n)-2*pi];
theta = [0 pi/2 -pi/2 pi -pi pi*rand(1, n)-pi/2];
psi   = [0 pi/2 -pi/2 pi -pi 2*pi -2*pi 4*pi*rand(1, n)-2*pi];
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
       2 1 3];

for k1 = 1:length(phi)
    for k2 = 1:length(theta)
        for k3 = 1:length(psi)
            
            ea = [phi(k1); theta(k2); psi(k3)];
            
            % Test default 3 2 1
            q0  = ea2q(ea);
            
%             if any(abs(q0 - ea2q(q2ea(q0))) > 1e-12)
%                 error('?');
%             end
            
            R0  = q2dcm(q0);
            R   = ea2dcm(ea);
            dR = R - R0;
            if any(abs(dR(:)) > 1e-14)
                R, R0, dR
                error('ea2dcm doesn''t work!');
            end
            
            for k4 = 1:size(seq, 1)
                q0  = ea2q(ea, seq(k4,:));
                R0  = q2dcm(q0);
                R   = ea2dcm(ea, seq(k4,:));
                dR = R - R0;
                if any(abs(dR(:)) > 1e-14)
                    R, R0, dR
                    error('ea2dcm doesn''t work!');
                end
            end
            
        end
    end
end

%% DCMs to Other Stuff

for qi = 1:size(q, 2)

    R0 = q2dcm(q(:,qi));
    [theta0, r0] = q2aa(q(:,qi));
    [theta, r] = dcm2aa(R0);
    if r.'*r0 == -1 && theta == pi
        r = -r;
    end
    if any(theta * r - theta0 * r0 > 1e-9)
        error('dcm2aa doesn''t work.');
    end
    
    ea = dcm2ea(R0);
    ea0 = q2ea(q(:,qi));
    if q2aa(qcomp(ea2q(ea), qinv(ea2q(ea0)))) > 1e-7
        error('?');
    end
    
    if q2aa(qcomp(dcm2q(R0), qinv(q(:,qi)))) > 1e-7
        error('dcm2q');
    end
    
end
