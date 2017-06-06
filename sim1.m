%Comunicação Digitais - Simulação 1
%
%
%
%Alunos:
%
%
%

%Gera a sequência de 100000 + 2 bits aleatórios:
bits = randi([0, 1], 1,1E5 + 2);

Es = 1;                     % energia do círculo interior
Es2 = (1 + sqrt(3))^2*Es/2; % energia círculo exterior


M = 4;                      % quantidade de símbolos no círculo

%símbolos do círculo interior;
theta = pi/4;

%001
m = 0;
s1 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

%010
m = 1;
s2 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

%111
m = 2;
s7 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

%100
m = 3;
s4 = abs(sqrt(Es))*exp(1j*(2*pi*m/M + theta));

%símbolos do círculo exterior;

%000
m = 0;
s0 = abs(sqrt(Es2))*exp(1j*(2*pi*m/M));

%011
m = 1;
s3 = abs(sqrt(Es2))*exp(1j*(2*pi*m/M));

%110
m = 2;
s6 = abs(sqrt(Es2))*exp(1j*(2*pi*m/M));

%101
m = 3;
s5 = abs(sqrt(Es2))*exp(1j*(2*pi*m/M));


%Montando o vetor de símbolos

%symbolVector = cell(1, length(bits/3));
symbolVector = [];

for i = 0:length(bits)/3 - 1
    if (3*i + 3) <= length(bits)
        intermediario = '';
        for j = 1:3
        intermediario = strcat(intermediario, num2str(bits(3*i + j)));
        end
        switch intermediario
            case '000'
                symbolVector = [symbolVector, s0];
            case '001'
                symbolVector = [symbolVector, s1];
            case '010'
                symbolVector = [symbolVector, s2];
            case '011'
                symbolVector = [symbolVector, s3];
            case '100'
                symbolVector = [symbolVector, s4];
            case '101'
                symbolVector = [symbolVector, s5];
            case '110'
                symbolVector = [symbolVector, s6];
            case '111'
                symbolVector = [symbolVector, s7];
        end           
    end    
end

%% super-amostrando o sinal

% z = zeros(15, length(symbolVector));
% symbolVector2 = [symbolVector; z];
% symbolVector2 = reshape(symbolVector2, 1, size(symbolVector2, 1)*size(symbolVector2, 2));

%% filtro raiz de cosseno levantado

symbolVector3 = [0 0 0 0 0 0 0 symbolVector];

rolloff = 0.25;     % fator de rolloff
span = 1;           % largura do filtro em símbolos
sps = 16;           % qtde de amostras por símbolo
std = 0.01;         % desvio padrão do ruído

b = rcosdesign(rolloff, span, sps);         % design do filtro raiz quadrada de cosseno levantado
x = upfirdn(symbolVector3, b, sps);         % upsample e filtragem para formatação de pulso               
r = x  + randn(size(x))*std;                % adição de ruído Normal com média 0, desvio padrão std
y = upfirdn(r, b, 1, sps);                  % downsample e filtro casado


disp('finish')
            
    