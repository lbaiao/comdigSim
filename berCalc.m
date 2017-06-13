function [ ber, receivedSymbols ] = berCalc( bits, Eb, N0 )
%BERCALC Summary of this function goes here
%   Detailed explanation goes here
    symbolVector = [];

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

    %Montando o vetor de símbolos
    for i = 0:length(bits)/3 - 1
        if (3*i + 3) <= length(bits)
            intermediario = '';
            for j = 1:3
            intermediario = strcat(intermediario, num2str(bits(3*i + j)));
            end
            switch intermediario
                case '000'
                    symbolVector = [symbolVector, compareVector(1)];
                case '001'
                    symbolVector = [symbolVector, compareVector(2)];
                case '010'
                    symbolVector = [symbolVector, compareVector(3)];
                case '011'
                    symbolVector = [symbolVector, compareVector(4)];
                case '100'
                    symbolVector = [symbolVector, compareVector(5)];
                case '101'
                    symbolVector = [symbolVector, compareVector(6)];
                case '110'
                    symbolVector = [symbolVector, compareVector(7)];
                case '111'
                    symbolVector = [symbolVector, compareVector(8)];
            end           
        end    
    end
    
    %% filtro raiz de cosseno levantado

    rolloff = 0.25;     % fator de rolloff
    span = 12;           % largura do filtro em símbolos  %se span < 12, o código não funcionará
    sps = 16;           % qtde de amostras por símbolo    
    std = sqrt(N0);         % desvio padrão do ruído

    b = rcosdesign(rolloff, span, sps, 'sqrt');         % design do filtro raiz quadrada de cosseno levantado
    x = upfirdn(symbolVector, b, sps);         % upsample e filtragem para formatação de pulso               
    r = x  + randn(size(x))*std + 1j*randn(size(x))*std;    % adição de ruído Normal com média 0, desvio padrão std
    y = upfirdn(r, b, 1, sps);                  % downsample e filtro casado
    y = y(13:length(y)-12);                     % retirando a largura adicional devido á convolução com o filtro
    receivedSymbols = y;

    
    %% extraindo sequência de bits do sinal transmitido

    estimatedSymbols = zeros(1, length(y));         %símbolos estimados
    estimatedBits = [];       %bits estimados

    %compara e estima os símbolos recebidos
    for i = 1:length(y)
        d = distance(y(i), compareVector(1));
        estSymbol = compareVector(1);
        for j = 1:length(compareVector)
            d_ij = distance(y(i), compareVector(j));
            if d_ij < d
                d = d_ij;
                estSymbol = compareVector(j);
            end
        end
        estimatedSymbols(i) = estSymbol;        

        %estima os bits recebidos
        switch(estSymbol)
            case compareVector(1)
                estimatedBits = [estimatedBits 0 0 0];
            case compareVector(2)
                estimatedBits = [estimatedBits 0 0 1];
            case compareVector(3)
                estimatedBits = [estimatedBits 0 1 0];
            case compareVector(4)
                estimatedBits = [estimatedBits 0 1 1];
            case compareVector(5)
                estimatedBits = [estimatedBits 1 0 0];
            case compareVector(6)
                estimatedBits = [estimatedBits 1 0 1];
            case compareVector(7)
                estimatedBits = [estimatedBits 1 1 0];
            case compareVector(8)
                estimatedBits = [estimatedBits 1 1 1];
        end
    end

    %% calculando a ber

    erros = 0;

    for i = 1:length(bits)
        if bits(i) ~= estimatedBits(i)
            erros = erros + 1;
        end
    end

    ber = erros/length(bits);
end

