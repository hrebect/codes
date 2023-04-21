clc, clear, close all

% load data
shape1 = shaperead("data\shapes\road_sit_1.shp");
shape2 = shaperead("data\shapes\river_sit_1.shp");

X1 = shape1.X';
Y1 = shape1.Y';
X2 = shape2.X';
Y2 = shape2.Y';

X1(end) = [];
Y1(end) = [];
X2(end) = [];
Y2(end) = [];

% sample
d =2;
[X1, Y1] = samplePolyline(X1, Y1, d);
[X2, Y2] = samplePolyline(X2, Y2, d);

% load and vizualize buildings

% vizualization of input
figure
hold on
axis equal

% initialize solid verts
X_solid = [];
Y_solid = [];

shape3 = shaperead("data\shapes\river_sit_1.shp");
n = length(shape3);

for i = 1:n
    % remove NaN
    x = shape3(i).X';
    x(end) = [];
    y =  shape3(i).Y';
    y(end) = [];
    plot(x, y, Color='black')

    X_solid = [X_solid; x];
    Y_solid = [Y_solid; y]; 
end

% set parameters of generalization

alpha = 5000;
beta = 5000;
gamma = 10;
max_iter = 1000;
min_dist = 30;

% parametro of energetic function
c_energy = 0.5;

% partial displacement
%[X1_moved, Y1_moved, X2_moved, Y2_moved] = move_two_with_barriers(X1, Y1, X2, Y2,X_solid,Y_solid, alpha, beta, gamma, c_energy, max_iter, min_dist);
[X1_moved, Y1_moved] = move_one(X1, Y1, X2,Y2, alpha, beta, gamma, c_energy, max_iter, min_dist)

% vizualization
% plot(X1, Y1, Color= 'blue')
% plot(X1_moved, Y1_moved, color='red')
% 
% plot(X2, Y2, Color= 'blue')
% plot(X2_moved, Y2_moved, color='red')

plot(X1_moved, Y1_moved, 'LineWidth',2.5, color='red')
plot(X1, Y1,'--','LineWidth',1, Color= 'blue')
% plot(X2_moved, Y2_moved, 'LineWidth',2.5, color='red')
% plot(X2, Y2,'--','LineWidth',1, Color= 'blue')
% 
% new_shape1 = shape1;
% new_shape2 = shape2;
% new_shape1.X = X1_moved';
% new_shape1.Y = Y1_moved';
% new_shape2.X = X2_moved';
% new_shape2.Y = Y2_moved';
% 
% shapewrite(new_shape1,"results\shapes\silnice_moved.shp");






