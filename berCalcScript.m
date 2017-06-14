%Comunica��es Digitais - Simula��o 1
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

intermediario = [0 1 2 3 4 5 6 7];
compareVector = [s0 s1 s2 s3 s4 s5 s6 s7];

%Montando o vetor de s�mbolos

symbolVector = reshape(bits, 3, length(bits)/3)';    
symbolVector = (symbolVector(:,1)*4 + symbolVector(:,2)*2 + symbolVector(:,3)*1)';
[~,idx] = ismember(symbolVector,intermediario);
symbolVector = compareVector(idx);

%% super-amostrando o sinal

% z = zeros(15, length(symbolVector));
% symbolVector2 = [symbolVector; z];
% symbolVector2 = reshape(symbolVector2, 1, size(symbolVector2, 1)*size(symbolVector2, 2));

%% filtro raiz de cosseno levantado

%symbolVector3 = [symbolVector];

rolloff = 0.25;     % fator de rolloff
span = 12;           % largura do filtro em s�mbolos
sps = 16;           % qtde de amostras por s�mbolo
std = 0.01;         % desvio padr�o do ru�do

b = rcosdesign(rolloff, span, sps, 'sqrt');         % design do filtro raiz quadrada de cosseno levantado
x = upfirdn(symbolVector, b, sps);         % upsample e filtragem para formata��o de pulso               
r = x  + randn(size(x))*std + 1j*randn(size(x))*std;    % adi��o de ru�do Normal com m�dia 0, desvio padr�o std
y = upfirdn(r, b, 1, sps);                  % downsample e filtro casado
y = y(13:length(y)-12);                     % retirando a largura adicional devido � convolu��o com o filtro

%% densidade espectral de pot�ncia

Fs = 16;
N = length(r);
xdft = fft(r);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(r):Fs/2;

plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

%% extraindo sequ�ncia de bits do sinal transmitido

estimatedSymbols = zeros(1, length(y));         %s�mbolos estimados    

%compara e estima os s�mbolos recebidos
for i = 1:length(y)
    d = distance(y(i), compareVector(1));
    estimatedSymbols(i) = compareVector(1);
    for j = 1:length(compareVector)
        d_ij = distance(y(i), compareVector(j));
        if d_ij < d
            d = d_ij;
            estimatedSymbols(i) = compareVector(j);
        end
    end             
end

%montando o vetor bits estimados
intermediario = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]';
[~,idx] = ismember(estimatedSymbols, compareVector);
estimatedBits = intermediario(:,idx);
estimatedBits = reshape(estimatedBits, 1, size(estimatedBits, 1)*size(estimatedBits, 2));

%% calculando a ber

erros = 0;

for i = 1:length(bits)
    if bits(i) ~= estimatedBits(i)
        erros = erros + 1;
    end
end

ber = erros/length(bits);

disp('finish')
            
%% Plots retardados
% figure(1)
% plot(real(symbolVector), imag(symbolVector), '.')
% title('symbolVector')
% 
% figure(2)
% plot(real(estimatedSymbols), imag(estimatedSymbols), '.')
% title('estimatedSymbols')
    