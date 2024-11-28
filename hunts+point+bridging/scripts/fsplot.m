% fsplot.m
% Makes a false-color plot of factor of safety along the beam and returns
% the beam's overall factor of safety, given the properties of the
% I-beam's cross-section and three shear and moment equations.
% High stresses / low factors of safety are indicated by blue/green colors,
% while red colors indicate low stresses / high factors of safety
% Uses user-defined function stressstate.m
% NOTE: Please pay close attention to the input and output units
% First created February 21, 2013 by Itai Axelrad
%
% Input Variables:
% sigma\_max = Yield strength of material being used for the beam, in KSI
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
% beamIxx = Moment of inertia of cross-section about the XX-axis, in
%   INCHES^4
%
% Output Variables:
% FS = Factor of Safety for the beam
% Create an x and y range over which to evaluate
% Range should cover the entire beam
function \ [FS \] = fsplot(sigma \ _max, v1, M1, r1, ...
        v2, M2, r2, v3, M3, r3, beamd, beambf, beamtf, beamtw, beamIxx, mat)

    x \ _min = min(\ [r1 r2 r3 \]);
    x \ _max = max(\ [r1 r2 r3 \]);
    x \ _range = \ [x \ _min:0.1:x \ _max \];
    y \ _range = linspace(-beamd / 2, beamd / 2, 50);
    % Use meshgrid to convert these into matching matrices of points
    \ [x \ _mesh, y \ _mesh \] = meshgrid(x \ _range, y \ _range);
    % Generate arrays for the stress states
    \ [sigma \ _xx, sigma \ _yy, tau \ _xy, minprinc, maxprinc, thetap1, thetap2 \] = ...
        stressstate(x \ _mesh, y \ _mesh, v1, M1, r1, v2, M2, r2, v3, M3, r3, 0, ...
        beamd, beambf, beamtf, beamtw, beamIxx);
    % Generate an array for factor of safety
    \ [m, n \] = size(x \ _mesh);
    FS \ _plot = zeros(\ [m n \]); % Preallocate factor of safety plot
    FS \ _plot = (sigma \ _max \* ones(size(minprinc))) ./ sqrt(minprinc.^2 - ...
        minprinc. \* maxprinc + maxprinc.^2);
    % Make false color plot of beam
    figure
    shading interp
    h = pcolor(x \ _mesh, y \ _mesh, FS \ _plot);
    contourcbar % Draw color bar
    caxis(\ [0 10 \])
    set(h, 'edgecolor', 'none'); % Disable edge color so that plot is visible
    % Approach from http://www.mathworks.com/support/solutions/en/data/
    % 1-1U78P7/index.html?product=SL&solution=1-1U78P7
    title(\ ['Factor of Safety Plot, ' mat \])
    xlabel('Horizontal Position (Feet)')
    ylabel('Vertical Position (Inches)')
    % Create and draw lines to indicate the flanges on the beams
    flange \ _x = \ [x \ _min x \ _max \];
    flange \ _y1 = (beamd - beambf) / 2 \* ones(\ [1 2 \]);
    flange \ _y2 = -(beamd - beambf) / 2 \* ones(\ [1 2 \]);
    hold on
    plot(flange \ _x, flange \ _y1, 'k', flange \ _x, flange \ _y2, 'k')
    hold off
    FS = min(min(FS \ _plot));
