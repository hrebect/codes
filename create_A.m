function A = create_A(alpha, beta ,gamma,h, n)
    % compute elements of matrix
    a = alpha + (2*beta/h^2) + (6*gamma/h^4);
    b = -beta/h^2 - 4*gamma/h^4;
    c = gamma/h^4;
    
    % create diagonals
    a_d = a * ones(n,1);
    b_d = b * ones(n,1);
    c_d = c * ones(n,1);
    
    A = spdiags([c_d b_d a_d b_d c_d], -2:2,n,n);
    A = full(A);

end