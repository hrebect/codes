function [XS, YS] = smoothPolylineOffsetAsLS(X, Y, X1, Y1, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed)
%Smooth polyline, keet at the ofset from the barrier
%Approximation of the Bertrand curve
[m, n] = size(X);

%Initial matrices
E = eye(m, m);

%Difference matrices
D = diff(E, k);
D1 = diff(E, 1);

%Closed spline
if closed

    %D1
    r1 = zeros(m); r1(1,1) = 1; r1(1, m) = -1;
    r2 = zeros(m); r2(1,1) = 1; r2(1, m) = -1;
    D1=[r1; D1];
    %D1=[r1; D1; r2];

    %Dk = D1
    if k == 1
        D=D1;

    %Dk = D2
    elseif k == 2
        r1 = zeros(m); r1(1,1) = 1; r1(1, m-1) = 1; r1(1, m) = -2;
        r2 = zeros(m); r2(1,1) = -2; r2(1, 2) = 1; r2(1, m) = 1;
        D=[r1; r2;D];
        %D=[r1; r2;D; r1; r2];
    end
end

%B = (abs(X-X1) < dmin1) .* (abs(Y-Y1) < dmin1);
B = (sqrt((X-X1).*(X-X1) + (Y-Y1).*(Y-Y1)) < dmin1);

DX = X; DY = Y;
for i = 1 : m

    %Coordinate differences
    dx = X(i) - X1(i);
    dy = Y(i) - Y1(i);

    %Compute new buffer width
    om = atan2(dy, dx);
    dmin2x = abs(dmin2 * (cos(om))^1);
    dmin2y = abs(dmin2 * (sin(om))^1  );
    %dmin2x = dmin2;
    %dmin2y = dmin2;

    %Horizontal segment, do not shift
    %if B(i) == 1
        if (X(i) < X1(i))
            DX(i) = (X1(i) - dmin2x);
        else
            DX(i) = (X1(i) + dmin2x);
        end
    
        %Other than vertical segment
        if (Y(i) < Y1(i))
            DY(i) = (Y1(i) - dmin2y);
        else
            DY(i) = (Y1(i) + dmin2y);
        end
    end
%end

%Difference vector for X
IDX = X < X1;
DX1 = IDX .* (X1 - dmin2);
M1X = lambda4 * eye(m, m) .* diag(IDX);
IDX = X >= X1;
DX2 = IDX .* (X1 + dmin2);
M2X = lambda4 * eye(m, m) .* diag(IDX);
%DX = DX1 + DX2;        %Use buffer with a constant width
MX = M1X + M2X;

%DX = 0.5*DX;

%Difference vector for Y
IDY = Y < Y1;
DY1 = IDY .* (Y1 - dmin2);
M1Y = lambda4 * eye(m, m) .* diag(IDY);
IDY = Y >= Y1;
DY2 = IDY .* (Y1 + dmin2);
M2Y = lambda4 * eye(m, m) .* diag(IDY);
%DY = DY1 + DY2;        %Use buffer with a constant width
MY = M1Y + M2Y;

%DY = 0.5*DY;
%plot (DX, DY);

%Distance condition
%B = (abs(X-X1) < dmin1) .* (abs(Y-Y1) < dmin1);

%Compute inverse
I = inv(lambda1 * eye(m, m) + lambda2 * D'*D + lambda4 * eye(m,m) * diag(B) + lambda3 *  D1' * D1 + lambda5 * D1'* D1 * diag(B));

%Solution of AXS
XS = I * ( lambda1 * X + lambda3 * D1' * D1 * X + lambda4 * (DX) .* B + lambda5 * D1' * D1 * X1 .* B);
YS = I * ( lambda1 * Y + lambda3 * D1' * D1 * Y + lambda4 * (DY) .* B + lambda5 * D1' * D1 * Y1 .* B);

%Closed spline
if closed
    XS = [XS; XS(1)];
    YS = [YS; YS(1)];
end

end