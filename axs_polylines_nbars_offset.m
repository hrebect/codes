clc
clear
hold on
axis equal
d = 2

%Displaced polylines
V1 = load('v1_new.txt');
V2 = load('v2_new.txt');

%Barriers
Q1 = load('q1_new.txt');
Q2 = load('q2_new.txt');
Q3 = load('q3_new.txt');
Q4 = load('q4_new.txt');
Q5 = load('q5_new.txt');
Q6 = load('q6_new.txt');
Q7 = load('q7_new.txt');
Q8 = load('q8_new.txt');
Q9 = load('q9_new.txt');
%Q10 = load('q10_new.txt');

[xq1, yq1] = samplePolyline(Q1(:, 1), Q1(:, 2), d);
[xq2, yq2] = sampleShape(Q2(:, 1), Q2(:, 2), d);
[xq3, yq3] = sampleShape(Q3(:, 1), Q3(:, 2), d);
[xq4, yq4] = sampleShape(Q4(:, 1), Q4(:, 2), d);
[xq5, yq5] = sampleShape(Q5(:, 1), Q5(:, 2), d);
[xq6, yq6] = sampleShape(Q6(:, 1), Q6(:, 2), d);
[xq7, yq7] = sampleShape(Q7(:, 1), Q7(:, 2), d);
[xq8, yq8] = sampleShape(Q8(:, 1), Q8(:, 2), d);
[xq9, yq9] = sampleShape(Q9(:, 1), Q9(:, 2), d);
%[xq10, yq10] = sampleShape(Q10(:, 1), Q10(:, 2), d);
[xc, yc] = samplePolyline(V1(:, 1), V1(:, 2), d);
[xc2, yc2] = samplePolyline(V2(:, 1), V2(:, 2), d);

Q = [[xq1, yq1]; [xq2, yq2]; [xq3, yq3]; [xq4, yq4]; [xq5, yq5]; [xq6, yq6]; [xq7, yq7]; [xq8, yq8]; [xq9, yq9]];
%Q = [xq1, yq1];
xb1 = Q(:, 1);
yb1 = Q(:, 2);
%xc = xq2 +10 ;
%yc = yq2 - 10;

plot(xc, yc, '-b', 'LineWidth', 2);
plot(xc2, yc2, '-b', 'LineWidth', 2);
plot(xq1, yq1, '-k', 'LineWidth', 2);
plot(xq2, yq2, '-k', 'LineWidth', 2);
plot(xq3, yq3, '-k', 'LineWidth', 2);
plot(xq4, yq4, '-k', 'LineWidth', 2);
plot(xq5, yq5, '-k', 'LineWidth', 2);
plot(xq6, yq6, '-k', 'LineWidth', 2);
plot(xq7, yq7, '-k', 'LineWidth', 2);
plot(xq8, yq8, '-k', 'LineWidth', 2);
plot(xq9, yq9, '-k', 'LineWidth', 2);
%plot(xq10, yq10, '-k', 'LineWidth', 2);


%Parameters
m = length(xc)
lambda1 = 1.0; %Serie: 1, 10, 25, 50, 100
lambda2 = 5;
lambda3 = 10; % 1 10 50 100
lambda4 = 1;
lambda5 = 0.0;% 1 10 50 100

%Create spline
dmin1 = 8; %10
dmin2 = 8;  % 5
closed = 0;
k = 2;

%Nearest points on the first buffer
knn = 5;
[i1min, d1min] = knnsearch([xb1, yb1], [xc, yc], 'K', knn, 'Distance','euclidean');
xnear1 = xb1(i1min); ynear1 = yb1(i1min);
xmean1 = mean(xnear1, 2); ymean1 = mean(ynear1, 2);

[xs, ys] = smoothPolylineOffsetAsLS(xc, yc, xmean1, ymean1, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);
%[xs, ys] = smoothPolylineOffsetAsLS2(xc, yc, xb1(i1min), yb1(i1min), lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);

%Plot results
plot(xs, ys, 'r', 'LineWidth', 2);

%Nearest points on the first buffer
[i2min, d2min] = knnsearch([xb1, yb1], [xc2, yc2], 'K', knn, 'Distance','euclidean');
xnear2 = xb1(i2min); ynear2 = yb1(i2min);
xmean2 = mean(xnear2, 2); ymean2 = mean(ynear2, 2);

[xs, ys] = smoothPolylineOffsetAsLS(xc2, yc2, xmean2, ymean2, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);
%[xs, ys] = smoothPolylineOffsetAsLS2(xc, yc, xb1(i1min), yb1(i1min), lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed);

%Plot results
plot(xs, ys, 'r', 'LineWidth', 2);
