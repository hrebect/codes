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
shape1 = shaperead('data/shapes/line_1.shp');
shape2 = shaperead('data/shapes/line_2.shp');

X1 = shape1.X';
X1(end) = [];
Y1 = shape1.Y';
Y1(end) = [];

X2 = shape2.X';
X2(end) = [];
Y2 = shape2.Y';
Y2(end) = [];

%% one solid and one moving
[X_moved, Y_moved] = move_one(X1, Y1, X2, Y2, alpha, beta, gamma, c_energy, max_iter, min_dist);


%% vizualization
figure
hold on
plot(X1, Y1, '-o','Color','blue')
plot(X2, Y2, '-o','Color','black')
plot(X_moved, Y_moved, '--o', 'Color','red')

% two moving
[X1_moved, Y1_moved, X2_moved, Y2_moved] = move_two(X1, Y1, X2, Y2, alpha, beta, gamma, c_energy, max_iter, min_dist);


%% vizualization
figure
hold on
plot(X1, Y1, '-o','Color','red')
plot(X2, Y2, '-o','Color','blue')
plot(X1_moved, Y1_moved, '--o', 'Color','red')
plot(X2_moved, Y2_moved, '--o', 'Color', 'blue')


