clc;
clear;
close all;
bcx=1e6;%[N/m/s]
bcy=1e7;%[N/m/s]
kcy=1.8e9;%[N/m]
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
Ttm_Max=3e3; %[N.m] Torque máximo de motorización/frenado regenerativo del motor
%Parámetros equivalentes
Jt_eq=Jtd+(Jtm_tb*(it^2));
bt_eq=btd+(btm*(it^2));
%% Parametros PID carro/izaje
% n = 3;  %Sistema subamortiguado amortiguado. Igual en ambos
% pt = -bt_eq/Jt_eq;%*(it/rtd);
% w_post = abs(10 * pt);
% 
% Meq = Mt +(Jtd+Jtm_tb*it^2)/(rtd^2)
% %revisar Meq2-> corregir
% Meq2 = Jt_eq*n*(1/it); %solo para obtener las constantes PID
% KDt = Meq2 * w_post
% KPt = Meq2 * w_post^2
% KIt = Meq2 * w_post^3
% 
% 
% ph = -bh_eq/Jh_eq;  %Polo 1 a lazo abierto (izaje)
% w_posh = abs(10 * ph);
% %revisar Jeq2
% Jeq2 = Jh_eq*n*(1/ih); %solo para obtener las constantes PID
% KDh = Jeq2 * w_posh
% KPh = Jeq2 * w_posh^2
% KIh = Jeq2 * w_posh^3
%% PID Carro e Izaje 2
n = 3;  %Sistema subamortiguado amortiguado. Igual en ambos
Meq = Mt +(Jtd+Jtm_tb*it^2)/(rtd^2)
beq = bt + bt_eq/rtd^2;
pt = -bt_eq/Meq;%*(it/rtd);
w_post = abs(10 * pt);
KDt = Meq * w_post
KPt = Meq * w_post^2
KIt = Meq * w_post^3
% KDt = 540000
% KPt = 1.2354e06
% KIt = 7.0661e05

% Jeq = (Jhd_hEb+Jhm_hb*ih^2)/(rhd^2)
Jeq = (Jhd_hEb+Jhm_hb*ih^2)/(rhd^2);
%Jh_eq = bhm*ih^2+bhd;
%bh_eq hacer
% bh_eq = (bhm*ih^2+bhd)/(rhd^2);
bh_eq = (bhm*ih^2+bhd)/(rhd^2);
ph = -bh_eq/Jeq;%*(it/rtd);
w_post = abs(10 * ph);
KDh = Jeq * w_post
KPh = Jeq * w_post^2
KIh = Jeq * w_post^3
%% 
%Perfil de obstaculos
hMax = 10;

P = 956.15e3; %Potencia cte: 956.15 kW

%% Velocidades/aceleraciones maximas carro/izaje
%whmMax = (3*2/rhd)*ih; %rad/s
whmMax = P/Thm_Max;
wtmMax = (4/rtd)*it; %v_m: 4 [m/s]
v_x_max = 4; %v_m: 4 [m/s] -> por ahora lo uso para aceleracion maxima
ml=5e4;
ax_max = 0.8; %[m/s^2]
ay_max = 0.75; %[m/s^2]

ahmax=0.75;
vhmax=3;
alfahmax=((2*ahmax)/(rhd));
whmax=((2*vhmax)/(rhd));
atmax=0.8;
alfatmax=atmax/rtd;