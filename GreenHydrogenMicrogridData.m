%% Parameters for Green Hydrogen Microgrid Example
% 
% This example shows a DC islanded microgrid that provides power to an 
% electrolyzer using a solar array and an energy storage system. You can 
% use this model to evaluate the operational characteristics of producing 
% green hydrogen over a 7-day period by power from a solar array, or from 
% a combination of a solar array and an energy storage system. The model 
% includes electrical, thermal liquid, and thermal gas domains.

% Copyright 2021-2023 The MathWorks, Inc.


%% Hydrogen Properties

T_vect = [-75 -50 -25 0 25 50 75 100]+273.15;                  %K
h_vect = [2532 2875 3224 3578 3936 4295 4655 5017];            %kJ/kg
nu_vect = [6.77 7.34 7.88 8.42 8.94 9.44 9.93 10.41];          %s*uPa
cond_vect = [132.4 146.8 160.5 173.4 185.6 197.5 210.1 222.0]; %mW/kg/K
cp_vect = [13.57 13.87 14.08 14.23 14.33 14.4 14.45 14.47];    %kJ/kg/K

R_h2 = 4.12; %kJ/kg/K

%% Solar Data
% Time vector for solar profile
t_solar_profile = linspace(0, 24*3600, 24);
% Solar profile
solar_profile = [60, 120, 180, 240, 300, 360, 480, 600, 720, 840, 960, 1000, 1040, 1000, 960, 840, 720, 600, 480, 360, 240, 180, 120, 60]';

temperature = 14; % Solar cell simulation temperature [degC]
%% Electrolyzer Unit

Plate.X = 100;  % cm
Plate.Y = 100; % cm
Plate.Z = 100; % cm
Electrolyzer.Np_electrodes = 3; % Number of electrode pairs
Electrolyzer.N_cell = 130;      % Number of cells
Electrolyzer.Temp_vect = linspace(273.15, 353.15, 5); % Temperature vector for efficiency [k]
Electrolyzer.Efficiency_vect = linspace(0.55, 0.9, 5);  % Efficiency vector [pu]
Electrolyzer.AreaMembrane = (Plate.Y*Plate.Z)*Electrolyzer.Np_electrodes; % Membrane area [cm^2]
Electrolyzer.Xd = 2.0;          % Membrane tickness [cm]
Electrolyzer.Resistance = 0.32; % Resistance [Ohm]
Heat.Resistance = 25; % Heating resistor [Ohm]

Tank.Area = (Plate.X*Plate.Y)*Electrolyzer.Np_electrodes; % Area of water tank [cm^2]
H2_Tank.Volume = 100*100*100;  % Volume of hydrogen tank [cm^3]
H2_Tank.T_storage = 273.15;    % Temperature of hydrogen tank [K]

Temp_vect_heat = [0 50 75 100]+273.15;
I_vect_heat = [100 75 0 0];

%% Ennergy Storage

Battery.Qn = 54000;
Battery.Qinit = 54000;
Battery.Q1 = Battery.Qn*0.5;
Battery.Rs = 0.3;
Battery.Un = 210;
Battery.U1 = 200;

Operation_Ref.Ie = [100 95 75 12.5 12.5];
Operation_Ref.Isolar = [0 500 700 750 1000];
Converter.Iout = [40 80 120];
Converter.Efficiency = [95 98 100];

%% Control Parameters

Ts         = 10; % Sample time [s]
