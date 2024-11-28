% stressstate.m
% Calculates the state of stress at an arbitrary point on a beam, given the
% properties of the I-beam's cross-section and three shear and moment
% equations.
% NOTE: Please pay close attention to the input and output units
% First created February 16, 2013 by Itai Axelrad
%
% Input Variables:
% x = Horizontal location on the beam, in FEET, for which the stress state
%   is desired
% y = Vertical location from the neutral axis on the beam, in INCHES, for
%   which the stress state is desired
% v1, v2, v3 = Function handles for three shear force equations, in KIPS
% M1, M2, M3 = Function handles for three bending moment equations, in
%   KIP-FEET
% r1, r2, r3 = Vectors indicating the range in FEET over which each
%   shear/moment equation is valid. rx(1) is the lower bound, rx(2) is the
%   upper bound
% theta\_d = Angle of stress transformation, in DEGREES
% beamd = Cross-section beam depth, in INCHES
% beambf = Flange width, in INCHES
% beamtf = Flange thickness, in INCHES
% beamtw = Web thickness, in INCHES
% beamIxx = Moment of inertia of cross-section about the XX-axis, in
%   INCHES^4
%
% Output Variables:
% sigma\_xxp = Axial stress, in the xx direction, in KSI
% sigma\_yyp = Axial stress, in the yy direction, in KSI
% tau\_xyp = Shear stress, on the xy plane, in KSI
% min\_princ = Minimum principal stress, in KSI
% max\_princ = Maximum principal stress, KSI
% thetap1, thetap2 = Principal stress angles, in DEGREES
% If matrices of points are entered, check that the dimensions of x and y
% match
function \ [sigma \ _xxp, sigma \ _yyp, tau \ _xyp, min \ _princ, max \ _princ, thetap1, ...
            thetap2 \] = stressstate(x, y, v1, M1, r1, v2, M2, r2, v3, M3, r3, ...
    theta \ _d, beamd, beambf, beamtf, beamtw, beamIxx)
\ [m, n \] = size(x);
\ [o, p \] = size(y);

if (m ~= o) || (n ~= p)
    error('Matrices x and y must have the same dimensions')
end

% If the dimensions do match, iterate through all pairings of x and y, and
% find the stress state for those points
% Preallocate matrices to return the stress states
sigma \ _xx = zeros(\ [m n \]);
sigma \ _yy = zeros(\ [m n \]);
tau \ _xy = zeros(\ [m n \]);
min \ _princ = zeros(\ [m n \]);
max \ _princ = zeros(\ [m n \]);
thetap1 = zeros(\ [m n \]);
thetap2 = zeros(\ [m n \]);
% Iterate through points
% Do in loops rather than as matrix operations because if statements are
% needed for logic to work
for i = 1:m

    for j = 1:n
        % Make sure that y is not outside the thickness of the beam
        if abs(y(i, j)) > beamd / 2
            fprintf('x = %d y = %d\\n', x(i, j), y(i, j))
            error('y must be a point on the beam.')
        end

        % Calculation Section
        % Calculate the shear force and moment at the given point
        % In the process, convert moments from pound-feet to pound-inches
        if (x(i, j) >= r1(1)) && (x(i, j) <= r1(2))
            v = v1(x(i, j));
            M = M1(x(i, j)) \* 12;
        elseif (x(i, j) >= r2(1)) && (x(i, j) <= r2(2))
            v = v2(x(i, j));
            M = M2(x(i, j)) \* 12;
        elseif (x(i, j) >= r3(1)) && (x(i, j) <= r3(2))
            v = v3(x(i, j));
            M = M3(x(i, j)) \* 12;
        else
            fprintf('x = %d y = %d\\n', x(i, j), y(i, j))
            error('X must be within a range given for one of the equations.')
        end

        % sigma\_yy will always be zero, since this is not a pressure vessel
        % Therefore, no need to reassign the default zeros matrix
        % sigma\_xx comes from the moment, = -My/I
        sigma \ _xx(i, j) = -M \* y(i, j) / beamIxx;
        % tau\_xy comes from the shear, VQ/It
        % Calculate Q and determine t
        if abs(y(i, j)) <= (beamd / 2 - beamtf)
            % Add the shear flow regions' areas times their centroids
            Q = ((beamtf \* beambf) \* (beamd / 2 - beamtf / 2) + ...
                (((beamd / 2 - beamtf) + abs(y(i, j))) / 2) \* ...
                ((beamd / 2 - beamtf - abs(y(i, j))) \* beamtw));
            t = beamtw;
        else
            Q = ((beamd / 2 - abs(y(i, j))) \* beambf) \* ((beamd / 2 + abs(y(i, j))) / 2);
            t = beambf;
        end

        % Calculate tau\_xy
        % Use a negative v to compensate for the fact that the sign conventions for
        % beam shear and Mohr's circle are opposite.
        tau \ _xy(i, j) = -v \* Q / (beamIxx \* t);
        % Principal planes and stresses given sigma\_xx, sigma\_yy and tau\_xy
        A = \ [sigma \ _xx(i, j) tau \ _xy(i, j); tau \ _xy(i, j) sigma \ _yy(i, j) \];
        \ [vectors, values \] = eig(A);
        min \ _princ(i, j) = values(1, 1);
        max \ _princ(i, j) = values(2, 2);
    end

    % Stress Transformation for Mohr's Circle given theta, sigma\_xx, sigma\_yy and tau\_xy
    theta = theta \ _d \* pi / 180;
    sigma \ _xxp = ((sigma \ _xx + sigma \ _yy) / 2) + ((sigma \ _xx - sigma \ _yy) / 2). \* cos(2 \* theta) + (tau \ _xy. \* sin(2 \* theta));
    sigma \ _yyp = ((sigma \ _xx + sigma \ _yy) / 2) - ((sigma \ _xx - sigma \ _yy) / 2). \* cos(2 \* theta) - (tau \ _xy. \* sin(2 \* theta));
    tau \ _xyp = -((sigma \ _xx - sigma \ _yy) / 2). \* sin(2 \* theta) + (tau \ _xy. \* cos(2 \* theta));
    % Instead of displaying the eigenvectors we have chosen the tangent formula
    % to calculate the principal angles because we want to show the
    % transformation angle instead of the orientation vectors.
    thetap1 = (atan((2 \* tau \ _xy) ./ (sigma \ _xx - sigma \ _yy)) / 2) \* 180 / (pi);
    thetap2 = thetap1 + 90;
end
