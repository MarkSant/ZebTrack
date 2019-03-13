function [pxn,pyn,detectado,caixa] = associateeuclid(nanimais,ndetect,pxa,pya,cx,cy,radius,boundingbox,detectado,dicax,dicay,caixa,l,c,frame)

                    %No uso da fun��o associate pxn/pxa representam as vari�veis px e py, que
pxn = pxa;          %guardam as posi��es em x e y dos frames ao longo dos quadros iniciais e
pyn = pya;          %final.

%se nenhum blob for achado minha fun��o termina
if ndetect==0
    return
end


%verifica a dica (caso em que a pessoa que est� fazendo o rastreio julgar necess�rio assinalar o local em que o peixe est�)
if dicax ~=-1 && dicay ~=-1
    
    %acha o animal mais proximo da dica
    mindist = l^2+c^2;
    
    for k=1:nanimais
        dist = sqrt( (pxa(k)-dicax)^2 + (pya(k)-dicay)^2 );     %dist�ncia euclidiana entre os pontos e as dicas.
        
        if dist < mindist
            mindist = dist;
            maisproximod = k;       %pego o indice do animal mais proximo(?)
        end
        
    end
    
    pxa(maisproximod) = dicax;
    pya(maisproximod) = dicay;

end


%INICIO PROPRIAMENTE DITO DA FUN��O ASSOCIATE

%se foram achados menos blobs que animais
if ndetect < nanimais
                                %para cada blob, acha o animal mais proximo e associa o ceu centro
                                %de massa a posicao atual deste animal
    for j=1:ndetect %percorre os blobs
        
        maisproximo = -1;       %Flag para o caso de n�o houverem animais mais pr�ximos
        mindist = l^2+c^2;
        
        for k=1:nanimais
            dist = sqrt( (pxa(k)-cx(j))^2 + (pya(k)-cy(j))^2 );     %calcula a dist�ncia euclidiana.
                                                                    %cx/cy correspondente ao 'c'entro de massa do blob,
                                                                    %j� pxa/pya a posi��o atual do animal k!
            if dist < mindist && detectado(k)==0
                mindist = dist;
                maisproximo = k;
            end
            
        end
        
        if maisproximo ~= -1                    %s� descubro depois de verificar pra todos os peixes no for anterior
            pxn(maisproximo) = cx(j);           %Associando o centro de massa do blob com a posi��o do animal
            pyn(maisproximo) = cy(j);
            
            detectado(maisproximo) = 1;         %Aqui digo que foi detectado um blob correspondente ao k-�simo animal(?)
            caixa(maisproximo,1:4) = boundingbox(j,:);  %a caixa do peixe vem da bounding box do blob
        end
        
    end
    
else %foram achados mais blobs que nanimais
    
    blobassociado = zeros(ndetect);     %vetor que ira decorar cada blob que foi associado a um animal
    
    %para cada animal, associa o blob mais proximo
    for k=1:nanimais
        maisproximo = -1;
        mindist = l^2+c^2;
        
        for j=1:ndetect
            dist = sqrt( (pxa(k)-cx(j))^2 + (pya(k)-cy(j))^2 );     %calcula a dist�ncia euclidiana entre o centro de massa do blob e a posi��o atual do peixe.
            
            if dist < mindist && blobassociado(j)==0                %blobassociado(j)==0 � para saber se j� encontramos o devido peixe correspondente ao blob j
                mindist = dist;
                maisproximo = j;
            end
            
        end
        
        if maisproximo ~= -1
            pxn(k) = cx(maisproximo);
            pyn(k) = cy(maisproximo);
            blobassociado(maisproximo) = 1;
            detectado(k) = 1;
            caixa(k,1:4) = boundingbox(maisproximo,:);
        end
        
    end
    
end

%procura animais nao detectados e atribui a ultima posicao (ou
%a previsao do filtro de kalman se este for o tipo de filtro escolhido)
for j=1:nanimais
    if(~detectado(j))
        pxn(j) = pxa(j);
        pyn(j) = pya(j);
    end
end

end