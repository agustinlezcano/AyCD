function [pos] = puntosTrayectoria(V_X_MAX, V_Y_MAX, deltaX, pos_ini, perfil, hy_cont, pos_final)
    % pos_ini es la posicion inicial del spreader (x,y)
    % perfil es la posicion final de la carga (x,y)
    % deltaX dis spreader-barco
    % Ancho de cada contenedor
    hx_cont = 2.5;
    delta_y_cont = 2.5;
    ysb = 15; %viga testera
    x_seg_desc = 3*hx_cont; %distancia de seguridad: desc combinado
    % Vertice izquierdo del cont: x_positions - hx
    % Vertice derecho del cont: x_positions + hx
    fprintf("pos final %d", pos_final);
    % [h_max, h_max_index] = max(hy_cont, [],2,"linear"); %el indice es calculo otra traectoria
    sub_hy_cont = hy_cont(1:pos_final); %izquierda del objetivo
    [h_max, ~] = max(sub_hy_cont, [],2,"linear"); %maximo del array a la izquierda
    
    
    theta = atan(V_Y_MAX/V_X_MAX);
   
    %Altura inicial movimiento combinado
    % mas que viga testera
    hp = tan(theta) * deltaX; %deltaX dist al bote
    % si hmax es negaivo, lo hago ser 15
    if (h_max < 0)
        h_max = ysb;
    elseif (h_max == perfil(2, pos_final))
        h_max = perfil(2, pos_final) + delta_y_cont;
    end
        
    h_seg = h_max + 2*delta_y_cont;
    if ((h_seg - hp) > ysb)
        h_ini = h_seg - hp;
        if (pos_final > 3) 
            p2 = [pos_ini(1)+deltaX,h_seg];
        else
            hp = tan(theta) * (deltaX-x_seg_desc); %deltaX dist al bote 
            p2 = [pos_ini(1)+deltaX-x_seg_desc,h_seg];
        end
    else
        h_ini = ysb;
        h_seg = h_ini+ 2*delta_y_cont;
        if (pos_final > 3) 
            hp = tan(theta) * deltaX; %deltaX dist al bote
            p2 = [pos_ini(1)+deltaX,h_seg];
        else
            hp = tan(theta) * (deltaX-x_seg_desc); %deltaX dist al bote 
            p2 = [pos_ini(1)+deltaX-x_seg_desc,h_seg];
        end   
    end
    
    
    %posiciones fijas: error al pasar de 3 a 4 si pos x <=3
    %no tengo en cuenta la velocidad maxima para el calculo
    p0 = pos_ini;
    p1 = [pos_ini(1), h_ini];
    p3 = [(perfil(1,pos_final)-x_seg_desc), h_seg];
    p4 = [perfil(1,pos_final), h_max];
    p5 = [perfil(1,pos_final),perfil(2,pos_final)];
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
