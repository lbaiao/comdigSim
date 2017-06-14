%Comunicações Digitais - Simulação 1 - 1/2017
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
    [ber(i), ~] = berCalc(bits, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(5)
semilogy(1:1:20, ber)
xlabel('Eb/N0 db');
title({'BER x Eb/N0'});
ylabel('BER');

%% 1.2 Obtendo constelações para Eb/N0 = 0, 5, 10, 15db

Eb_N0_db = [0, 5, 10, 15];
Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;

[~, receivedSymbols0db] = berCalc(bits, Eb, N0(1));
[~, receivedSymbols5db] = berCalc(bits, Eb, N0(2));
[~, receivedSymbols10db] = berCalc(bits, Eb, N0(3));
[~, receivedSymbols15db] = berCalc(bits, Eb, N0(4));

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

%% 2 Transmissão Digital em Pacotes

it = 20;    %qtde de iterações

Eb = 1;     
Eb_N0_db = zeros(1, it);        %Eb/N0 em dB

for i=1:length(Eb_N0_db)
    Eb_N0_db(i) = i;
end

Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;

%% Cálculo PER para Eb/N0 de 0db a 20db, pacote de 50B

packSize = 50;
per50B = zeros(1, it);
throughput50B = zeros(1, it);
packages = randi([0, 1], 1,1E5 + 5 + 10*8*(1E5 + 5)/packSize);      %gera os bits aleatórios e adiciona os bits de sincronização de modo a manter a divisibilidade da sequência por 3, para a correta modulação em 8-PSK

for i=1:length(per50B)
    [per50B(i), throughput50B(i)] = perCalc(packages, packSize, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(6)
semilogy(1:1:20, per50B)
xlabel('Eb/N0 db');
title({'PER x Eb/N0 para pacotes de 50B'});
ylabel('PER');

%% Cálculo PER para Eb/N0 de 0db a 20db, pacote de 100B

packSize = 100;
per100B = zeros(1, it);
throughput100B = zeros(1, it);
packages = randi([0, 1], 1,1E5 + 0 + 10*8*(1E5 + 0)/packSize);

for i=1:length(per100B)
    [per100B(i), throughput100B(i)] = perCalc(packages, packSize, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(7)
semilogy(1:1:20, per100B)
xlabel('Eb/N0 db');
title({'PER x Eb/N0 para pacotes de 100B'});
ylabel('PER');

%% Cálculo PER para Eb/N0 de 0db a 20db, pacote de 200B

packSize = 200;
per200B = zeros(1, it);
throughput200B = zeros(1, it);
packages = randi([0, 1], 1,1E5 + 5 + 10*8*(1E5 + 5)/packSize);

for i=1:length(per200B)
    [per200B(i), throughput200B(i)] = perCalc(packages, packSize, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
end

figure(8)
semilogy(1:1:20, per200B)
xlabel('Eb/N0 db');
title({'PER x Eb/N0 para pacotes de 200B'});
ylabel('PER');

disp('finished')