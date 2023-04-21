function smoothness =  getSmoothness(X, Y)

%angle = get2LinesAngle(0, 0, 1, 1, 1, 1, 1, 2) * 180/pi



% X = [0; 1; 1; 0];
% Y = [0; 0; 1; 1];
% 
% figure
% plot(X, Y, 'o-')
% xlim([-1 2])
% ylim([-1 5])

dX= diff(X);
dY = diff(Y);
ux = dX;
uy = dY;
ux(end) = [];
uy(end) = [];
vx = dX;
vy = dY;
vx(1) = [];
vy(1) = [];

% dot product
uv = ux .* vx + uy .* vy;

% Norms
nu = (ux .^2 + uy .^2) .^0.5;
nv = (vx .^2 + vy .^2) .^0.5;

angle = zeros(1, length(ux));
for i = 1:length(ux)
    if nu(i)*nv(i) == 0
        angle(i) = 0;
    end
    try
        angle(i) = abs(acos(uv(i) / (nu(i) * nv(i))));
    catch
        angle(i) = 0;
    end

end

angle_deg = angle * 180/pi;
smoothness = angle_deg;

function angle = get2LinesAngle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y)
 % Get angle between 2 vectors
        ux = p2_x - p1_x;
        uy = p2_y - p1_y;
        vx = p4_x - p3_x;
        vy = p4_y - p3_y;

        % Dot product
        uv = ux * vx + uy * vy;

        % Norms
        nu = (ux ^ 2 + uy ^ 2) ^ 0.5;
        nv = (vx ^ 2 + vy ^ 2) ^ 0.5;

        % Angle
        % Point is on a vertex (one norm is zero)
        if nu * nv == 0
            angle = 0;
        end
        % Removing rounding problem
        try
            angle = abs(acos(uv / (nu * nv)));
        catch
            angle = 0;
        end
end

end

