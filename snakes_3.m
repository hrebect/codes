clc, clear, close all

% load solid objects
files = dir('data/q*.txt') ;   % you are in the folder of files 
N = length(files) ;

% initialize solid verts
X_solid = [];
Y_solid = [];

% vizualization of input
figure
hold on
axis equal

% loop for each file for vizualization and save verts to one variable
for i = 1:N
    thisfile = files(i).name ;
    curr_file = importdata(strcat('data/',thisfile));
    
    X = curr_file(:,1);
    Y = curr_file(:,2);
    plot(X, Y, Color='black')

    % add X and Y to one array
    X_solid = [X_solid; X];
    Y_solid = [Y_solid; Y];

end


% load lines
v1 = importdata('data/v1_new.txt');
v2 = importdata('data/v2_new.txt');

% save coords of the lines into two matrix
X1 = v1(:,1);
Y1 = v1(:,2);

X2 = v2(:,1);
Y2 = v2(:,2);

% set parameters of generalization

alpha = 2000;
beta = 1000;
gamma = 100;
max_iter = 1000;
min_dist = 10;

% parametro of energetic function
c_energy = 0.5;

% partial displacement
[X1_moved, Y1_moved] = move_one(X1, Y1, X_solid, Y_solid, alpha, beta, gamma, c_energy, max_iter, min_dist);
[X2_moved, Y2_moved] = move_one(X2, Y2, X_solid, Y_solid, alpha, beta, gamma, c_energy, max_iter, min_dist);

% vizualization
plot(X1, Y1, Color= 'blue')
plot(X1_moved, Y1_moved, color='red')

plot(X2, Y2, Color= 'blue')
plot(X2_moved, Y2_moved, color='red')



