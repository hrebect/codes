function [XS, YS] = smoothPolylineOffsetAsLS2(X, Y, X1, Y1, lambda1, lambda2, lambda3, lambda4, lambda5, dmin1, dmin2, k, closed)
%Smooth polyline, keep at the ofset from the barrier
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

%Difference vector for X
DX = X; DY = Y;
for i = 1 : m

    %Next index
    i1 = i + 1;
    if i1 > m
        i1 = 1
    end

    %Coordinate differences
    dx = X(i1) - X(i);
    dy = Y(i1) - Y(i);

    %Compute new buffer width
    om = atan2(dy, dx);
    dmin2y = abs(dmin2 * cos(om));
    dmin2x = abs(dmin2 * sin(om));

    %Horizontal segment, do not shift
    if dy ==0
       DX(i) = X1(i);

    %Other than horizontal segment
    else 
        if (dx >= 0 & dy > 0) | (dx <= 0 & dy > 0) 
            DX(i) = (X1(i) + dmin2x);
        else 
            DX(i) = (X1(i) - dmin2x);
        end
    end

    %Vertical segment, do not shift
    if dx ==0
       DY(i) = Y1(i);

    %Other than vertical segment
    else
        if (dx < 0 & dy >=0) | (dx < 0 & dy <= 0) 
            DY(i) = (Y1(i) + dmin2y);
        else
            DY(i) = (Y1(i) - dmin2y);
        end
    end
end

X2 = DX;
Y2 = DY;

%plot(X2, Y2);


%Distance condition
B = (abs(X-X1) < dmin1) .* (abs(Y-Y1) < dmin1);

%Compute inverse
I = pinv(lambda1 * eye(m, m) + lambda2 * D'*D + lambda4 * eye(m,m) * diag(B) + lambda3 *  D1' * D1 + lambda5 * D1'* D1 * diag(B));

%Solution of AXS
XS = I * ( lambda1 * X + lambda3 * D1' * D1 * X + lambda4 * (DX) .* B + lambda5 * D1' * D1 * X1 .* B);
YS = I * ( lambda1 * Y + lambda3 * D1' * D1 * Y + lambda4 * (DY) .* B + lambda5 * D1' * D1 * Y1 .* B);

%Closed spline
if closed
    XS = [XS; XS(1)];
    YS = [YS; YS(1)];
end

end