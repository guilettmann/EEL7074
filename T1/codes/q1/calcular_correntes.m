function resultados = calcular_correntes(tensao_resultados, params)
% CALCULAR_CORRENTES: Calcula a corrente média e eficaz em uma carga
% puramente resistiva.
%
% ENTRADAS:
%   tensao_resultados: estrutura com as tensões calculadas (Vo_avg, Vo_rms)
%   params:            estrutura com os parâmetros de entrada (R_carga)
%
% SAÍDA:
%   resultados:        estrutura com as correntes calculadas (Io_avg, Io_rms)

    % Extrai a resistência da carga
    R_carga = params.R_carga;

    % Calcula as correntes usando a Lei de Ohm
    Io_avg = tensao_resultados.Vo_avg / R_carga;
    Io_rms = tensao_resultados.Vo_rms / R_carga;

    % Salva os resultados em uma estrutura de saída
    resultados.Io_avg = Io_avg;
    resultados.Io_rms = Io_rms;
end
