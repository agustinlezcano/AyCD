function [pos] = puntosTrayectoria(V_X_MAX, V_Y_MAX, deltaX, pos_ini, pos_final,x_positions, hy_cont)
    % pos_ini es la posicion inicial del spreader (x,y)
    % pos_final es la posicion final de la carga (x,y)
    % deltaX dis spreader-barco
    % Ancho de cada contenedor
    hx_cont = 2.5;
    delta_y_cont = 2.5;

    % Vertice izquierdo del cont: x_positions - hx
    % Vertice derecho del cont: x_positions + hx

    [h_max, h_max_index] = max(hy_cont, [],2,"linear"); %el indice es calculo otra traectoria

    h_seg = h_max + 2*delta_y_cont;
    theta = atan(V_Y_MAX/V_X_MAX);
    hp = tan(theta) * deltaX; %deltaX dist al bote
    %Altura inicial movimiento combinado
    h_ini = h_seg - hp;
    
    p0 = pos_ini;
    p1 = [pos_ini(1), h_ini];
    p2 = [0,h_seg];
    p3 = [(pos_final(1)-3*hx_cont), h_seg];
    p4 = [pos_final(1), h_max];
    p5 = [pos_final(1),pos_final(2)];
    pos = [p0; p1; p2; p3; p4; p5];
    
    %% Grafico de posiciones deseadas
    % Grafica los puntos y las líneas
%     plot(pos(:, 1), pos(:, 2), 'o-', 'LineWidth', 2);
% 
%     % Etiqueta los ejes
%     xlabel('Posición en x');
%     ylabel('Altura');
%     title('Trayectoria de puntos');
%     hold on
%     axis([xmin xmax ymin ymax])

    %% Control de choque
    
    
end
