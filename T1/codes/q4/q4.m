%==========================================================================
% CÁLCULO COMPLETO DO RETIFICADOR TRIFÁSICO RLE
% Inclui: 
% 1. Parâmetros de Carga/Rede
% 2. Cálculo do Ângulo de Extinção (Beta) para um Alpha dado (Iteração Numérica)
% 3. Cálculo do Ângulo de Disparo Crítico (Alpha_crit)
%==========================================================================

% --- 1. Parâmetros do Projeto ---
R = 2;              % Resistência (Ohms)
L = 25e-3;          % Indutância (Henry)
E = 250;            % Tensão da Bateria (V)
V_LL_rms = 380;     % Tensão de Linha RMS (V)
f = 60;             % Frequência (Hz)
alpha_deg = 30;     % Ângulo de Disparo para Análise de Beta (Exemplo)

% --- 2. Parâmetros Derivados ---
omega = 2 * pi * f;     % Velocidade angular (rad/s)
V_p = V_LL_rms * sqrt(2); % Tensão de Pico de Linha (V)
X_L = omega * L;        % Reatância Indutiva (Ohms)
Z = sqrt(R^2 + X_L^2);  % Impedância (Ohms)
phi = atan(X_L / R);    % Ângulo de Impedância (rad)
tau_w = (omega * L) / R; % Fator de Tempo (tau * omega)

alpha_rad = deg2rad(alpha_deg);
alpha_offset = alpha_rad + (pi/6); % Ângulo de Disparo Absoluto (a partir de 0)

% ========================================================================
% PARTE A: CÁLCULO DO ÂNGULO DE DISPARO CRÍTICO (ALPHA_CRIT)
% Condição: Vo = E
% ========================================================================

disp('----------------------------------------');
disp('CÁLCULO DO ÂNGULO DE DISPARO CRÍTICO');
disp('----------------------------------------');

V_o_max = (3 * V_p) / pi;
cos_alpha_crit = E / V_o_max;

if cos_alpha_crit > 1
    disp('ERRO: E > Vo_max. Condução contínua não é possível.');
    alpha_crit_deg = NaN;
else
    alpha_crit_rad = acos(cos_alpha_crit);
    alpha_crit_deg = rad2deg(alpha_crit_rad);
    fprintf('Alpha Crítico (alpha_crit): %.2f graus\n', alpha_crit_deg);
end

% ========================================================================
% PARTE B: CÁLCULO DO ÂNGULO DE EXTINÇÃO (BETA)
% ========================================================================

disp('----------------------------------------');
disp('CÁLCULO DO ÂNGULO DE EXTINÇÃO (BETA)');
disp(['Alpha de teste: ', num2str(alpha_deg), ' graus']);
disp('----------------------------------------');

% --- 3. Definição da Função de Corrente (i_o = 0) ---
% A função retorna a corrente instantânea no ângulo absoluto "gamma"
% Onde: gamma = beta + pi/6
funcao_corrente = @(gamma) (V_p/Z) * (sin(gamma - phi) - sin(alpha_offset - phi) * exp(-(gamma - alpha_offset) / tau_w)) ...
                          - (E/R) * (1 - exp(-(gamma - alpha_offset) / tau_w));

% --- 4. Configuração do Método da Bisseção ---
gamma_a = alpha_offset; 
gamma_b = 2 * pi; % Limite superior de busca (360 graus)
tolerancia = 1e-6;
max_iter = 1000;
iter = 0;

% --- 5. Execução do Método da Bisseção ---
if (funcao_corrente(gamma_a) * funcao_corrente(gamma_b) > 0)
    % Se i(gamma_a) e i(gamma_b) têm o mesmo sinal, a raiz pode não estar no intervalo.
    % Isso geralmente significa Condução Contínua ou o limite de busca é muito pequeno.
    beta_deg = NaN;
    disp('Aviso: A raiz pode não estar no intervalo [alpha+pi/6, 2*pi].');
    disp('Possível MODO DE OPERAÇÃO: Condução Contínua (Beta >= Alpha + 60 graus)');
end
    
    % Se for condução contín