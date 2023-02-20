function [X1 Y1, X2, Y2] = move_two(X1, Y1, X2, Y2, alpha, beta, gamma, c_energy, max_iter, min_dist)

% get h
h1 = get_h(X1, Y1);
h2 = get_h(X2, Y2);

% create matrix A and B
% get number of verteces
n1 = length(X1);
n2 = length(X2);

% create A
A1 = create_A(alpha, beta, gamma,h1, n1);
A2 = create_A(alpha, beta, gamma, h2, n2);

% get eigenvalues of A 
eig_A1 = eig(A1);
eig_A2 = eig(A2);


% create identity matrix I
I1 = eye(n1);
I2 = eye(n2);

% create matrix B and invers of B
B1 = A1 + eig_A1 .* I1;
B_inv1 = inv(B1);

B2 = A2 + eig_A2 .* I2;
B_inv2 = inv(B2);

% set i
i = 0;

% initialize starting matrix

% initialize shift
del_X1 = zeros(n1,1);
del_Y1 = zeros(n1,1);
del_X1_prev = zeros(n1,1);
del_Y1_prev = zeros(n1,1);

del_X2 = zeros(n2,1);
del_Y2 = zeros(n2,1);
del_X2_prev = zeros(n2,1);
del_Y2_prev = zeros(n2,1);

while i < max_iter
    % create Energy matrix
    [Ex1, Ey1] = get_E(X1, Y1, X2, Y2, min_dist, c_energy);
    [Ex2, Ey2] = get_E(X2, Y2, X1, Y1, min_dist, c_energy);

    % get shift
    del_X1 = B_inv1*(eig_A1 .* del_X1_prev - Ex1);
    del_Y1 = B_inv1*(eig_A1 .* del_Y1_prev - Ey1);

    del_X2 = B_inv2*(eig_A2 .* del_X2_prev - Ex2);
    del_Y2 = B_inv2*(eig_A2 .* del_Y2_prev - Ey2);
    
    % get new vertices
    X1 = X1 + del_X1;
    Y1 = Y1 + del_Y1;

    X2 = X2 + del_X2;
    Y2 = Y2 + del_Y2;

    % update i-1 shift
    del_X1_prev = del_X1;
    del_Y1_prev = del_Y1;

    del_X2_prev = del_X2;
    del_Y2_prev = del_Y2;

    % update iteration
    i = i + 1;
end




