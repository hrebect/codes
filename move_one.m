function [X, Y] = move_one(X, Y, SX, SY, alpha, beta, gamma, c_energy, max_iter, min_dist)

% get h
h = get_h(X, Y);

% create matrix A and B
% get number of verteces
n = length(X);

% create A
A = create_A(alpha, beta, gamma,h, n);

% get eigenvalues of A 
eig_A = eig(A);


% create identity matrix I
I = eye(n);

% create matrix B and invers of B
B = A + eig_A .* I;
B_inv = inv(B);

% iteration
i = 0;

% initialize shift
del_X = zeros(n,1);
del_Y = zeros(n,1);
del_X_prev = zeros(n,1);
del_Y_prev = zeros(n,1);

while i < max_iter
    % create Energy matrix
    [Ex, Ey] = get_E(X, Y, SX, SY, min_dist, c_energy);

    % get shift
    del_X = B_inv*(eig_A .* del_X_prev - Ex);
    del_Y = B_inv*(eig_A .* del_Y_prev - Ey);
    
    % get new vertices
    X = X + del_X;
    Y = Y + del_Y;

    % update i-1 shift
    del_X_prev = del_X;
    del_Y_prev = del_Y;

    % update iteration
    i = i + 1;
end