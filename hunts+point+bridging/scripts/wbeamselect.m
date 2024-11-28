% wbeamselect.m
% Selects a standard wide-flanged I-beam cross section based on a given
% maximum moment, material yield stress, and factor of safety.
% NOTE: Please pay close attention to the input and output units
% Follows method described in Mechanics of Materials, Sixth Edition by
% Beer, Section 5.4.
% First created February 15, 2013 by Itai Axelrad
%
% Input Variables:
%   M\_max = Maximum moment experienced by the beam, in KIP-FEET
%   sigma\_max = Yield strength of material being used for the beam, in KSI
%   FS = Factor of safety for the design
%
% Output Variables:
%   name = Selected beam's designation
%   A = Beam's cross-sectional area, in square INCHES
%   d = Beam's depth, in INCHES
%   bf = Flange width of the beam, in INCHES
%   tf = Flange thickness, in INCHES
%   tw = Web thickness, in INCHES
%   Ixx = Moment of inertia about the XX axis, in (INCHES)^4
% Parameter Values
% Beam properties taken from Mechanics of Materials, Sixth Edition by Beer,
% Appendix C
function \ [name, A, d, bf, tf, tw, Ixx \] = wbeamselect(M \ _max, sigma \ _max, FS)
    % Convert kip-feet to kip-inches
    M \ _max = M \ _max \* 12;
    % Number of cross sections in each beam category
    size \ _list = \ [2 2 2 2 2 3 4 5 10 9 10 11 5 2 1 \]';
    % Cross-section designations
    name \ _list = {'W36 x 302' 'W36 x 135' '' '' '' '' '' '' '' '' ''; % W36
                'W33 x 201''W33 x 118' '' '' '' '' '' '' '' '' ''; % W33
                'W30 x 173''W30 x 99' '' '' '' '' '' '' '' '' ''; % W30
                'W27 x 146''W27 x 84' '' '' '' '' '' '' '' '' ''; % W27
                'W24 x 104''W24 x 68' '' '' '' '' '' '' '' '' ''; % W24
                'W21 x 101''W21 x 62''W21 x 44' '' '' '' '' ... % W21
                    '' '' '' '';
                'W18 x 106''W18 x 76''W18 x 50''W18 x 35' '' ... % W18
                    '' '' '' '' '' '';
                'W16 x 77''W16 x 57''W16 x 40''W16 x 31' ... % W16
                    'W16 x 26' '' '' '' '' '' '';
                'W14 x 370''W14 x 145''W14 x 82''W14 x 68' ... % W14
                    'W14 x 53''W14 x 43''W14 x 38''W14 x 30' ...
                    'W14 x 26''W14 x 22' '';
                'W12 x 96''W12 x 72''W12 x 50''W12 x 40' ... % W12
                    'W12 x 35''W12 x 30''W12 x 26''W12 x 22''W12 x 16' '' '';
                'W10 x 112''W10 x 68''W10 x 54''W10 x 45' ... % W10
                    'W10 x 39''W10 x 33''W10 x 30''W10 x 22' ...
                    'W10 x 19''W10 x 15' '';
                'W8 x 58''W8 x 48''W8 x 40''W8 x 35' ... % W8
                    'W8 x 31''W8 x 28''W8 x 24''W8 x 21' ...
                    'W8 x 18''W8 x 15''W8 x 13';
                'W6 x 25''W6 x 20''W6 x 16''W6 x 12' ... % W6
                    'W6 x 9' '' '' '' '' '' '';
                'W5 x 19''W5 x 16' '' '' '' '' '' '' '' '' ''; % W5
                'W4 x  13' '' '' '' '' '' '' '' '' '' ''}; % W4
    % Beam Weights (Matches second number of designation), in pounds per foot
    weight \ _list = \ [302 135 0 0 0 0 0 0 0 0 0; % W36
                    201 118 0 0 0 0 0 0 0 0 0; % W33
                    173 99 0 0 0 0 0 0 0 0 0; % W30
                    146 84 0 0 0 0 0 0 0 0 0; % W27
                    104 68 0 0 0 0 0 0 0 0 0; % W24
                    101 62 44 0 0 0 0 0 0 0 0; % W21
                    106 76 50 35 0 0 0 0 0 0 0; % W18
                    77 57 40 31 26 0 0 0 0 0 0; % W16
                    370 145 82 68 53 43 38 30 26 22 0; % W14
                    96 72 50 60 35 30 26 22 16 0 0; % W12
                    112 68 54 45 39 33 30 22 19 15 0; % W10
                    58 48 40 35 31 28 24 21 18 15 13; % W8
                    25 20 16 12 9 0 0 0 0 0 0; % W6
                    19 16 0 0 0 0 0 0 0 0 0; % W5
                    13 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Cross sectional area, in square inches
    A \ _list = \ [88.8 39.7 0 0 0 0 0 0 0 0 0; % W36
                59.2 34.7 0 0 0 0 0 0 0 0 0; % W33
                51.0 29.1 0 0 0 0 0 0 0 0 0; % W30
                43.1 24.8 0 0 0 0 0 0 0 0 0; % W27
                30.6 20.1 0 0 0 0 0 0 0 0 0; % W24
                29.8 18.3 13.0 0 0 0 0 0 0 0 0; % W21
                31.1 22.3 14.7 10.3 0 0 0 0 0 0 0; % W18
                22.6 16.8 11.8 9.13 7.68 0 0 0 0 0 0; % W16
                109 42.7 24.0 20.0 15.6 12.6 11.2 8.85 7.69 6.49 0; % W14
                28.2 21.1 14.6 11.7 10.3 8.79 7.65 6.48 4.71 0 0; % W12
                32.9 20.0 15.8 13.3 11.5 9.71 8.84 6.49 5.62 4.41 0; % W10
                17.1 14.1 11.7 10.3 9.12 8.24 7.08 6.16 5.26 4.44 3.84; % W8
                7.34 5.87 4.74 3.55 2.68 0 0 0 0 0 0; % W6
                5.56 4.71 0 0 0 0 0 0 0 0 0; % W5
                3.83 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Beam Depth, in inches
    d \ _list = \ [37.3 35.6 0 0 0 0 0 0 0 0 0; % W36
                33.7 32.9 0 0 0 0 0 0 0 0 0; % W33
                30.4 29.7 0 0 0 0 0 0 0 0 0; % W30
                27.4 26.70 0 0 0 0 0 0 0 0 0; % W27
                24.1 23.7 0 0 0 0 0 0 0 0 0; % W24
                21.4 21.0 20.7 0 0 0 0 0 0 0 0; % W21
                18.7 18.2 18.0 17.7 0 0 0 0 0 0 0; % W18
                16.5 16.4 16.0 15.9 15.7 0 0 0 0 0 0; % W16
                17.9 14.8 14.3 14.0 13.9 13.7 14.1 13.8 13.9 13.7 0; % W14
                12.7 12.3 12.2 11.9 12.5 12.3 12.2 12.3 12.0 0 0; % W12
                11.4 10.4 10.1 10.1 9.92 9.73 10.5 10.2 10.2 10.0 0; % W10
                8.75 8.50 8.25 8.12 8.00 8.06 7.93 8.28 8.14 8.11 7.99; % W8
                6.38 6.20 6.28 6.03 5.90 0 0 0 0 0 0; % W6
                5.15 5.01 0 0 0 0 0 0 0 0 0; % W5
                4.16 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Flange Width, in inches
    bf \ _list = \ [16.7 12.0 0 0 0 0 0 0 0 0 0; % W36
                15.7 11.5 0 0 0 0 0 0 0 0 0; % W33
                15.0 10.50 0 0 0 0 0 0 0 0 0; % W30
                14.0 10.0 0 0 0 0 0 0 0 0 0; % W27
                12.8 8.97 0 0 0 0 0 0 0 0 0; % W24
                12.3 8.24 6.50 0 0 0 0 0 0 0 0; % W21
                11.2 11.0 7.50 6.00 0 0 0 0 0 0 0; % W18
                10.3 7.12 7.00 5.53 5.50 0 0 0 0 0 0; % W16
                16.5 15.5 10.1 10.0 8.06 8.00 6.77 6.73 5.03 5.00 0; % W14
                12.2 12.0 8.08 8.01 6.56 6.52 6.49 4.03 3.99 0 0; % W12
                10.4 10.1 10.0 8.02 7.99 7.96 5.81 5.75 4.02 4.00 0; % W10
                8.22 8.11 8.07 8.02 8.00 6.54 6.50 5.27 5.25 4.01 4.00; % W8
                6.08 6.02 4.03 4.00 3.94 0 0 0 0 0 0; % W6
                5.03 5.00 0 0 0 0 0 0 0 0 0; % W5
                4.06 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Flange Thickness, in inches
    tf \ _list = \ [1.68 0.790 0 0 0 0 0 0 0 0 0; % W36
                1.15 0.740 0 0 0 0 0 0 0 0 0; % W33
                1.07 0.670 0 0 0 0 0 0 0 0 0; % W30
                0.975 0.640 0 0 0 0 0 0 0 0 0; % W27
                0.750 0.585 0 0 0 0 0 0 0 0 0; % W24
                0.800 0.615 0.450 0 0 0 0 0 0 0 0; % W21
                0.940 0.680 0.570 0.425 0 0 0 0 0 0 0; % W18
                0.76 0.715 0.505 0.440 0.345 0 0 0 0 0 0; % W16
                2.66 1.09 0.855 0.720 0.660 0.530 0.515 0.385 ... % W14
                    0.420 0.335 0;
                0.900 0.670 0.640 0.515 0.520 0.440 0.380 0.425 ... % W12
                    0.265 0 0;
                1.25 0.770 0.615 0.620 0.530 0.435 0.510 0.360 ... % W10
                    0.395 0.270 0;
                0.810 0.685 0.560 0.495 0.435 0.465 0.400 0.400 ... % W8
                    0.330 0.315 0.255;
                0.455 0.365 0.405 0.280 0.215 0 0 0 0 0 0; % W6
                0.430 0.360 0 0 0 0 0 0 0 0 0; % W5
                0.345 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Web Thickness, in inches
    tw \ _list = \ [0.945 0.600 0 0 0 0 0 0 0 0 0; % W36
                0.715 0.550 0 0 0 0 0 0 0 0 0; % W33
                0.655 0.520 0 0 0 0 0 0 0 0 0; % W30
                0.605 0.460 0 0 0 0 0 0 0 0 0; % W27
                0.500 0.415 0 0 0 0 0 0 0 0 0; % W24
                0.500 0.400 0.350 0 0 0 0 0 0 0 0; % W21
                0.590 0.425 0.355 0.300 0 0 0 0 0 0 0; % W18
                0.455 0.430 0.305 0.275 0.250 0 0 0 0 0 0; % W16
                1.66 0.680 0.510 0.415 0.370 0.305 0.310 0.270 ... % W14
                    0.255 0.230 0;
                0.550 0.430 0.370 0.295 0.300 0.260 0.230 0.260 ... % W12
                    0.220 0 0;
                0.755 0.470 0.370 0.350 0.315 0.290 0.300 0.240 ... % W10
                    0.250 0.230 0;
                0.510 0.400 0.360 0.310 0.285 0.285 0.245 0.250 ... % W8
                    0.230 0.245 0.230;
                0.320 0.260 0.260 0.230 0.170 0 0 0 0 0 0; % W6
                0.270 0.240 0 0 0 0 0 0 0 0 0; % W5
                0.280 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Moment of Inertia about the XX axis, in (inches)^4
    Ixx \ _list = \ [21100 7800 0 0 0 0 0 0 0 0 0; % W36
                11600 5900 0 0 0 0 0 0 0 0 0; % W33
                8230 3990 0 0 0 0 0 0 0 0 0; % W30
                5660 2850 0 0 0 0 0 0 0 0 0; % W27
                3100 1830 0 0 0 0 0 0 0 0 0; % W24
                2420 1330 843 0 0 0 0 0 0 0 0; % W21
                1910 1330 800 510 0 0 0 0 0 0 0; % W18
                1110 758 518 375 301 0 0 0 0 0 0; % W16
                5440 1710 881 722 541 428 385 291 245 199 0; % W14
                833 597 391 307 285 238 204 156 103 0 0; % W12
                716 394 303 248 209 171 170 118 96.3 68.9 0; % W10
                228 184 146 127 110 98.0 82.7 75.3 61.9 48.0 39.6; % W8
                53.4 41.4 32.1 22.1 16.4 0 0 0 0 0 0; % W6
                26.3 21.4 0 0 0 0 0 0 0 0 0; % W5
                11.3 0 0 0 0 0 0 0 0 0 0 \]; % W4
    % Calculation Section
    sigma \ _all = sigma \ _max / FS; % Calculate maximum allowable stress
    S \ _min = abs(M \ _max) / sigma \ _all; % Calculate minimum section modulus
    % Preallocate matrices to store indices and matching weights
    % for a beam from each category
    % Weight matrix preassigned a value of Inf because selection
    % will be based on lightest beam, and no beam can weigh Inf
    beams \ _ind = zeros(\ [1 15 \]);
    beams \ _wght = Inf \* ones(\ [1 15 \]);
    % Iterate through beam types and record the index and weight of the
    % first beam with a sufficient section modulus
    \ [m, n \] = size(weight \ _list);

    for i = 1:m
        % Iterate backwards through each beam type
        for j = size \ _list(i):-1:1

            if (Ixx \ _list(i, j) / (d \ _list(i, j) / 2)) >= S \ _min
                beams \ _ind(i) = j;
                beams \ _wght(i) = weight \ _list(i, j);
                break
            end

        end

    end

    % Find which of these valid beam types has the lightest weight
    % minw stores the minimum weight, minwindex records the index
    % of the corresponding beam
    \ [minw, minwindex \] = min(beams \ _wght);
    % If the "minimum" supposedly weighs Inf, no beams met the section
    % modulus.  Return the W36 x 302 beam and display a warning
    if minw == Inf
        fprintf('Warning: No available beam met the required section modulus.\\n')
        fprintf('A W36 x 302 beam has been returned.\\n')
        name = char(name \ _list(1, 1));
        A = A \ _list(1, 1);
        d = d \ _list(1, 1);
        bf = bf \ _list(1, 1);
        tf = tf \ _list(1, 1);
        tw = tw \ _list(1, 1);
        Ixx = Ixx \ _list(1, 1);
        % Otherwise, return the corresponding beam cross section
    else
        name = char(name \ _list(minwindex, beams \ _ind(minwindex)));
        A = A \ _list(minwindex, beams \ _ind(minwindex));
        d = d \ _list(minwindex, beams \ _ind(minwindex));
        bf = bf \ _list(minwindex, beams \ _ind(minwindex));
        tf = tf \ _list(minwindex, beams \ _ind(minwindex));
        tw = tw \ _list(minwindex, beams \ _ind(minwindex));
        Ixx = Ixx \ _list(minwindex, beams \ _ind(minwindex));
    end

    fprintf('\\n')
    fprintf('Beam type: %s\\n', name)
    fprintf('Area: %.3f in^2\\n', A)
    fprintf('Depth: %.3f in\\n', d)
    fprintf('Flange Width: %.3f in\\n', bf)
    fprintf('Flange Thickness: %.3f in\\n', tf)
    fprintf('Web Thickness: %.3f in\\n', tw)
    fprintf('Moment of Inertia: %.3f in^4\\n', Ixx)
