function resultados = calcular_fp(tipo_retificador, params, resultados_a)
    % Extrai valores necessários
    Vp = params.Vp;
    R_carga = params.R_carga;
    Vo_rms = resultados_a.Vo_rms;
    P_in = (Vo_rms^2) / R_carga;

    % 2. Potência Aparente de Entrada (S_in)
    V_o_rms_para_I = Vo_rms;
    
    if contains(tipo_retificador, 'mono')
        % S_in = V_in_rms * I_in_rms
        % V_in_rms = Vp / sqrt(2)
        % I_in_rms = I_o_rms = Vo_rms / R_carga
        V_in_rms = Vp / sqrt(2);
        I_in_rms = V_o_rms_para_I / R_carga;
        S_in = V_in_rms * I_in_rms;

    elseif strcmp(tipo_retificador, 'tri_ponto_medio')
        % S_in = 3 * V_phase_rms * I_phase_rms
        % V_phase_rms = Vp / sqrt(2)
        % I_phase_rms = I_o_rms / sqrt(3) = (Vo_rms / R_carga) / sqrt(3)
        V_phase_rms = Vp / sqrt(2);
        I_phase_rms = (V_o_rms_para_I / R_carga) / sqrt(3);
        S_in = 3 * V_phase_rms * I_phase_rms;
        
    elseif strcmp(tipo_retificador, 'tri_seis_pulsos')
        % S_in = 3 * V_phase_rms * I_line_rms (para Wye)
        % V_phase_rms = Vp / sqrt(2)
        % I_line_rms = I_o_rms * sqrt(2/3) = (Vo_rms / R_carga) * sqrt(2/3)
        V_phase_rms = Vp / sqrt(2);
        I_line_rms = (V_o_rms_para_I / R_carga) * sqrt(2/3);
        S_in = 3 * V_phase_rms * I_line_rms;
    end
    if S_in == 0
        FP = 0;
    else
        FP = P_in / S_in;
    end
    
    resultados.FP = FP;
end