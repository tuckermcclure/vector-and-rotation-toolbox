r_BA = randunit(3);
theta_BA = pi*rand();
r_CB = randunit(3);
theta_CB = pi*rand();
R_BA = aa2dcm(r_BA, theta_BA);
R_CB = aa2dcm(r_CB, theta_CB);
R_CA = R_CB * R_BA

q_BA = aa2q(r_BA, theta_BA);
q_CB = aa2q(r_CB, theta_CB);
q_CA = qcomp(q_CB, q_BA);
q2dcm(q_CA)

%%
v_A = randn(3, 1);
R_BA * v_A
qcomp(qcomp(q_BA, [v_A; 0]), qinv(q_BA))
qrot(q_BA, v_A)
