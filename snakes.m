%% data import

% load points from shapefile
S1 = shaperead('data/line_1.shp');
S2 = shaperead('data/line_2.shp');

X1 = S1.X;
X1(end) = [];
Y1 = S1.Y;
Y1(end) = [];

X2 = S2.X;
X2(end) = [];
Y2 = S2.Y;
Y2(end) = [];

% compute h
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




