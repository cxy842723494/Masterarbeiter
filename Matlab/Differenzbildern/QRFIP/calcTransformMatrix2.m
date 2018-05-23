function H = calcTransformMatrix2(u, v, x, y)

%% Normalisierung sodass ||H(:)|| = 1

s1 = sqrt(2/(mean((u-mean(u)).^2+(v-mean(v)).^2)));
s2 = sqrt(2/(mean((x-mean(x)).^2+(y-mean(y)).^2)));
T1 = [s1 0 -s1*mean(u);
      0 s1 -s1*mean(v);
      0 0 1];
T2 = [s2 0 -s2*mean(x);
      0 s2 -s2*mean(y);
      0 0 1];

uvhat = T1 * [u; v; ones(size(u))];
uhat = uvhat(1,:);
vhat = uvhat(2,:);

xyhat = T2 * [x; y; ones(size(x))];
xhat = xyhat(1,:);
yhat = xyhat(2,:);

u = uhat; v = vhat; x = xhat; y = yhat;

Q = [...
u(1)    v(1)    1       0       0       0   -u(1)*x(1)  -v(1)*x(1)  -x(1);
0       0       0       u(1)    v(1)    1   -u(1)*y(1)  -v(1)*y(1)  -y(1);
u(2)    v(2)    1       0       0       0   -u(2)*x(2)  -v(2)*x(2)  -x(2);
0       0       0       u(2)    v(2)    1   -u(2)*y(2)  -v(2)*y(2)  -y(2);
u(3)    v(3)    1       0       0       0   -u(3)*x(3)  -v(3)*x(3)  -x(3);
0       0       0       u(3)    v(3)    1   -u(3)*y(3)  -v(3)*y(3)  -y(3);
u(4)    v(4)    1       0       0       0   -u(4)*x(4)  -v(4)*x(4)  -x(4);
0       0       0       u(4)    v(4)    1   -u(4)*y(4)  -v(4)*y(4)  -y(4);
];

[U, D, V] = svd(Q);
H = V(:,end);

H = reshape(H, 3, 3).';
H = inv(T2)*H*T1;
% H = T2.'*H*T1;