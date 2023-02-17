function [Ex, Ey] = get_E(X, Y, S_x, S_y, min_dist, c)
    % get number of point in spline
    n = length(X);
    % create S in suitable form
    S = [S_x, S_y]

    % initialize Ex, Ey
    Ex = zeros(n,1);
    Ey = zeros(n,1);
    
    % process all points in spline
    for i = 1:n
        % find nearest point q form S to point p and its distance d
        p = [X(i) Y(i)];
        [nearest, d] = dsearchn(S, p);
        q = S(nearest, :);
        
        % calculate parcial derivation, if distance is small enough
        if d < min_dist && d ~= 0
            Ex(i) = -c*((p(1)-q(1))/d*min_dist);
            Ey(i) = -c*((p(2)-q(2))/d*min_dist);


        end

    end

end