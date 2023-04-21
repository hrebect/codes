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
[xc, yc] = samplePolyline(X1, Y1, d);
[xc2, yc2] = samplePolyline(X2, Y2, d);

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
m = length(xc)
lambda1 = 10.0; %Serie: 1, 10, 25, 50, 100
lambda2 = 50;
lambda3 = 50; % 1 10 50 100
lambda4 = 1;
lambda5 = 0.0;% 1 10 50 100

%Create spline
dmin1 = 50; %10
dmin2 = 50;  % 5
closed = 0;
k = 1;

%Nearest points on the first buffer
knn = 1;
[i1min, d1min] = knnsearch([X_solid, Y_solid], [xc, yc], 'K', knn, 'Distance','euclidean');
xnear1 = X_solid(i1min); ynear1 = Y_solid(i1min);
xmean1 = mean(xnear1, 2); ymean1 = mean(ynear1, 2);

[xs, ys] = smoothPolylineOffsetAsLS(xc, yc, xmean1, ymean1, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);
%[xs, ys] = smoothPolylineOffsetAsLS2(xc, yc, xb1(i1min), yb1(i1min), lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);

%Plot results
plot(xs, ys, 'r', 'LineWidth', 2);

% %Nearest points on the first buffer
% [i2min, d2min] = knnsearch([X_solid, Y_solid], [xc2, yc2], 'K', knn, 'Distance','euclidean');
% xnear2 = X_solid(i2min); ynear2 = Y_solid(i2min);
% xmean2 = mean(xnear2, 2); ymean2 = mean(ynear2, 2);
% 
% [xs, ys] = smoothPolylineOffsetAsLS(xc2, yc2, xmean2, ymean2, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);
% %[xs, ys] = smoothPolylineOffsetAsLS2(xc, yc, xb1(i1min), yb1(i1min), lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);
% 
% %Plot results
% plot(xs, ys, 'r', 'LineWidth', 2);
% 
plot(X1, Y1);
% plot(X2, Y2);
