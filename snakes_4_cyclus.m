clc, clear, close all

% load solid objects
files = dir('data/q*.txt') ;   % you are in the folder of files 
N = length(files) ;


% load lines
v1 = importdata('data/v1_new.txt');
v2 = importdata('data/v2_new.txt');

% initialize solid verts
X_solid = [];
Y_solid = [];

% loop for each file for vizualization and save verts to one variable
for i = 1:N
    thisfile = files(i).name ;
    curr_file = importdata(strcat('data/',thisfile));
    
    X = curr_file(:,1);
    Y = curr_file(:,2);

    % add X and Y to one array
    X_solid = [X_solid; X];
    Y_solid = [Y_solid; Y];

end

% save coords of the lines into two matrix
X1 = v1(:,1);
Y1 = v1(:,2);

X2 = v2(:,1);
Y2 = v2(:,2);

% set parameters of generalization

%alpha = 3000;
%beta = 1500;
%gamma = 10;
max_iter = 1000;
min_dist = 10;

% parametro of energetic function
c_energy = 0.5;
i = 0
settings = []
for alpha =3000 :500:3000
    for beta = 2500:500:2500
        for gamma = 1:1:10

% partial displacement
[X1_moved, Y1_moved] = move_one(X1, Y1, X_solid, Y_solid, alpha, beta, gamma, c_energy, max_iter, min_dist);
%[X2_moved, Y2_moved] = move_one(X2, Y2, X_solid, Y_solid, alpha, beta, gamma, c_energy, max_iter, min_dist);

% sm = getSmoothness(X1_moved, Y1_moved);
% diff(sm);
% std(sm)


dx  = gradient(X1_moved);
ddx = gradient(dx);
dy  = gradient(Y1_moved);
ddy = gradient(dy);
num   = dx .* ddy - ddx .* dy;
denom = dx .* dx + dy .* dy;
denom = sqrt(denom) .^ 3;
curvature = num ./ denom;
curvature(denom < 0) = NaN;
score = std(curvature);

settings= [settings;[alpha, beta, gamma, score]];
i = i +1


        end
    end
end

sort(settings, 4);

% vizualization
for e = 1:5

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
    
    end

[X1_moved, Y1_moved] = move_one(X1, Y1, X_solid, Y_solid, settings(e,1), settings(e,2), settings(e,3), c_energy, max_iter, min_dist);    
plot(X1, Y1, Color= 'blue')
plot(X1_moved, Y1_moved, color='red')
title(settings(e,:))
end
for e = 1:5

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
    
    end

    [X1_moved, Y1_moved] = move_one(X1, Y1, X_solid, Y_solid, settings(end-e,1), settings(end-e,2), settings(end-e,3), c_energy, max_iter, min_dist);    

plot(X1_moved, Y1_moved, 'LineWidth',2.5, color='red')
plot(X1, Y1,'LineWidth',2, Color= 'blue')

title(settings(end-e,[1:3]))

% 
% plot(X2, Y2, Color= 'blue')
% plot(X2_moved, Y2_moved, color='red')
end