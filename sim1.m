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

disp('finish')
            
    