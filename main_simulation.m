%% CSTR Bioreactor Dynamic Simulation
% Biomass and substrate modeling using Monod kinetics

clc;
clear;

%% Time span
tspan = [0 50];    % hours

%% Initial conditions
X0 = 0.1;          % Biomass concentration (g/L)
S0 = 5;            % Substrate concentration (g/L)

y0 = [X0; S0];

%% Base parameters
params.mu_max = 0.4;    % Maximum growth rate (1/hr)
params.Ks     = 0.5;    % Half-saturation constant (g/L)
params.Yxs    = 0.5;    % Biomass yield coefficient (g biomass/g substrate)
params.D      = 0.2;    % Dilution rate (1/hr)
params.Sin    = 10;     % Feed substrate concentration (g/L)

%% Parameter values for sweeps
D_values   = [0.1 0.2 0.4];
Sin_values = [5 10 20];
mu_values  = [0.2 0.4 0.6];
Y_values   = [0.3 0.5 0.7];

%% ==========================================================
%% Effect of Dilution Rate

figure;
hold on;

for i = 1:length(D_values)

    params.D = D_values(i);

    [t,y] = ode45(@(t,y) bioreactor_odes(t,y,params), tspan, y0);

    yyaxis left
    plot(t,y(:,1),'LineWidth',2)

    yyaxis right
    plot(t,y(:,2),'--','LineWidth',2)

end

xlabel('Time (hours)')

yyaxis left
ylabel('Biomass X (g/L)')

yyaxis right
ylabel('Substrate S (g/L)')

title('Effect of Dilution Rate')

legend( ...
    'X D=0.1','S D=0.1', ...
    'X D=0.2','S D=0.2', ...
    'X D=0.4','S D=0.4')

grid on;

%% ==========================================================
%% Effect of Feed Substrate Concentration

figure;
hold on;

for i = 1:length(Sin_values)

    params.Sin = Sin_values(i);

    [t,y] = ode45(@(t,y) bioreactor_odes(t,y,params), tspan, y0);

    yyaxis left
    plot(t,y(:,1),'LineWidth',2)

    yyaxis right
    plot(t,y(:,2),'--','LineWidth',2)

end

xlabel('Time (hours)')

yyaxis left
ylabel('Biomass X (g/L)')

yyaxis right
ylabel('Substrate S (g/L)')

title('Effect of Feed Substrate Concentration')

legend( ...
    'X Sin=5','S Sin=5', ...
    'X Sin=10','S Sin=10', ...
    'X Sin=20','S Sin=20')

grid on;

%% ==========================================================
%% Effect of Maximum Growth Rate

figure;
hold on;

for i = 1:length(mu_values)

    params.mu_max = mu_values(i);

    [t,y] = ode45(@(t,y) bioreactor_odes(t,y,params), tspan, y0);

    yyaxis left
    plot(t,y(:,1),'LineWidth',2)

    yyaxis right
    plot(t,y(:,2),'--','LineWidth',2)

end

xlabel('Time (hours)')

yyaxis left
ylabel('Biomass X (g/L)')

yyaxis right
ylabel('Substrate S (g/L)')

title('Effect of Maximum Growth Rate')

legend( ...
    'X \mu=0.2','S \mu=0.2', ...
    'X \mu=0.4','S \mu=0.4', ...
    'X \mu=0.6','S \mu=0.6')

grid on;

%% ==========================================================
%% Effect of Biomass Yield Coefficient

figure;
hold on;

for i = 1:length(Y_values)

    params.Yxs = Y_values(i);

    [t,y] = ode45(@(t,y) bioreactor_odes(t,y,params), tspan, y0);

    yyaxis left
    plot(t,y(:,1),'LineWidth',2)

    yyaxis right
    plot(t,y(:,2),'--','LineWidth',2)

end

xlabel('Time (hours)')

yyaxis left
ylabel('Biomass X (g/L)')

yyaxis right
ylabel('Substrate S (g/L)')

title('Effect of Biomass Yield Coefficient')

legend( ...
    'X Y=0.3','S Y=0.3', ...
    'X Y=0.5','S Y=0.5', ...
    'X Y=0.7','S Y=0.7')

grid on;

%% ==========================================================
%% Local Function

function dydt = bioreactor_odes(~, y, p)

X = y(1);
S = y(2);

% Monod growth rate
mu = p.mu_max * S / (p.Ks + S);

% Biomass balance
dXdt = mu*X - p.D*X;

% Substrate balance
dSdt = p.D*(p.Sin - S) - (1/p.Yxs)*mu*X;

dydt = [dXdt; dSdt];

end