%Comunicação Digitais - Simulação 1 - 1/2017
%
%
%
%Alunos:
%
%
%

%Gera a sequência de 100000 + 2 bits aleatórios:
bits = randi([0, 1], 1,1E5 + 2);


it = 20;    %qtde de iterações

receivedSymbols = [];

Eb = 1;     
Eb_N0_db = zeros(1, it);        %Eb/N0 em dB
ber = zeros(1, it);

for i=1:length(Eb_N0_db)
    Eb_N0_db(i) = i;
end

Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;
%% 1.1 Cálculo BER para Eb/N0 de 0db a 20db
for i=1:length(ber)
    [ber(i), receivedSymbols] = berCalc(bits, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(5)

plot(1:1:20, log10(ber))
xlabel('Eb/N0');
title({'log10(BER) x Eb/N0'});
ylabel('log10(BER)');

%% 1.2 Obtendo constelações para Eb/N0 = 0, 5, 10, 15db

Eb_N0_db = [0, 5, 10, 15];
Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;

[ber0db, receivedSymbols0db] = berCalc(bits, Eb, N0(1));
[ber5db, receivedSymbols5db] = berCalc(bits, Eb, N0(2));
[ber10db, receivedSymbols10db] = berCalc(bits, Eb, N0(3));
[ber15db, receivedSymbols15db] = berCalc(bits, Eb, N0(4));

figure(1)
plot(real(receivedSymbols0db), imag(receivedSymbols0db), '.');
title('Constelação para Eb/N0 = 0db')

figure(2)
plot(real(receivedSymbols5db), imag(receivedSymbols5db), '.');
title('Constelação para Eb/N0 = 5db')

figure(3)
plot(real(receivedSymbols10db), imag(receivedSymbols10db), '.');
title('Constelação para Eb/N0 = 10db')

figure(4)
plot(real(receivedSymbols15db), imag(receivedSymbols15db), '.');
title('Constelação para Eb/N0 = 15db')

disp('finished')