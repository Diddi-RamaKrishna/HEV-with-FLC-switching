%operation
%{
x=input('Enter: \n 1 for electric\n 2 for ICE mode \n 3 for hybrid mode : \n');
if x==1
    d=1;
    e=0.3;
    fprintf('the vehicle is now in electric mode :\n ')
elseif x==2
    d=0.3;
    e=1;
    fprintf('the vehicle is now in ICE mode :\n ')
else
    d=1;
    e=1;
    fprintf('the vehicle is now in Hybrid mode :\n ')
end
%}

enginepower=30000;
PmaxEM = 266000;      % Maximum power                   [W]
TmaxEM = 420;        % Maximum torque                  [N*m]
Ld     = 0.00024368; % Stator d-axis inductance        [H]
Lq     = 0.00029758; % Stator q-axis inductance        [H]
L0     = 0.00012184; % Stator zero-sequence inductance [H]
Rs     = 0.010087;   % Stator resistance per phase     [Ohm]
psim   = 0.04366;    % Permanent magnet flux linkage   [Wb]
p      = 8;          % Number of pole pairs
Jm     = 0.1234;     % Rotor inertia                   [Kg*m^2]
Cdc    = 0.001;      % DC-link capacitor               [F]
Vnom   = 325;        % Nominal voltage                 [V]

%% Battery Parameters

Q    = 11600;       % Battery capacity                     [W*hr]
Vbat = 355;         % Nominal voltage                      [V]
Ri   = 0.001;       % Internal resistance                  [Ohm]
AH   = Q/2000*Vbat;     % Ampere-hour rating                   [hr*A]
V1   = 240;         % Voltage V1 < Vnom when charge is AH1 [V]
AH1  = AH/2;        % Charge AH1 when no-load volts are V1 [hr*A]
SOC0 = 0.2;         % Initial State of Charge              [%]
AH0  = SOC0 * AH;   % Initial charge in Ampere-hours       [hr*A] change this values such that battery depletes faster

%% ICE Parameters
TmaxICE = 320;    % Maximum torque                  [N*m]
PmaxICE = 170000; % Maximum power                   [W]
Km      = 178.3;  % Gain for ICE model
Tm      = 0.1;    % Time constant for ICE model     [s]
 
%% Control Parameters
Ts   = 1e-5;        % Fundamental sample time                   [s]
fsw  = 10e3;        % PMSM drive switching frequency            [Hz]
Tsi  = 1e-4;        % Sample time for current control loops     [s]
Tsd  = 1e-3;        % Sample time for DCDC current control loop [s]

Kp_id = 0.8779;     % Proportional gain id controller
Ki_id = 710.3004;   % Integrator gain id controller
Kp_iq = 1.0744;     % Proportional gain iq controller
Ki_iq = 1.0615e+03; % Integrator gain iq controller

Kp_ice = 1.65;      % Proportional gain ice controller
Ki_ice = 3;         % Integrator gain ice controller

Kp_i = 0.03;
Ki_i = 5;

%% Zero-Cancellation Transfer Functions
numd_id = Tsi/(Kp_id/Ki_id);
dend_id = [1 (Tsi-(Kp_id/Ki_id))/(Kp_id/Ki_id)];
numd_iq = Tsi/(Kp_iq/Ki_iq);
dend_iq = [1 (Tsi-(Kp_iq/Ki_iq))/(Kp_iq/Ki_iq)];

numd_i = Tsd/(Kp_i/Ki_i);
dend_i = [1 (Tsd-(Kp_i/Ki_i))/(Kp_i/Ki_i)];

%% Current References
load ee_ipmsm_35kW_ref_idq;

%% Vehicle Parameters
Mv    = 1485;   % Vehicle mass                   [kg]
g     = 9.8;    % Gravitational acceleration     [m/s^2]
rho_a = 1.2;    % Air density                    [kg/m^3]
AL    = 2.9;    % Max vehicle cross section area [m^2]
Cd    = 0.26;    % Air drag coefficient           [N*s^2/kg*m]
cr1   = 0.1;    % Rolling coefficient            
cr2   = 0.2;    % Rolling coefficient            
i_t   = 9;      % Gear reduction ratio           
Rw    = 0.3;    % Wheel radius                   [m] 