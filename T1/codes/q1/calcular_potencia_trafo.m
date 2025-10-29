function resultados = calcular_potencia_trafo(tipo_retificador, params, resultados_b)
    % Extrai valores necessários
    Vp = params.Vp;              % Tensão de pico (fase ou secundário)
    Io_rms = resultados_b.Io_rms; % Corrente RMS na carga
    
    % Tensão RMS do enrolamento secundário (fase para trifásico)
    V_sec_rms = Vp / sqrt(2);
    
    switch tipo_retificador
        case 'mono_meia_onda'
            % S_s = V_sec_rms * I_sec_rms = V_sec_rms * Io_rms
            S_trafo = V_sec_rms * Io_rms;

        case 'mono_ponte_completa' 
            % S_s = V_sec_rms * I_sec_rms = V_sec_rms * Io_rms
            S_trafo = V_sec_rms * Io_rms;
            
        case 'mono_tap_central'
            % O secundário tem DOIS enrolamentos. A potência total S_s
            % é a soma da potência aparente de cada um.
            % S_s = 2 * (V_sec_rms * I_winding_rms)
            % I_winding_rms (meia-onda) = Io_rms / sqrt(2)
            S_trafo = 2 * (V_sec_rms * (Io_rms / sqrt(2)));
            
        case 'tri_ponto_medio'
            % S_s = 3 * V_phase_rms * I_phase_rms
            % V_phase_rms = V_sec_rms
            % I_phase_rms = Io_rms / sqrt(3)
            S_trafo = 3 * (V_sec_rms * (Io_rms / sqrt(3)));
            
        case 'tri_seis_pulsos'
            % S_s = 3 * V_phase_rms * I_line_rms (para secundário em Y)
            % V_phase_rms = V_sec_rms
            % I_line_rms = Io_rms * sqrt(2/3)
            S_trafo = 3 * (V_sec_rms * (Io_rms * sqrt(2/3)));
 
    end

    % Salva os resultados em uma estrutura de saída
    resultados.S_trafo_VA = S_trafo;
end