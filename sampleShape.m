function [xs,ys] = sampleShape(x, y, d)
    xs = []; ys = [];
    [m, n] = size(x)

    for i = 1 : m
        i1 = i+1;
        if i == m
            i1 = 1
        end
        nx = abs(x(i1) - x(i))/d + 1;
        ny = abs(y(i1) - y(i))/d + 1;
        n = max(nx, ny);

        xi = linspace(x(i), x(i1), n);
        yi = linspace(y(i), y(i1), n);

        mi = max(length(xi) - 1, 1);

        xs = [xs; (xi(1:mi))'];
        ys = [ys; (yi(1:mi))'];
    end

end