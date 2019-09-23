%essa fun��o atua em apenas um �NICO FRAME, assim, � usada toda vez que se
%deseja associar os blobs de um frame com os animais detectados.

%IDEIA:
% Antes de tudo, mudar as posi��es atuais (px_anterior,py_anterior) para as da dica (caso houver), i.e. :
%     px_anterior <- dicax
%     py_anterior <- dicay
% depois, trabalhar em cima dos casos em que temos mais blobs que animais ou menos blobs que animais. O que importa, � que no final, associamos, em ambos os caso,
% as posi��es dos animais com a dos blobs (a rela��o � sempre animal(i)<-blob(j) ):
%     PRIMEIRO CASO(peixe mais pr�ximo com o j-�simo blob)
%       (i) px_novo(maisproximo) = cx(j);
%       (ii)py_novo(maisproximo) = cy(j);
%     SEGUNDO CASO(k-�simo peixe com o blob mais pr�ximo)
%       (i)px_novo(k) = cx(maisproximo);           
%       (ii)py_novo(k) = cy(maisproximo);
%       
% Finalmente, para animais n�o detectados, matemos a sua posi��o atual!

%LEGENDA:
%-> alpha = coeficiente da pondera��o nos c�lculos das dist�ncias
%-> caixa = recebe uma bounding box de um dado blob quando realizada a associa��o adequada (do k-esimo peixe e com 4 coordenadas, ou seja, k x 4)
%-> cx/cy = posi��es atuais do CENTRO DE MASSA do blob
%-> px_anterior/py_anterior = posi��es atuais do peixe(anteriores)
%-> cor_atual_blobs = vetor que armazena os valores escalares das cores atuais dos peixes
%-> vetor_media_peixes = vetor que armazena os valores das cores m�dias de cada peixe
%-> vetor_variancia_peixes = vetor que armazena os valores das vari�ncias das cores de cada peixe
%       OBS: o tamanho dos tr�s vetores acima � IGUAL.

function [px_novo, py_novo, detectado, caixa] = associatefudera(nanimais, num_blobs_detected, px_anterior, py_anterior, cx, cy, radius, ...
                                                        boundingbox, detectado, dicax, dicay, caixa, l, c, frame, ...
                                                        cor_atual_blobs, vetor_media_peixes, vetor_variancia_peixes, ...
                                                        alpha)
                                                    
                        %No uso da fun��o associate px_novo/px_anterior representam as vari�veis px e py, que
    px_novo = px_anterior;          %guardam as posi��es em x e y dos frames ao longo dos quadros Novo e
    py_novo = py_anterior;          %Anterior.

    %se nenhum blob for achado minha fun��o termina
    if num_blobs_detected == 0
        return
    end

    %verifica a dica (caso em que a pessoa que est� fazendo o rastreio julgar necess�rio assinalar o local em que o peixe est�)
    if dicax ~=-1 && dicay ~=-1

        %acha o animal mais proximo da dica
        mindist = l^2 + c^2;        %� irrelevante come�ar com o quadrado do tamanho da diagonal da tela de ratreio aqui (que � o caso).

        for k=1:nanimais
            dist = sqrt( (px_anterior(k) - dicax)^2 + (py_anterior(k) - dicay)^2 );     %dist�ncia euclidiana entre os pontos e as dicas.

            if dist < mindist           %atualizar a mindist para a distancia entre os pontos e as dicas
                mindist = dist;
                maisproximod = k;       %pego o indice do animal mais proximo(?)
            end

        end

        %as posi��es dos animais de �ndice k recebem as posi��es das dicas
        %pode ser que inclusivem fossem suas posi��es originais.
        px_anterior(maisproximod) = dicax;
        py_anterior(maisproximod) = dicay;

    end
    
    %tratamento quando entra uma cor atual que � um NaN
    alpha_tratado = alpha;  %alpha_tratado vai mudar se cor_atual_blobs(i) for um NaN! (a gente passa a trabalhar s� com dist�ncias euclidianas)
  
    
    %INICIO PROPRIAMENTE DITO DA FUN��O

    
    %se foram achados menos blobs que animais ( [-]blobs e [+] animais )
    if num_blobs_detected < nanimais
                                        %para cada blob, acha o animal mais proximo e associa o seu centro
                                        %de massa a posicao atual deste animal
        for j=1:num_blobs_detected %percorre os blobs

            maisproximo = -1;       %Flag para o caso de n�o houverem animais mais pr�ximos
            primeiravez = true;
            
            %o blob vai ter sua dist�ncia comparada com a de TODOS os animais.
            for k=1:nanimais
     
                %tratamento de alpha
                if isnan(cor_atual_blobs(k))
                    alpha_tratado = 1;
                    dist_cor = 0;   %n�o faz sentido usar a dist�ncia no espa�o de cores nessas condi��es;
                else
                    alpha_tratado = alpha;
                    dist_cor = calcula_Mahalanobis(cor_atual_blobs(j), vetor_media_peixes(k), vetor_variancia_peixes(k)); %calcula a dist�ncia em um espa�o de cores
                end
                
                %cx/cy correspondente ao 'c'entro de massa do blob,
                %j� px_anterior/py_anterior a posi��o anterior do animal k!
                dist_euclidiana = sqrt( (px_anterior(k) - cx(j))^2 + (py_anterior(k) - cy(j))^2 );     %calcula a dist�ncia euclidiana.
                
                dist = alpha_tratado*dist_euclidiana + (1 - alpha_tratado)*dist_cor;    %dist�ncia ponderada
                
                if primeiravez && detectado(k) == 0
                   primeiravez = false;
                   mindist = dist;
                end
                
                if (dist <= mindist) && (detectado(k) == 0)      %pra que a dist�ncia do blob seja associada com o do k-�simo animal, antes, precisa-se ter um k-�simo animal detectado
                    mindist = dist;
                    maisproximo = k;
                end

            end

            if maisproximo ~= -1                    %s� descubro depois de verificar pra todos os peixes no for anterior
                px_novo(maisproximo) = cx(j);           %Associando o centro de massa do blob com a posi��o do animal
                py_novo(maisproximo) = cy(j);

                detectado(maisproximo) = 1;         %Aqui digo que foi detectado um blob correspondente ao k-�simo animal(?)
                caixa(maisproximo,1:4) = boundingbox(j,:);  %a caixa do peixe vem da bounding box do blob
            end

        end

    %foram achados mais blobs que nanimais ( [+]blobs e [-]animais )
    else

        blobassociado = zeros(num_blobs_detected);     %vetor que ira decorar cada blob que foi associado a um animal

        %para cada animal, associa o blob mais proximo
        for k=1:nanimais
            maisproximo = -1;
            primeiravez = true;
            
            %tratamento de alpha
            if isnan(cor_atual_blobs(k))
                alpha_tratado = 1;
                dist_cor = 0;   %n�o faz sentido usar a dist�ncia no espa�o de cores nessas condi��es;
            else
                alpha_tratado = alpha;
                dist_cor = calcula_Mahalanobis(cor_atual_blobs(k), vetor_media_peixes(k), vetor_variancia_peixes(k)); %calcula a dist�ncia em um espa�o de cores
            end
            
            for j=1:num_blobs_detected
                dist_euclidiana = sqrt( (px_anterior(k) - cx(j))^2 + (py_anterior(k) - cy(j))^2 );     %calcula a dist�ncia euclidiana entre o centro de massa 
                                                                                                       %do blob e a posi��o atual do peixe.
                
                dist = alpha_tratado*dist_euclidiana + (1 - alpha_tratado)*dist_cor;    %dist�ncia ponderada
                
                if primeiravez && detectado(j) == 0
                    primeiravez = false;
                    mindist = dist;
                end
                
                if (dist <= mindist) && (blobassociado(j)==0)                %blobassociado(j)==0 � para saber se j� encontramos o devido peixe correspondente ao blob j
                    mindist = dist;
                    maisproximo = j;
                end

            end

            if maisproximo ~= -1    %s� n�o haver�o blobs mais pr�ximos de animais caso n�o seja detectado nenhum blob naquele frame!
                px_novo(k) = cx(maisproximo);
                py_novo(k) = cy(maisproximo);

                blobassociado(maisproximo) = 1;
                detectado(k) = 1;
                caixa(k,1:4) = boundingbox(maisproximo,:);
            end

        end

    end                                                 
                                                                                                 
                                                    
end

function  distanciaMahalanobis = calcula_Mahalanobis(valor_cor_atual, media, variancia)
    distanciaMahalanobis = abs((valor_cor_atual - media))/variancia;
end
