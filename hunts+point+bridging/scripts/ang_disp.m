% First created February 16, 2013 by Itai Axelrad
%ang\_disp.m calculatets the maximum and minimum slope and maximum and minimum displacement
%for an I-beam in an overpass under a uniformly distributed
%load, with two symmetrical suports in the middle.
%input arguments:
%w=distributed load in kips
%L=lenght of the overpass in feet
%E=modulus of elasticity for the I-beam in ksi
%I=moment of inertia for the I-beam in inches^4
%a=the distance from the end of the overpass to the closest middle support, in feet.
% P = reactions at center supports in kips
% mat = name of material being used
%Output arguments
%min\_slope = minimum slope on beam, unitless
%min\_displacement = minimum displacement on beam, in inches
%max\_slope = maximum slope on beam, unitless
%max\_displacement = maximum displacement on beam, in inches
function \ [min \ _slope, min \ _displacement, max \ _slope, max \ _displacement \] = ang \ _disp(w, P, L, a, E, I, mat)
    %Slope and Deflection for 0 <= x <= a
    x1 = 0:a;
    theta1 = (-w / (24 \* E \* I)) \* (L^3 - 6 \* L \* x1.^2 + 4 \* x1.^3) + (P / (2 \* E \* I)) \* (L \* a - a^2 - x1.^2);
    delta1 = 12 \* ((-w / (24 \* E \* I)) \* (L^3 \* x1 - 2 \* L \* x1.^3 + x1.^4) + (P / (6 \* E \* I)) \* (3 \* L \* a \* x1 - 3 \* a^2 \* x1 - x1.^3));
    %Slope, and Deflection for a <= x <= L - a
    x2 = a:(L - a);
    theta2 = (-w / (24 \* E \* I)) \* (L^3 - 6 \* L \* x2.^2 + 4 \* x2.^3) + (P \* a / (2 \* E \* I)) \* (L - 2 \* x2);
    delta2 = 12 \* ((-w / (24 \* E \* I)) \* (L^3 \* x2 - 2 \* L \* x2.^3 + x2.^4) + (P \* a / (6 \* E \* I)) \* (3 \* L \* x2 - 3 \* x2.^2 - a^2));
    %Slope, and Deflection for L - a <= x <= L
    x3 = (L - a):L;
    theta3 = -((-w / (24 \* E \* I)) \* (L^3 - 6 \* L \* (L - x3).^2 + 4 \* (L - x3).^3) + (P / (2 \* E \* I)) \* (L \* a - a^2 - (L - x3).^2));
    delta3 = 12 \* ((-w / (24 \* E \* I)) \* (L^3 \* (L - x3) - 2 \* L \* (L - x3).^3 + (L - x3).^4) + (P / (6 \* E \* I)) \* (3 \* L \* a \* (L - x3) - 3 \* a^2 \* (L - x3) - (L - x3).^3));
    % Minimum and Maximum slope and displacement
    A = \ [min(theta1) min(theta2) min(theta3) \];
    B = \ [min(delta1) min(delta2) min(delta3) \];
    C = \ [max(theta1) max(theta2) max(theta3) \];
    D = \ [max(delta1) max(delta3) max(delta3) \];
    min \ _slope = min(A);
    min \ _displacement = min(B);
    max \ _slope = max(C);
    max \ _displacement = max(D);
    % Make axes for shear/moment plots
    xaxis \ _x = \ [x1(1) - 1 x3(end) + 1 \];
    xaxis \ _y = zeros(size(xaxis \ _x));
    yaxis \ _S = \ [-1.1 \* max(abs(\ [min \ _slope max \ _slope \])) 1.1 \* max(abs(\ [min \ _slope ...
                                                                                        max \ _slope \])) \];
    yaxis \ _D = \ [-1.1 \* max(abs(\ [min \ _displacement max \ _displacement \])) 1.1 \* max(abs(\ [min \ _displacement ...
                                                                                                    max \ _displacement \])) \];
    yaxis \ _x = zeros(size(yaxis \ _S));
    figure
    subplot(2, 1, 1)
    plot(x1, theta1, 'r', x2, theta2, 'r', x3, theta3, 'r', xaxis \ _x, xaxis \ _y, 'k', yaxis \ _x, yaxis \ _S, 'k');
    grid
    xlabel('length (ft)')
    ylabel('angle')
    legend('Slope')
    title(\ ['Slope Diagram, ' mat \])
    subplot(2, 1, 2)
    plot(x1, delta1, 'b', x2, delta2, 'b', x3, delta3, 'b', xaxis \ _x, xaxis \ _y, 'k', yaxis \ _x, yaxis \ _D, 'k');
    grid
    xlabel('length (ft)')
    ylabel('displacement (ft)')
    legend('Displacement')
    title(\ ['Displacement Diagram, ' mat \])
    fprintf('\\n Min Slope     Max Slope     Min Displacement(in)   Max Displacement(in)\\n')
    fprintf('%10.3d    %10.3d     %10.3d        %10.3d\\n', min \ _slope, max \ _slope, min \ _displacement, max \ _displacement)
