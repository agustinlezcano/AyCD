clc, clear
% Perfil de contenedores
x_positions = 2.5:2.5:50;
% Altura de los contenedores
hy_cont = randi([0, 45], 1, 20);
estado_cont = [x_positions; hy_cont]
% Ancho de cada contenedor
hx_cont = 2.5;
boat_under_water = 20;

%% Limites del grafico
xmin = -30;
xmax = 55;
ymin = -25;
ymax = 55;

%% Ploteo muelle
delta = 1;
x_muelle = abs(xmin);% + delta;
y_muelle = abs(ymin) + delta;
rectangle('Position', [xmin-delta ymin-delta x_muelle y_muelle], 'EdgeColor', [0.6 0.3 0.1], 'LineWidth', 3, 'FaceColor', [0.8 0.5 0.1])    
hold on
axis([xmin xmax ymin ymax])

%% Ploteo barco
% deltax_cont = 0.25
% ysb = 15;
% barco_x = [0, 0, size(x_positions)*(hx_cont), size(x_positions)*(hx_cont)];
% barco_y = [ysb, -boat_under_water-0.5, -boat_under_water-0.5, ysb];
% plot(barco_x, barco_y, 'LineWidth', 3, 'Color', [0.2 0.2 0.2])

%% Ploteo mar
%Parte izq barco 
rectangle('Position',[-delta ymin-delta delta-0.1 y_muelle-delta],'FaceColor', 'Blue','LineWidth', 0.01)
hold on
rectangle('Position',[-0.1 ymin (size(x_positions,2)*(hx_cont)+ hx_cont)  (abs(ymin)-abs(boat_under_water)-0.8)],'FaceColor', 'Blue','LineWidth', 0.01)
hold on
rectangle('Position',[(size(x_positions,2)*(hx_cont) + hx_cont) ymin-delta delta-0.1 y_muelle-delta],'FaceColor', 'Blue','LineWidth', 0.01)
hold on

%% Ploteo contenedores
x_actual = 0;
% for i = 1:size(x_positions,2)
%     y_actual = - boat_under_water;
%     x_actual = x_positions(i) - hx_cont/2;
%     rectangle('Position', [x_actual y_actual hx_cont hy_cont(i)], 'EdgeColor', [0.9 0.05 0.1], 'LineWidth', 2, 'FaceColor', [1 0.3 0.5])
%     y_actual = y_actual + hy_cont; 
% end
for i = 1:size(x_positions,2)
    y_actual = - boat_under_water;
    x_actual = estado_cont(1,i) - hx_cont/2;
    rectangle('Position', [x_actual y_actual hx_cont estado_cont(2,i)], 'EdgeColor', [0.9 0.05 0.1], 'LineWidth', 2, 'FaceColor', [1 0.3 0.5])
    y_actual = y_actual + hy_cont; 
end
hold on
%% Grafico de posiciones deseadas
pos = puntosTrayectoria(4, 1.5, 20, [-20,0], estado_cont(:,5), x_positions, hy_cont)
pos(2:end,2) = pos(2:end,2) - boat_under_water

% Grafica los puntos y las líneas
plot(pos(:, 1), pos(:, 2), 'o-', 'LineWidth', 2);

% Etiqueta los ejes
xlabel('Posición en x');
ylabel('Altura');
title('Trayectoria de puntos');
hold on
axis([xmin xmax ymin ymax])

