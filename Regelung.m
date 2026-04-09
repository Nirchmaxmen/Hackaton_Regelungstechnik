
clear;
C = 5.0 * 10^7;              % J/K
R = 0.014;                   % K/W
Tin_0 = 20;                  % °C
a = 3.5;
b = -0.1;                   % 1/°C
Qwp_max = 10.0 * 10^3;       % W

Emax = 7.0 * 10^3 * 3600;    % Ws
Eth_0 = 3.5 * 10^3 * 3600;   % Ws
Pth_max = 10.0 * 10^3;       % W

Ebat_max = 5 * 10^3 * 3600;  % Ws
Ebat_0 = 5 * 10^3 * 3600;    % Ws
Pbat_max = 5 * 10^3;         % W

eta = 0.20;
Apv_max = 100;               % m^2
dt = 300;                    % s

T = readtable('Daten2.xlsx');

% Convert timestamps and create time vector in seconds from start
t_datetime = datetime(T.timestamp, 'InputFormat', 'dd.MM.yyyy HH:mm:ss');
time = seconds(t_datetime - t_datetime(1));

% Ensure column vectors
time = time(:);

% Build input arrays as two-column [time, value] for Simulink if needed
GHI  = [time, T.GHI(:)];
Tout  = [time, T.Aussentemperatur__C_(:)];
Pload = [time, T.Bedarf_elektrisch_W_(:)];
Qload = [time, T.Bedarf_thermisch_W_(:)];
Wsolar = [time, T.Solarthermie_Erzeugung_W_(:)];
c = [time, T.Strompreis___kWh_(:)];
% Initialize electrical production and battery power to zeros
Pel = [time, zeros(size(time))];
Pbat = [time, zeros(size(time))];

% Use configured Apv_max rather than hard-coded value
Apv = Apv_max;

% Set stop time for simulation to last timestamp (in seconds)
simStopTime = num2str(time(end));

% Run simulation with matching stop time so inputs are used correctly
%%out1 = sim("Sim", 'StopTime', simStopTime);