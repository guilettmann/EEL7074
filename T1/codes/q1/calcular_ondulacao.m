function resultados = calcular_ondulacao(tensao_resultados)
% CALCULAR_ONDULACAO: Calcula o fator de ondulação (ripple)
% da tensão e corrente na carga, em %. (Item c)
%
% ENTRADA:
%   tensao_resultados: estrutura com as tensões (Vo_avg, Vo_rms)
%
% SAÍDA:
%   resultados:        estrutura com os ripples (ripple_V, ripple_I)

    % Extrai as tensões calculadas
    Vo_avg = tensao_resultados.Vo_avg;
    Vo_rms = tensao_resultados.Vo_rms;

    % Calcula o Fator de Ondulação (r)
    % r = sqrt((V_rms / V_avg)^2 - 1)
    % Se V_avg for 0 (ex: fonte AC pura), evitamos divisão por zero.
    if Vo_avg == 0
        fator_ondulacao = Inf;
    else
        fator_ondulacao = sqrt((Vo_rms / Vo_avg)^2 - 1);
    end

    % Para carga resistiva, o ripple de corrente é idêntico ao de tensão.
    % O resultado é multiplicado por 100 para ser expresso em porcentagem.
    resultados.ripple_V_percent = fator_ondulacao * 100;
    resultados.ripple_I_percent = fator_ondulacao * 100;
end