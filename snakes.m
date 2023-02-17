%% set parametres 

alpha = 1000;
beta = 1000;
gamma = 1000;
max_iter = 500;
min_dist = 100;

% parametro of energetic function
c_energy = 1;

%% data import

% load points from shapefile
S1 = shaperead('data/shapes/line_1.shp');
S2 = shaperead('data/shapes/line_2.shp');

X1 = S1.X';
X1(end) = [];
Y1 = S1.Y';
Y1(end) = [];

X2 = S2.X';
X2(end) = [];
Y2 = S2.Y';
Y2(end) = [];

%% compute h
% initialize distances between vertices
dX1 = zeros(length(X1)-1,1);
dY1 = zeros(length(X1)-1,1);

% compute distances
for i=1:length(X1)-1
    dX1(i) = abs(X1(i+1) - X1(i));
    dY1(i) = abs(Y1(i+1) - Y1(i));
end

H1= sqrt(dX1.^2 + dY1.^2);
h = mean(H1);

%% create matrix A and B
% compute elements of matrix
a = alpha + (2*beta/h^2) + (6*gamma/h^4);
b = -beta/h^2 - 4*gamma/h^4;
c = gamma/h^4;

% get number of verteces
n = length(X1);

% create diagonals
a_d = a * ones(n,1);
b_d = b * ones(n,1);
c_d = c * ones(n,1);

A = spdiags([c_d b_d a_d b_d c_d], -2:2,n,n);
A = full(A);

% get eigenvalues of A 
eig_A = eig(A);

% create identity matrix I
I = eye(n);

% create matrix B and invers of B
B = A + eig_A .* I;
B_inv = inv(B);

%% iteration
% set i
i = 0;

% initialize starting matrix
X1_0 = X1;
Y1_0 = Y1;

% initialize shift
del_X = zeros(n,1);
del_Y = zeros(n,1);
del_X_prev = zeros(n,1);
del_Y_prev = zeros(n,1);

while i < max_iter
    % create Energy matrix
    [Ex, Ey] = get_E(X1, Y1, X2, Y2, min_dist, c_energy);

    % get shift
    del_X = B_inv*(eig_A .* del_X_prev - Ex)
    del_Y = B_inv*(eig_A .* del_Y_prev - Ey)
    
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
plot(X1_0, Y1_0, '-o','Color','red')
plot(X2, Y2, '-o','Color','black')
plot(X1, Y1, '-o', 'Color','blue')








% % vizualization of input data
% figure
% hold on
% plot(S1.X, S1.Y, '-o','Color','red')
% plot(S2.X, S2.Y, '-o','Color','blue')
% 
% %% create spline
% h = 50;
% 
% % get min, max values of line
% x_max1 = max(S1.X);
% x_min1 = min(S1.X);
% 
% x_max2 = max(S2.X);
% x_min2 = min(S2.X);
% 
% % spline point descrete by x axis
% xx1 = [x_min1:h:x_max1]; 
% yy1 = spline(S1.X, S1.Y,xx1);
% 
% xx2 = [x_min2:h:x_max2]; 
% yy2 = spline(S2.X, S2.Y,xx2);
% 
% figure
% hold on
% plot(xx1,yy1,'.', 'Color', 'red')
% plot(S1.X, S1.Y, 'o','Color','red')
% plot(xx2,yy2, '.', 'Color','blue')
% plot(S2.X, S2.Y, 'o','Color','blue')
% 
% %% create matrix A
% 
% % parameters
% alpha = 1;
% beta = 1;
% gamma = 1;
% 
% a = alpha + (2*beta/h^2) + (6*gamma/h^4)


%%




