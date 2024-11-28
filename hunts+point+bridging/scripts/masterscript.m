%
% masterscript.m
% First created February 21, 2013 by Itai Axelrad
% Runs all seven function and organizes outputs and plots
% Uses user-defined functions: LUfact.m, shear\_moment.m, wbeamselect.m,
% ang\_disp.m, stressstate.m, transplot.m and fsplot.m
%
% Input Variables:
% w=distributed load in kips
% L=lenght of the overpass in feet
% a=the distance from the end of the overpass to the closest middle support
% b=length from edge support to third support in feet
% E\_steel=Modulus of elasticity for structural steel in ksi
% E\_Al=Modulus of elasticity for aluminum alloy 7075-T6 in ksi
% E\_Ti=Modulus of elasticity for titanium in ksi
% Y\_Steel=Yielding strength for structural steel in ksi
% Y\_Al=Yielding strength for aluminum alloy 7075-T6 in ksi
% Y\_Ti=Yielding stregth for titanium in ksi
% FS=Design factor of safety
%
% Output Variables:
% root = location where bending moment is zero
% FSS = factor of safety for structural steel
% FSAl = factor of safety for Aluminum alloy 7075-T6
% FSTi = factor of safety for Titanium
%
clc
clear all
close all
L = 280;
a = 90; if a >= L, error('a must be less than L'), end;
b = L - a; if L - b ~= a, error('beam is not symmetrical'), end;
w = 2.1;
E \ _steel = 29000; %Modulus of elasticity for structural steel in ksi
E \ _Al = 10400; %Modulus of elasticity for aluminum alloy 7075-T6 in ksi
E \ _Ti = 16500; %Modulus of elasticity for titanium in ksi
Y \ _Steel = 58; %Yielding strength for structural steel in ksi
Y \ _Al = 73; %Yielding strength for aluminum alloy 7075-T6 in ksi
Y \ _Ti = 120; %Yielding stregth for titanium in ksi
FS = 2.2; %Design factor of safety
A = \ [1 1 1 1; 0 a b L; 0 ((a^2) \* (b^2)) / (3 \* L) -(2 \* (a^4) - (a^2) \* (L^2)) / (6 \* L) 0; ...
        0 -(((a^3) \* L) - (3 \* b \* L \* a^2) + (3 \* a \* L \* b^2) + (2 \* b^4) - (L \* b^3) - ((b^2) \* (L^2))) / (6 \* L) ((a^2) \* (b^2)) / (3 \* L) 0 \];
B = \ [w \* L; ((w \* L^2) / 2); (w / 24) \* ((a^4) - (2 \* L \* a^3) + (a \* L^3)); (w / 24) \* ((b^4) - (2 \* L \* b^3) + (b \* L^3)) \];
R = LUfact(A, B); %R = reactions.
% Calculate and plot Shear and Moment
\ [min \ _shear, min \ _moment, max \ _shear, max \ _moment, V1func, V2func, ...
        V3func, M1func, M2func, M3func \] = shear \ _moment(w, L, a, R(2), R(1));
% Find locations where moment is zero
root = zeros(\ [1 6 \]); % Preallocate an array for roots
root(1) = fzero(M1func, \ [0 a / 2 \]);
root(2) = fzero(M1func, \ [a / 2 a \]);
root(3) = fzero(M2func, \ [a L / 2 \]);
root(4) = fzero(M2func, \ [L / 2 L - a \]);
root(5) = fzero(M3func, \ [L - a L - a / 2 \]);
root(6) = fzero(M3func, \ [L - a / 2 L \]);
fprintf('\\nMoment is zero at points (feet):\\n')
fprintf('%10.3f  %10.3f  %10.3f %10.3f %10.3f %10.3f\\n', root)
% Perform analyses on structural steel
fprintf('\\n Structural Steel \\n')
\ [name, A, d, bf, tf, tw, Ixx \] = wbeamselect(max(abs(\ [min \ _moment max \ _moment \])), ...
    Y \ _Steel, FS);
% Calculate and plot slope and displacement of the beam
\ [min \ _slope, min \ _displacement, max \ _slope, max \ _displacement \] = ang \ _disp(w, R(2), L, a, E \ _steel, Ixx, 'Structural Steel');
% Calculate stress at arbitrary state (100ft,9in) and angle theta of 45 degrees
theta \ _d = 45;
\ [sigma \ _xxp, sigma \ _yyp, tau \ _xyp, min \ _princ, max \ _princ, thetap1, thetap2 \] ...
    = stressstate(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    theta \ _d, d, bf, tf, tw, Ixx);
fprintf('\\n sigma xx (ksi)    sigma yy(ksi)   tau xy(ksi)   angle(degrees)\\n')
fprintf('%10.3f    %10.3f      %10.3f     %10.3f\\n', sigma \ _xxp, sigma \ _yyp, tau \ _xyp, theta \ _d)
fprintf('\\n Principle Stresses (ksi)         Principle Planes (degrees) \\n')
fprintf('%10.3f     %10.3f      %10.3f     %10.3f\\n', min \ _princ, max \ _princ, thetap1, thetap2)
% Plot stresses with respect to angle and Mohr's Circle at (100ft,9in)
transplot(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Structural Steel');
% Make false-color plot of Factor of Safety
FSS = fsplot(Y \ _Steel, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Structural Steel');
fprintf('\\n Overall Factor of Safety: %f\\n', FSS)
%----------------------------------------------------------------------------
% Perform analyses on Aluminum alloy 7075-T6
fprintf('\\n Aluminum alloy 7075-T6 \\n')
\ [name, A, d, bf, tf, tw, Ixx \] = wbeamselect(max(abs(\ [min \ _moment max \ _moment \])), ...
    Y \ _Al, FS);
% Calculate and plot slope and displacement of the beam
\ [min \ _slope, min \ _displacement, max \ _slope, max \ _displacement \] = ang \ _disp(w, R(2), L, a, E \ _Al, Ixx, 'Aluminum alloy 7075-T6');
% Calculate stress at arbitrary state (100ft,9in) and angle theta of 45 degrees
theta \ _d = 45;
\ [sigma \ _xxp, sigma \ _yyp, tau \ _xyp, min \ _princ, max \ _princ, thetap1, thetap2 \] ...
    = stressstate(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    theta \ _d, d, bf, tf, tw, Ixx);
fprintf('\\n sigma xx (ksi)    sigma yy(ksi)   tau xy(ksi)   angle(degrees)\\n')
fprintf('%10.3f    %10.3f      %10.3f     %10.3f\\n', sigma \ _xxp, sigma \ _yyp, tau \ _xyp, theta \ _d)
fprintf('\\n Principle Stresses (ksi)         Principle Planes (degrees) \\n')
fprintf('%10.3f     %10.3f      %10.3f     %10.3f\\n', min \ _princ, max \ _princ, thetap1, thetap2)
% Plot stresses with respect to angle and Mohr's Circle at (100ft,9in)
transplot(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Aluminum alloy 7075-T6');
% Make false-color plot of Factor of Safety
FSAl = fsplot(Y \ _Al, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Aluminum alloy 7075-T6');
fprintf('\\n Overall Factor of Safety: %f\\n', FSAl)
%----------------------------------------------------------------------------
% Perform analyses on Titanium
fprintf('\\n Titanium \\n')
\ [name, A, d, bf, tf, tw, Ixx \] = wbeamselect(max(abs(\ [min \ _moment max \ _moment \])), ...
    Y \ _Ti, FS);
% Calculate and plot slope and displacement of the beam
\ [min \ _slope, min \ _displacement, max \ _slope, max \ _displacement \] = ang \ _disp(w, R(2), L, a, E \ _Ti, Ixx, 'Titanium');
% Calculate stress at arbitrary state (100ft,9in) and angle theta of 45 degrees
theta \ _d = 45;
\ [sigma \ _xxp, sigma \ _yyp, tau \ _xyp, min \ _princ, max \ _princ, thetap1, thetap2 \] ...
    = stressstate(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    theta \ _d, d, bf, tf, tw, Ixx);
fprintf('\\n sigma xx (ksi)    sigma yy(ksi)   tau xy(ksi)   angle(degrees)\\n')
fprintf('%10.3f    %10.3f      %10.3f     %10.3f\\n', sigma \ _xxp, sigma \ _yyp, tau \ _xyp, theta \ _d)
fprintf('\\n Principle Stresses (ksi)         Principle Planes (degrees) \\n')
fprintf('%10.3f     %10.3f      %10.3f     %10.3f\\n', min \ _princ, max \ _princ, thetap1, thetap2)
% Plot stresses with respect to angle and Mohr's Circle at (100ft,9in)
transplot(100, 9, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Titanium');
% Make false-color plot of Factor of Safety
FSTi = fsplot(Y \ _Ti, V1func, M1func, \ [0 a \], V2func, M2func, \ [a b \], V3func, M3func, \ [b L \], ...
    d, bf, tf, tw, Ixx, 'Titanium');
fprintf('\\n Overall Factor of Safety: %f\\n', FSTi)
