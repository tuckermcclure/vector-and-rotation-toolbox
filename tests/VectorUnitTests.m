classdef VectorUnitTests < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%%
% cross3 %
%%%%%%%%%%

function test_cross3(test)

    n = 100;
    a = randn(3, n);
    b = randn(3, n);
    c_0 = cross(a, b);
    c_1 = cross3(a, b);
    c_2 = zeros(3, n);
    for k = 1:n
        c_2(:,k) = crs3(a(:,k)) * b(:,k);
    end
    
    test.verifyEqual(c_1, c_0, 'AbsTol', eps);
    test.verifyEqual(c_2, c_0, 'AbsTol', eps);
    
end % cross3
    
%%%%%%%%%%%%%
% normalize %
%%%%%%%%%%%%%

function test_norm_stuff(test)
    
    test.verifyEqual(vmag(3 * [1 0 1].'), 3*sqrt(2), 'AbsTol', 10*eps);
    
    n = 100;
    v = randn(3, n);
    
    test.verifyEqual(vmag(v), sqrt(sum(v.^2,1)), 'AbsTol', 10*eps);
    
    v = normalize(v);
    test.verifyEqual(sum(v.^2,1), ones(1, n), 'AbsTol', 10*eps);
    
end % norm stuff

%%%%%%%%%%%
% rae2xyz %
%%%%%%%%%%%

function test_rae2xyz(test)
    
    tol = 1e-12;
    
    test.verifyEqual(rae2xyz([3; pi/4; 0]), ...
                     3/sqrt(2)*[1; 1; 0], ...
                     'AbsTol', tol);
    
    test.verifyEqual(rae2xyz([5; 0; pi/4]), ...
                     5/sqrt(2)*[1; 0; -1], ...
                     'AbsTol', tol);
                 
	n   = 100;
	rae = [10   * rand(1, n); ...
           2*pi * rand(1, n); ...
           pi   * rand(1, n) - pi/2];
    v = zeros(3, n);
    for k = 1:n
        v(:,k) = Rz(rae(2,k)).' * Ry(rae(3,k)).' * [rae(1,k); 0; 0];
    end
    
    test.verifyEqual(rae2xyz(rae), v, 'AbsTol', tol);
    
    % Test xyz2rae while we're at it.
    
    test.verifyEqual(xyz2rae(3/sqrt(2)*[1; 1; 0]), ...
                     [3; pi/4; 0], ...
                     'AbsTol', tol);
    
    test.verifyEqual(xyz2rae(5/sqrt(2)*[1; 0; -1]), ...
                     [5; 0; pi/4], ...
                     'AbsTol', tol);
    
	rae_1 = xyz2rae(v);
    rae_1(2, rae_1(2,:) < 0) = rae_1(2, rae_1(2,:) < 0) + 2*pi;
    test.verifyEqual(rae_1, rae, 'AbsTol', tol);
    
end % rae2xyz

end % methods

end % class
