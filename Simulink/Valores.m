clc;
clear;
close all;
Yt0=45;%[m]
Hc=0;%[m]
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
tauhm=1e-3;%[ms] constante del modulador de torque
Thm_Max=2e4;%[N*m] torque maximo de motorizacion
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
Meq=(rtd*Mt*it-Jtd)/rtd;
beq=(btd+rtd*bt*it)/rtd;
Meqc=Meq+it;    %Es Meq+it*M2 ver que es M2->corregir
beqc=it*btm/rtd+beq; %corregir
