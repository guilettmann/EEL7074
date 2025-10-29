function resultados = calcular_thd_i(tipo_retificador)
    switch tipo_retificador
        case 'mono_meia_onda'
            % A corrente de entrada é uma meia-onda.
            % THD_i = sqrt( (I_rms / I_1_rms)^2 - 1 )
            % Onde I_rms = Ip/2 e I_1_rms = Ip/(2*sqrt(2))
            % THD_i = sqrt( (sqrt(2))^2 - 1 ) = 100%
            thd_i_percent = 100.0;

        case 'mono_ponte_completa'
            % Para a ponte com carga resistiva e trafo 1:1, a corrente
            % na fonte AC (primário) é uma senóide perfeita.
            % Portanto, não há harmônicos.
            thd_i_percent = 0.0;
            
        case 'mono_tap_central'
            % A corrente no primário reflete as duas meias-ondas
            % do secundário, criando uma onda quadrada.
            % O THD teórico de uma onda quadrada é 48.34%.
            thd_i_percent = 48.34;

        case 'tri_ponto_medio'
            thd_i_percent = 80.6;

        case 'tri_seis_pulsos'
            thd_i_percent = 31.08;
            
        otherwise
            error('Tipo de retificador desconhecido para THD.');
    end

    resultados.THD_i_percent = thd_i_percent;
end


