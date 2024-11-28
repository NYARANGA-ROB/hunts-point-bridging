%shear\_moment.m calculates the reaction forces and the maximum shear and
%maximum bending moments for an overpass under a uniformly distributed
%load, with two symetrical suports in the middle.
%Created by Itai Axelrad
%on February 15, 2013
%
%input arguments:
%w=distributed load in kips
%L=length of the overpass in feet
%a=the distance from the end of the overpass to the closest middle support,
%  in feet.
%P=support reaction of centermost supports in kips. Assumes symmetrical beam.
%R=support reaction of outermost supports in kips. Assumes symmetrical beam.
%Output arguments:
%min\_shear=minimum shear along the beam in kips
%min\_moment=minimum bending moment along the beam in kip-feet
%max\_shear=maximum shear along the beam in kips
%max\_moment=maximum bending moment along the beam in kip-feet
%V1,V2,V3=Function handles for shear equations. Take argument x in feet and
%   return shear in kips
%M1,M2,M3=Function handles for moment equations. Take argument x in feet
%   and return bending moment in kip-feet.
function \ [min \ _shear, min \ _moment, max \ _shear, max \ _moment, V1func, V2func, ...
            V3func, M1func, M2func, M3func \] = shear \ _moment(w, L, a, P, R)
%Shear and Moment for 0 <= x <= a
x1 = 0:a;
V1func = @(x1) R - w \* x1;
V1 = V1func(x1);
M1func = @(x1) R \* x1 - (w / 2) \* x1.^2;
M1 = M1func(x1);
%Shear and Moment for a <= x <= L - a
x2 = a:(L - a);
V2func = @(x2) R + P - (w \* x2);
V2 = V2func(x2);
M2func = @(x2) -(-(R \* x2) - (P \* (x2 - a)) + ((w / 2) \* (x2.^2)));
M2 = M2func(x2);
%Shear and Moment for L - a <= x <= L
x3 = (L - a):L;
V3func = @(x3) -R + w \* (L - x3);
V3 = V3func(x3);
M3func = @(x3) R \* (L - x3) - ((w / 2) \* ((L - x3).^2));
M3 = M3func(x3);
% Add connecting lines between shear
V0 \ _5 = \ [0 V1(1) \];
x0 \ _5 = \ [x1(1) x1(1) \];
V1 \ _5 = \ [V1(end) V2(1) \];
x1 \ _5 = \ [x1(end) x2(1) \];
V2 \ _5 = \ [V2(end) V3(1) \];
x2 \ _5 = \ [x2(end) x3(1) \];
V3 \ _5 = \ [V3(end) 0 \];
x3 \ _5 = \ [x3(end) x3(end) \];
A = \ [min(V1) min(V2) min(V3) \];
B = \ [min(M1) min(M2) min(M3) \];
C = \ [max(V1) max(V2) max(V3) \];
D = \ [max(M1) max(M2) max(M3) \];
min \ _shear = min(A);
min \ _moment = min(B);
max \ _shear = max(C);
max \ _moment = max(D);
% Make axes for shear/moment plots
xaxis \ _x = \ [x1(1) - 1 x3(end) + 1 \];
xaxis \ _y = zeros(size(xaxis \ _x));
yaxis \ _V = \ [-1.1 \* max(abs(\ [min \ _shear max \ _shear \])) 1.1 \* max(abs(\ [min \ _shear ...
                                                                                    max \ _shear \])) \];
yaxis \ _M = \ [-1.1 \* max(abs(\ [min \ _moment max \ _moment \])) 1.1 \* max(abs(\ [min \ _moment ...
                                                                                    max \ _moment \])) \];
yaxis \ _x = zeros(size(yaxis \ _V));
subplot(2, 1, 1)
plot(x1, V1, 'r', x1 \ _5, V1 \ _5, 'r', x2, V2, 'r', x2 \ _5, V2 \ _5, 'r', x3, V3, 'r', ...
    x3 \ _5, V3 \ _5, 'r', xaxis \ _x, xaxis \ _y, 'k', yaxis \ _x, yaxis \ _V, 'k', x0 \ _5, V0 \ _5, 'r');
grid
xlabel('length (ft)')
ylabel('shear (kips)')
legend('Shear')
title('Shear Diagram')
subplot(2, 1, 2)
plot(x1, M1, 'b', x2, M2, 'b', x3, M3, 'b', xaxis \ _x, xaxis \ _y, 'k', yaxis \ _x, yaxis \ _M, 'k');
grid
xlabel('length (ft)')
ylabel('moment (kip-ft)')
legend('Moment')
title('Bending Moment Diagram')
fprintf('\\n Min Shear(kips)   Max Shear(kips)   Min Moment(kip-ft)  Max Moment(kip-ft)\\n')
fprintf('%10.3f        %10.3f          %10.3f          %10.3f\\n', min \ _shear, max \ _shear, min \ _moment, max \ _moment)
