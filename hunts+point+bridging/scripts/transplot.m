% transplot.m
% Run wbeamselect to determine I-beam properties
% Run stressstate function to determine sigma\_xxp, sigma\_yyp and tau\_xyp
% Plot sigma\_xxp, sigma\_yyp and tau\_xyp versus theta
% Plot Mohr's Circle with R from points (sigma\_xx,tau\_xy) and (sigma\_yy,tau\_xy)
% Created February 22, 2013 by Itai Axelrad
% -
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
% beamd = Cross-section beam depth, in INCHES
% beambf = Flange width, in INCHES
% beamtf = Flange thickness, in INCHES
% beamtw = Web thickness, in INCHES
% beamIxx = Moment of inertia of cross-section about the XX-axis, in INCHES^4
% mat = Name of material used
% -
function transplot(x, y, v1, M1, r1, v2, M2, r2, v3, M3, r3, ...
        beamd, beambf, beamtf, beamtw, beamIxx, mat)

    theta \ _d = 0:360;
    sigma \ _xxp = zeros(size(theta \ _d));
    sigma \ _yyp = zeros(size(theta \ _d));
    tau \ _xyp = zeros(size(theta \ _d));

    for i = 1:length(theta \ _d)
        \ [sigma \ _xxp(i), sigma \ _yyp(i), tau \ _xyp(i), min \ _princ, max \ _princ \] = stressstate(x, y, v1, M1, r1, v2, M2, r2, v3, M3, r3, ...
            theta \ _d(i), beamd, beambf, beamtf, beamtw, beamIxx);
    end

    % Generate points for axes
    xaxis \ _y = zeros(size(theta \ _d));
    yaxis \ _y = \ [-1.1 \* max(abs(sigma \ _xxp)) 1.1 \* max(abs(sigma \ _xxp)) \];
    yaxis \ _x = zeros(size(yaxis \ _y));
    % Plot: sigma\_xxp, sigma\_yyp and tau\_xyp versus theta
    figure
    plot(theta \ _d, sigma \ _xxp, '-r', theta \ _d, sigma \ _yyp, '-b', theta \ _d, tau \ _xyp, '-g', ...
        theta \ _d, xaxis \ _y, 'k', yaxis \ _x, yaxis \ _y, 'k')
    title(\ ['Stress Transformation vs. Theta, ' mat \])
    xlabel('Theta')
    legend('sigma xx', 'sigma yy', 'tau xy')
    % Plot: Mohr's Circle
    r = (max \ _princ - min \ _princ) / 2;
    sigma \ _avg = (max \ _princ + min \ _princ) / 2;
    xx = \ [sigma \ _avg - 1.1 \* r sigma \ _avg + 1.1 \* r \];
    yy = \ [-1.1 \* r 1.1 \* r \];
    sigma = \ [sigma \ _yyp(1) sigma \ _xxp(1) \];
    tau = \ [-tau \ _xyp(1) tau \ _xyp(1) \];
    figure
    plot(sigma \ _xxp, -tau \ _xyp, '-r', xx, zeros(size(xx)), '-black', zeros(size(yy)), yy, '-black', sigma, tau, '-or')
    title(\ ['Mohrs Circle, ' mat \])
    xlabel('Sigma(psi)')
    ylabel('Tau(psi)')
    legend('Mohrs Circle')
end
