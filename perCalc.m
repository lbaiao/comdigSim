function [ per, throughput ] = perCalc( packages, packSize, Eb, N0 )
%perCALC Summary of this function goes here
%   packSize em bytes
       
    
    packSize = 8*packSize;         %packSize em bits;

    Es = 3*Eb;                     % energia do círculo interior
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
    
    compareVector = [s0 s1 s2 s3 s4 s5 s6 s7];
    intermediario = [0 1 2 3 4 5 6 7];

    %Montando o vetor de símbolos
    symbolVector = reshape(packages, 3, length(packages)/3)';    
    symbolVector = (symbolVector(:,1)*4 + symbolVector(:,2)*2 + symbolVector(:,3)*1)';
    [~,idx] = ismember(symbolVector,intermediario);
    symbolVector = compareVector(idx);
    
    %% filtro raiz de cosseno levantado

    rolloff = 0.25;     % fator de rolloff
    span = 12;           % largura do filtro em símbolos  %se span < 12, o código não funcionará
    sps = 16;           % qtde de amostras por símbolo    
    std = sqrt(N0);         % desvio padrão do ruído

    b = rcosdesign(rolloff, span, sps, 'sqrt');         % design do filtro raiz quadrada de cosseno levantado
    x = upfirdn(symbolVector, b, sps);         % upsample e filtragem para formatação de pulso               
    r = x  + randn(size(x))*std + 1j*randn(size(x))*std;    % adição de ruído Normal com média 0, desvio padrão std
    y = upfirdn(r, b, 1, sps);                  % downsample e filtro casado
    y = y(13:length(y)-12);                     % retirando a largura adicional devido à convolução com o filtro

    
    %% extraindo sequência de bits do sinal transmitido

    estimatedSymbols = zeros(1, length(y));         %símbolos estimados    

    %compara e estima os símbolos recebidos
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
    
    %montando o vetor de bits recebidos
    intermediario = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]';
    [~,idx] = ismember(estimatedSymbols, compareVector);
    estimatedBits = intermediario(:,idx);
    estimatedBits = reshape(estimatedBits, 1, size(estimatedBits, 1)*size(estimatedBits, 2));

    %% calculando a per

    erros = 0;
    numberOfPackages = length(packages)/packSize;         %qtde de pacotes
    
    %quando ocorre erro, o pacote é descartado
    %contabiliza a quantidade de pacotes descartados
    for i = 1:numberOfPackages
        for j = 1:packSize
            if packages((i-1)*packSize + j) ~= estimatedBits((i-1)*packSize + j)
                erros = erros + 1;
                break
            end
        end        
    end

    per = erros/numberOfPackages;
    
    % calculando throughput        
    throughput = (numberOfPackages - erros)*(packSize - 80);      %para throughtput em bit/s, dividir throughput pelo tempo de transmissão
end

