%% set parametres 

alpha = 1000;
beta = 1000;
gamma = 1000;
max_iter = 1;
min_dist = 100;

% parametro of energetic function
c_energy = 1;

%% data import

% load points from shapefile
S1 = shaperead('data/shapes/line_1.shp');
S2 = shaperead('data/shapes/line_2.shp');

X1_orig = S1.X';
X1_orig(end) = [];
Y1_orig = S1.Y';
Y1_orig(end) = [];

X2_orig = S2.X';
X2_orig(end) = [];
Y2_orig = S2.Y';
Y2_orig(end) = [];

%% compute h

h1 = get_h(X1_orig, Y1_orig);
h2 = get_h(X2_orig, Y2_orig);

%% create matrix A and B
% get number of verteces
n1 = length(X1_orig);
n2 = length(X2_orig);

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

%% move one
% set i
i = 0;

% initialize starting matrix
X1 = X1_orig;
Y1 = Y1_orig;

% initialize shift
del_X = zeros(n1,1);
del_Y = zeros(n1,1);
del_X_prev = zeros(n1,1);
del_Y_prev = zeros(n1,1);

while i < max_iter
    % create Energy matrix
    [Ex, Ey] = get_E(X1, Y1, X2_orig, Y2_orig, min_dist, c_energy);

    % get shift
    del_X = B_inv1*(eig_A1 .* del_X_prev - Ex)
    del_Y = B_inv1*(eig_A1 .* del_Y_prev - Ey);
    
    % get new vertices
    X1 = X1 + del_X;
    Y1 = Y1 + del_Y;

    % update i-1 shift
    del_X_prev = del_X;
    del_Y_prev = del_Y;

    % update iteration
    i = i + 1;
end


%% vizualization
figure
hold on
plot(X1_orig, Y1_orig, '-o','Color','blue')
plot(X2_orig, Y2_orig, '-o','Color','black')
plot(X1, Y1, '--o', 'Color','blue')

%% move two

% set i
i = 0;

% initialize starting matrix
X1 = X1_orig;
Y1 = Y1_orig;
X2 = X2_orig;
Y2 = Y2_orig;

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

%% vizualization
figure
hold on
plot(X1_orig, Y1_orig, '--o','Color','red')
plot(X2_orig, Y2_orig, '--o','Color','blue')
plot(X1, Y1, '-o', 'Color','red')
plot(X2, Y2, '-o', 'Color', 'blue')







