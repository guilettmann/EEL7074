function resultados = calcular_tensoes(tipo_retificador, params)
    % Extrai os parâmetros de pico da estrutura para facilitar a leitura
    Vp = params.Vp;
    VLLp = params.VLLp;

    switch tipo_retificador
        case 'mono_meia_onda'
            Vo_avg = Vp / pi;
            Vo_rms = Vp / 2;

        % Agrupando os dois casos de onda completa monofásicos,
        % pois as equações de TENSÃO DE SAÍDA são idênticas.
        case {'mono_ponte_completa', 'mono_tap_central'}
            % Para a ponte, Vp é o pico da tensão AC de entrada.
            % Para o tap central, Vp é o pico em METADE do enrolamento.
            Vo_avg = 2 * Vp / pi;
            Vo_rms = Vp / sqrt(2);

        case 'tri_ponto_medio'
            Vo_avg = (3 * sqrt(3) * Vp) / (2 * pi);
            Vo_rms = Vp * sqrt(1/2 + (3*sqrt(3))/(8*pi));

        case 'tri_seis_pulsos'
            Vo_avg = (3 * VLLp) / pi;
            Vo_rms = VLLp * sqrt(1/2 + (3*sqrt(3))/(4*pi));
            
        otherwise
            error('Tipo de retificador desconhecido em calcular_tensoes.');
    end

    % Salva os resultados em uma estrutura de saída
    resultados.Vo_avg = Vo_avg;
    resultados.Vo_rms = Vo_rms;
end