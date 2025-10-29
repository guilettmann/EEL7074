%% Script MATLAB/Octave para Cálculo de Ripple em Retificador Monofásico
% Vrms = 220V, f = 60Hz, Vd = 0V. C fixado no valor projetado para 1% ripple (C_prop).

% -------------------------
% 1. Parâmetros e Constantes
% -------------------------
V_rms = 220;      % Tensão RMS de entrada (V)
f = 60;           % Frequência da rede (Hz)
V_D = 0;          % Queda de tensão no diodo (V)
P_nom = 10;       % Potência nominal (W)
ripple_percentual_alvo = 0.01; % Alvo para C: 1% de ripple

V_p = V_rms * sqrt(2);     % Tensão de pico
V_C_max = V_p - 2*V_D;     % Tensão máxima no capacitor
T_linha = 1 / (2 * f);     % Semi-período (s)
omega = 2 * pi * f;        % Velocidade angular

% ----------------------------------------------------------------------
% 2. CÁLCULO DAS CAPACITÂNCIAS PARA O RIPPLE ALVO (1%)
% ----------------------------------------------------------------------
V_o_med_alvo = V_C_max / (1 + ripple_percentual_alvo / 2);
DeltaV_max = ripple_percentual_alvo * V_o_med_alvo;
R_L_min_alvo = V_o_med_alvo^2 / P_nom; 
I_o_nom = P_nom / V_o_med_alvo; % Corrente média nominal (usada em ambos os métodos)

% --- C_simplificado (Aproximação Linear) ---
C_simp = (I_o_nom * T_linha) / DeltaV_max;

% --- C_proposto (Exponencial e Delta_t_d exato) ---
V_C_min_alvo = V_C_max - DeltaV_max;
theta1_rad = asin(V_C_min_alvo / V_p);
Delta_t_d = (pi/2 + theta1_rad) / omega;
C_prop = -Delta_t_d / (R_L_min_alvo * log(V_C_min_alvo / V_C_max));

C_usado = C_prop; % Fixamos C_prop (o valor mais preciso) para gerar a tabela.

% ----------------------------------------------------------------------
% 3. Geração dos Valores da Tabela (Ambos os Ripples com C_usado = C_prop)
% ----------------------------------------------------------------------
percentuais_carga = [100, 75, 50, 25, 10];
num_pontos = length(percentuais_carga);
DeltaV_simp_vet = zeros(num_pontos, 1);
DeltaV_prop_vet = zeros(num_pontos, 1);
R_L_vet = zeros(num_pontos, 1);
I_o_vet = zeros(num_pontos, 1);

for i = 1:num_pontos
    P_carga = P_nom * (percentuais_carga(i) / 100);

    % --- 1. Metodologia Proposta (Cálculo Iterativo Exponencial) ---
    V_o_med_est = V_C_max - 0.03/2; % Estimativa inicial de V_o_med
    
    for j = 1:5 % 5 iterações para convergência
        R_L = V_o_med_est^2 / P_carga;
        V_C_min = V_C_max * exp(-Delta_t_d / (R_L * C_usado));
        V_o_med_est = V_C_min + (V_C_max - V_C_min) / 2; 
    end
    
    DeltaV_prop = V_C_max - V_C_min;
    
    % --- 2. Cálculo Simplificado (Aproximação Linear) ---
    % Usa a corrente média (I_o) determinada pelo cálculo preciso
    R_L_vet(i) = R_L;
    I_o = V_o_med_est / R_L;
    I_o_vet(i) = I_o;
    
    DeltaV_simp = (I_o * T_linha) / C_usado;
    DeltaV_simp_vet(i) = DeltaV_simp;
    DeltaV_prop_vet(i) = DeltaV_prop;
end

% -------------------------
% 4. Formatação da Saída
% -------------------------
disp('---------------------------------------------------------');
disp('Resultados do Projeto (Alvo: 1% Ripple)');
disp(['C_proposto (Preciso):   ', num2str(C_prop * 1e6, '%.2f'), ' uF']);
disp(['C_simplificado (Linear):', num2str(C_simp * 1e6, '%.2f'), ' uF']);
disp('---------------------------------------------------------');
disp('Tabela Comparativa de Ripple (V)');
fprintf('\n| %% Carga | R_L (Ohm) | I_o (A) | Delta V Simpl. | Delta V Proposta |\n');
fprintf('|---------|-----------|---------|----------------|------------------|\n');
for i = 1:num_pontos
    fprintf('| %7.0f | %9.0f | %7.4f | %14.2f | %16.2f |\n', ...
        percentuais_carga(i), R_L_vet(i), I_o_vet(i), DeltaV_simp_vet(i), DeltaV_prop_vet(i));
end