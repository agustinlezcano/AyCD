function POS = calcularTrayectoria2_prueba(VX_MAX, VY_MAX, AX_MAX, dy, anchoCont, pos_f, pos_i, E_cont, twistlocks, dir)
 ysb = 15;
    % Las dimensiones al concatenar en consigna son de vectores fila
    xi = pos_i(1,1);
    yi = pos_i(1,2);
    xf = pos_f(1,1);
    yf = pos_f(1,2);

    %pos_i y pos_f son vectores (x,y)
    theta = atan2(VY_MAX,VX_MAX);   %angulo para alcanzar ambas velocidades máximas
    dx = (VX_MAX^2)/(2 * AX_MAX)

    if (2 * dx <= (xf-xi))
        [hmax, index] = calcularIndice(xi, xf, anchoCont, E_cont);
        disp(hmax);
        hp = tan(theta) * dx
    else 
        [hmax, index] = calcularIndice(xi, xf, anchoCont, E_cont); %calcularIndice(xi, xf, anchoCont, to_obj, E_cont
        disp(hmax);
        VX_MAX = sqrt(2 * AX_MAX * abs((xf-xi)/2))
        theta = atan2(VY_MAX,VX_MAX);
        dx = (xf-xi)/2;
        hp = tan(theta) * dx

    end

    p0 = [xi, yi]; 
    % si hmax es negativo, lo hago ser 15
    if (hmax < 0)
        hmax = ysb;
        % cambiar la altura
    elseif (hmax <= yf)
        hmax = yf + dy;
        
    elseif(hmax < p0(2))
        if ((p0(2)+ 2 * dy) < 40)
            hmax = p0(2)+ dy;   %a criterio, puede ser 2*dy --> ver que cumpla consigna de velocidad
                                % Altura para desarrollar 3 m/s con a = cte
        else
            hmax = p0(2);
        end
    end
       
    if (twistlocks == 1)
        hseg = hmax + 2 * dy;  %altura de seguridad
    else
        hseg = hmax + dy;
    end
    %hseg debe ser < 40:
    if ((hmax + 2*dy) >= 40)
        h_seg = 40;
    else
        h_seg = hmax + 2*dy;
    end

    
    if (dir == 0)
        p1 = [xi, hmax];
    else
        % calcula la posicion inicial de y teniendo en cuenta que la hmax
        % esta en la primer columna de contenedores
        % TODO: manejar error en caso de que se tenga un dir = 1 (al barco)
        % y la posicion inicial en x sea positiva
        x_tray = 0- xi; % distancia entre punto inicial en X y el 0
        hp = x_tray * atan(theta); % altura alcanzable en mov. combinado a V max
        hini = hmax - hp; % altura inicial válida
        p1 = [xi, hini];
    end
    if (xi<xf)
        p2 = [(xi+dx), (hseg)];
        p3 = [(xf-dx), (hseg)];
    else
        p2 = [(xi-dx), (hseg)];
        p3 = [(xf+dx), (hseg)];
    end
    p4 = [xf, hmax];
    p5 = [xf, yf];
    % Corregir: si p0(1) es mas grande que hmax, hmax >= p0(1) (sin pasar limites)
    POS = [p0; p1; p2; p3; p4; p5];
end
    
    
 
function [hmax, index_max] = calcularIndice(xi, xf, anchoCont, E_cont)
    % Calcular el índice del valor más alto
    % Debe arrancar desde el inicio (-30), no desde el muelle
    % indice negativo: solucionado
    % 
    index = floor((xi) / anchoCont); % extremo: -11 --> 1
    % hacer: floor((xi) / anchoCont) + 1 + 12 (para arrancar en 1.25) 
    index = index + 12
    
    index_obj = floor((xf) / anchoCont);
    index_obj = index_obj + 12
    
    % Verificar la dirección --> usar posiciones en coordenadas
    if (index_obj > index)
        % Calcular la altura máxima para índices menores al calculado
        [hmax, index_max] = max(E_cont(2,index:index_obj)) %posible error: indice de subelemento
        index_max = index_max + index -1
    elseif (index_obj < index)
        %comparar posicion objetivo con la inicial
        [hmax, index_max] = max(E_cont(2,index_obj:index))
        index_max = index_max + index_obj - 1
    else
        % Otra opción no especificada
        hmax = 0;
        index_max = 0;
        
    end

end
