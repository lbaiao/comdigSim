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

Eb = 1;     
Eb_N0_db = zeros(1, it);        %Eb/N0 em dB
%Eb_N0_db = [5, 6];
ber = zeros(1, it);

for i=1:length(Eb_N0_db)
    Eb_N0_db(i) = i;
end

Eb_N0_pow = db2pow(Eb_N0_db);   %Eb/N0 em W
N0 = Eb./Eb_N0_pow;
%%
for i=1:length(ber)
    ber(i) = berCalc(bits, Eb, N0(i));
    display(strcat('iteração: ',' ', int2str(i)))    
 %   ber(i)
end



disp('finished')