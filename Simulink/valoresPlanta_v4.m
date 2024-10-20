clc;
clear;
close all;
%% Parameros de dibujo
xmin = -35;
xmax = 50;
ymin = -25;
ymax = 55;
%% Masa, coeficientes de friccion
bcx=1e6;%[N/m/s]
bcy=1e7;%[N/m/s]
kcy=1.8e9;%[N/m] as
Yt0=45;%[m]
Hc=2.50;%[m] ¿2.5 m?
Ms=1.5e4;%[kg]
Mc_max=5e4;%[kg]
Mc_min=2e3;%[kg]
g=9.80665;%[m/s^2]
%% Accionamiento Sistema de Izaje
%% Parametros Eje Lento(Despues de la caja de transmision)
rhd=0.75;%[m] radio del tambor
Jhd_hEb=3.8e3;%[kg*m^2] momento de inercia equivalente del eje lento
bhd=8;%[N*m/rad/s] coef de friccion mecanica vizcosa eje lento
bhEb=2.2e9;%[N*m/rad/s] coef. de friccion freno de emergencia
bhb=1e8;%[N*m/rad/s] coef. de friccion freno de operacion
ThEb_Max=1.1e6;%[N*m] torque maximo de freno de emergencia
ih=22;% relacion de reduccion
%% Parametros Eje Rapido(Eje motor)
Jhm_hb=30;%[kg*m^2] momento de inercia equivalente del eje rapido
bhm=18;%[N*m/rad/s]coef de friccion mecanica vizcosa eje rapido
Thb_Max=5e4;%[N*m] torque maximo de freno de operacion
tau_hm=1e-3;%[ms] constante del modulador de torque
Thm_Max=2e4;%[N*m] torque maximo de motorizacion

%% Parametros equivalentes izaje
Jh_eq=Jhm_hb*ih^2+Jhd_hEb; %[kg*m^2] momento de inercia equivalente de Izaje
bh_eq=bhm*ih^2+bhd; %[N*m/rad/s] coeficiente de friccion equivalente de Izaje
%% Parametros del cable de Izaje (wirerope)
kwu=2.36e8;%(N/m)*m Rigidez unitaria de a traccion
bwu=150;%[N/m/s]/m Friccion interna o vizcosa unitaria a traccion 
%% Carro y cable de acero (wirerope) equivalente
Mt=30000; %[kg] Masa equivalente de Carro, ruedas, etc
bt=90.0; %[N/(m/s)] Coeficiente de Fricción mecánica viscosa equivalente del Carro
Ktw=4.8e5; %[N/m]   Rigidez equivalente total a tracción de cable tensado de carro
btw=3.0e3; %[N/(m/s)] Fricción interna o amortiguamiento total de cable tensado de carro
%% Parametros del carro (traslacion)
rtd=0.5; %[m]
Jtd=1200; %[kg.m^2] 
btd=1.8; %[N*m/rad/s] coef de friccion mecanica viscosa equiv. eje lento
it=30; %relacion de transmision total caja reductora
Jtm_tb=7.0; %[kg.m^2] Momento de inercia equivalente del eje rápido
btm=6.0; %[N*m/rad/s] coef de friccion mecanica viscosa equiv. eje rapido
btb=5e6; %[N*m/rad/s] Coeficiente de Fricción viscosa equivalente del Freno de operación
Ttb_Max=5e3; %[N.m] Torque máximo de frenado del Freno de operación
tau_tm=1e-3; %[s] Constante de tiempo de Modulador de Torque en motor-drive de carro
Ttm_Max=4e3; %[N.m] Torque máximo de motorización/frenado regenerativo del motor
%% Parámetros equivalentes
Jt_eq=Jtd+(Jtm_tb*(it^2));
bt_eq=btd+(btm*(it^2));

%% PID Carro e Izaje 2
n = 3;  %Sistema criticamente amortiguado. Igual en ambos
Meq = Mt +(Jtd+Jtm_tb*it^2)/(rtd^2);
beq = bt + bt_eq/rtd^2;
pt = -bt_eq/Meq;%*(it/rtd);
w_post = abs(5 * pt);
% KDt = n * Meq * w_post;
% KPt = n * Meq * w_post^2;
% KIt = Meq * w_post^3;
KDt = 1.0127e+04;
KPt = 1.4123e+04;
KIt = 6.8096e+03;

Jeq = (Jhd_hEb+Jhm_hb*ih^2)/(rhd^2);
%Jh_eq = bhm*ih^2+bhd;
% bh_eq = (bhm*ih^2+bhd)/(rhd^2);
bh_eq = (bhm*ih^2+bhd)/(rhd^2);
ph = -bh_eq/Jeq;%*(it/rtd);
w_post = abs(10 * ph);
KDh = n * Jeq * w_post;
KPh = n * Jeq * w_post^2;
KIh = Jeq * w_post^3;

% hMax = 10;
P = 956.15e3; %Potencia cte: 956.15 kW

%% Velocidades/aceleraciones maximas carro/izaje

wtmMax = (4/rtd)*it; %v_m: 4 [m/s]
vx_max = 4; %v_m: 4 [m/s] -> por ahora lo uso para aceleracion maxima
ml=5e4;
ax_max = 0.8; %[m/s^2]
ay_max = 0.75; %[m/s^2]

ahmax=0.75;
vhmax=3;  %sin carga es 1.5 
alfahmax=((2*ahmax)/(rhd));
whmax=((2*vhmax)/(rhd));
atmax=0.8;
alfatmax=atmax/rtd;
wtmMin = 0.02;
whmMin = 0.02;
%whmMax = (3*2/rhd)*ih; %rad/s
%whmMax = P/Thm_Max;
f_izaje = 2*ih/rhd; %factor de conversion a eje motor
whmMax = f_izaje*vhmax;

%% Limites de emergencia
xLimMinSeguridad = -30; %[m]
xLimMaxSeguridad = 50; %[m]
yLimMinSeguridad = -20; %[m]
yLimMaxSeguridad = 45; %[m]

%% Limites operativos
xLimMin = -29; %[m]
xLimMax = 49; %[m]
yLimMin = -19; %[m]
yLimMax = 44; %[m]

%% Parametros iniciales
x_0 = -20;
y_0 = 2.5;
Tau_hm0 = 1000;
x_0_tamb = x_0/rtd;
y_0_izaje = 3*(2/rhd); %2.5*(2/rhd)

%% Timeout Watchdog
WD_TIMEOUT = 50; % para hacer cada 1 segundo (muestreo 20 ms)

%% Posiciones de referencia para consigna
% [-28.7500000000000,-26.2500000000000,-23.7500000000000,-21.2500000000000,-18.7500000000000,-16.2500000000000,-13.7500000000000,-11.2500000000000,-8.75000000000000,-6.25000000000000,-3.75000000000000,-1.25000000000000,1.25000000000000,3.75000000000000,6.25000000000000,8.75000000000000,11.2500000000000,13.7500000000000,16.2500000000000,18.7500000000000,21.2500000000000,23.7500000000000,26.2500000000000,28.7500000000000,31.2500000000000,33.7500000000000,36.2500000000000,38.7500000000000,41.2500000000000,43.7500000000000,46.2500000000000,48.7500000000000;
%   0,0,0,0,0,0,0,0,0,0,0,0,17,21,-15,22,9,-16,-8,5,24,24,-13,24,24,2,16,-14,-1,22,16,24]

% Posiciones deseadas: [Inicial(real), barco, barco_2, final(muelle)]
p_referencia = [-20, 2.5; 30.5, 30; 20.5, 25; -20, 2.5];

% posicion inicial 
xt0 = -20;
y0 = 2.5; 
% Perfil de contenedores (arrancar desde -30)
% x_positions = 1.25:2.5:(50-1.25);
x_positions = (-30+1.25):2.5:(50-1.25);
% Perfil en muelle
hy_muelle = zeros(1,13);    %12
% Altura de los contenedores
hy_cont = randi([20, 40], 1, 19); %20

% Ancho de cada contenedor
hx_cont = 2.5;
boat_under_water = 20;
hy_cont = hy_cont - boat_under_water; % cambio referencia
estado_cont = [x_positions; [hy_muelle hy_cont]]

pos = calcularTrayectoria2_prueba(vx_max, vhmax, ax_max, Hc, hx_cont, [estado_cont(1, 23), estado_cont(2, 23)+5], [-20,2.5], 0, estado_cont); % [30.5,30] en posicion final
plot(pos(:, 1), pos(:, 2), 'o-', 'LineWidth', 2);

% Etiqueta los ejes
xlabel('Posición en x');
ylabel('Altura');
title('Trayectoria de puntos');
hold on
% plot(estado_cont(1,:), estado_cont(2,:), 'o-', 'LineWidth', 2);
b = bar(estado_cont(1,14:32), estado_cont(2,14:32), 1); % estado_cont(1,13:32)
b(1).BaseValue = -20;
hold on
%viga voladiza
plot([-30 50],[45 45 ],'Color','k')
hold on
% %cable
% cable = plot([xt xl],[45 yl+Hc],'Color','k');
% hold on
%barco
rectangle('Position',[2, -20.5, 0.5, 25.5 ],'FaceColor','b');
rectangle('Position',[50, -20.5, 0.5, 25.5 ],'FaceColor','b');
rectangle('Position',[2, -20.5, 48, 0.5 ],'FaceColor','b');
hold on
%muelle
rectangle('Position',[-30, -0.5, 30, 0.5 ],'FaceColor','k');
rectangle('Position',[0, -20, 0.5, 20 ],'FaceColor','k');
axis([xmin xmax ymin ymax])
