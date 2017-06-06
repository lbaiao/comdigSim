%Comunica��o Digitais - Simula��o 1
%
%
%
%Alunos:
%
%
%

%Gera a sequ�ncia de 100000 + 2 bits aleat�rios:
bits = randi([0, 1], 1,1E5 + 2);

Es = 1;                     % energia do c�rculo interior
Es2 = (1 + sqrt(3))^2*Es/2; % energia c�rculo exterior


M = 4;                      % quantidade de s�mbolos no c�rculo

%s�mbolos do c�rculo interior;
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

%s�mbolos do c�rculo exterior;

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


%Montando o vetor de s�mbolos

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
span = 1;           % largura do filtro em s�mbolos
sps = 16;           % qtde de amostras por s�mbolo
std = 0.01;         % desvio padr�o do ru�do

b = rcosdesign(rolloff, span, sps);         % design do filtro raiz quadrada de cosseno levantado
x = upfirdn(symbolVector3, b, sps);         % upsample e filtragem para formata��o de pulso               
r = x  + randn(size(x))*std;                % adi��o de ru�do Normal com m�dia 0, desvio padr�o std
y = upfirdn(r, b, 1, sps);                  % downsample e filtro casado


disp('finish')
            
    