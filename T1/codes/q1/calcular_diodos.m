function resultados = calcular_diodos(tipo_retificador, params, resultados_b)
    % Extrai valores necessários
    Vp = params.Vp;
    VLLp = params.VLLp;
    Io_avg = resultados_b.Io_avg;
    
    switch tipo_retificador
        case 'mono_meia_onda'
            PIV = Vp;
            I_D_avg = Io_avg;

        case 'mono_ponte_completa' 
            % Cada diodo bloqueia o pico da tensão da fonte.
            PIV = Vp;
            % A corrente média da carga é dividida por 2 diodos.
            I_D_avg = Io_avg / 2;
            
        case 'mono_tap_central'
            % O diodo bloqueia o dobro do pico de tensão (Vp + Vp).
            PIV = 2 * Vp;
            % A corrente média da carga é dividida por 2 diodos.
            I_D_avg = Io_avg / 2;

        case 'tri_ponto_medio'
            PIV = VLLp;
            I_D_avg = Io_avg / 3;

        case 'tri_seis_pulsos'
            PIV = VLLp;
            I_D_avg = Io_avg / 3;
            
        otherwise
            error('Tipo de retificador desconhecido para cálculos de diodo.');
    end

    % Salva os resultados em uma estrutura de saída
    resultados.PIV = PIV;
    resultados.I_D_avg = I_D_avg;
end