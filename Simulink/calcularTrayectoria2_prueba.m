function pos = calcularTrayectoria2_prueba(VX_MAX, VY_MAX, AX_MAX, dy, anchoCont, pos_f, pos_i, to_where, estado_cont)
    ysb = 15;
    xi = pos_i(1);
    yi = pos_i(2);
    xf = pos_f(1);
    yf = pos_f(2);

    %pos_i y pos_f son vectores (x,y)
    theta = atan2(VY_MAX,VX_MAX);   %angulo para alcanzar ambas velocidades máximas
    fprintf('Distancia dx para alcanzar v. maximas');
    dx = (VX_MAX^2)/(2 * AX_MAX)

    if (2 * dx <= (xf-xi))
        fprintf('[index, hmax] para 2 * dx <= (xf-xi)\n');
        [hmax, index] = calcularIndice(xi, xf, anchoCont, to_where, estado_cont)
        disp(hmax);
        hp = tan(theta) * dx
    else 
        fprintf('[index, hmax] para 2 * dx > (xf-xi)\n');
        [hmax, index] = calcularIndice(xi, xf, anchoCont, to_where, estado_cont)
        disp(hmax);
        VX_MAX = sqrt(2 * AX_MAX * abs((xf-xi)/2))
        theta = atan2(VY_MAX,VX_MAX);
        dx = (xf-xi)/2;
        hp = tan(theta) * dx
%     else (dx > (xf-xi)/2)
%         [index, hmax] = calcularIndice(xl, anchoCont, to_where, estado_cont)
%         VX_MAX = sqrt(2 * AX_MAX * (xf-xi)/2);
%         theta = atan2(VY_MAX/VX_MAX);
%         dx = (xf-xi)/2
%         hp = tan(theta) * dx;
%     else
%         [index, hmax] = calcularIndice(xl, anchoCont, to_where, estado_cont)    
%         hp = tan(theta) * dx;
    end

     
    % si hmax es negativo, lo hago ser 15
    if (hmax < 0)
        hmax = ysb;
        % cambiar la altura
    elseif (hmax <= yf)
        hmax = yf + dy;
    end
        
    hseg = hmax + 2 * dy;  %altura de seguridad
    %hseg debe ser < 40:
    if ((hmax + 2*dy) >= 40)
        h_seg = 40;
    else
        h_seg = hmax + 2*dy;
    end

    p0 = [xi, yi];
    p1 = [xi, hmax];    %es muy jugado, puede chocar si la altura max es indice 1
    p2 = [(xi+dx), (hseg)];
    p3 = [(xf-dx), (hseg)];
    p4 = [xf, hmax];    %debe ser mayor a yf
    p5 = [xf, yf];
    pos = [p0; p1; p2; p3; p4; p5];
end
    
    
 
function [hmax, index_max] = calcularIndice(xi, xf, anchoCont, ~, estado_cont)
    % Calcular el índice del valor más alto
    % Debe arrancar desde el inicio (-30), no desde el muelle
    % indice negativo: solucionado
    % 
    fprintf('index\n')
    index = floor((xi) / anchoCont); % extremo: -11 --> 1
    % hacer: floor((xi) / anchoCont) + 1 + 12 (para arrancar en 1.25) 
    index = index + 12
    
    fprintf('index_obj\n')
    index_obj = floor((xf) / anchoCont);
    index_obj = index_obj + 12
    
    % Verificar la dirección --> usar posiciones en coordenadas
    if (index_obj > index)
        fprintf('index_obj > index\n')
        % Calcular la altura máxima para índices menores al calculado
        [hmax, index_max] = max(estado_cont(2,index:index_obj)) %posible error: indice de subelemento
        index_max = index_max + index -1
    elseif (index_obj < index)
        fprintf('index_obj < index\n')
        %comparar posicion objetivo con la inicial
        [hmax, index_max] = max(estado_cont(2,index_obj:index))
        index_max = index_max + index_obj - 1
    else
        fprintf('No deberia activarse\n')
        % Otra opción no especificada
        hmax = 0;
        index_max = 0;
        fprintf('Dirección no válida');
    end

end



% % Verificar la dirección --> usar posiciones en coordenadas
% if (to_where == 0)
%     % Calcular la altura máxima para índices menores al calculado
%     hmax = max(estado_cont(1:index));
% elseif (to_where == 1)
%     % Calcular la altura máxima para índices mayores/menores al calculado
%     %comparar posicion objetivo con la inicial
%     hmax = estado_cont(index);
% elseif (to_where == 2)
%     % Calcular la altura máxima para índices mayores al calculado
%     hmax = max(estado_cont(index:end));
% else
%     % Otra opción no especificada
%     error('Dirección no válida');
% end