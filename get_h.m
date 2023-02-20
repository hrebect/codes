function h = get_h(X, Y)
    % initialize distances between vertices
    dX = zeros(length(X)-1,1);
    dY = zeros(length(X)-1,1);
    
    % compute distances
    for i=1:length(X)-1
        dX(i) = abs(X(i+1) - X(i));
        dY(i) = abs(Y(i+1) - Y(i));
    end
    
    H= sqrt(dX.^2 + dY.^2);
    h = mean(H);

end