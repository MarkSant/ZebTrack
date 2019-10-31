%essa fun��o atua em apenas um �NICO FRAME, assim, � usada toda vez que se
%deseja associar os blobs de um frame com os animais detectados.

%IDEIA:
% Antes de tudo, mudar as posi��es atuais (pxa,pya) para as da dica (caso houver), i.e. :
%     pxa <- dicax
%     pya <- dicay
% depois, trabalhar em cima dos casos em que temos mais blobs que animais ou menos blobs que animais. O que importa, � que no final, associamos, em ambos os caso,
% as posi��es dos animais com a dos blobs (a rela��o � sempre animal(i)<-blob(j) ):
%     PRIMEIRO CASO(peixe mais pr�ximo com o j-�simo blob)
%       (i) pxn(maisproximo) = cx(j);
%       (ii)pyn(maisproximo) = cy(j);
%     SEGUNDO CASO(k-�simo peixe com o blob mais pr�ximo)
%       (i)pxn(k) = cx(maisproximo);           
%       (ii)pyn(k) = cy(maisproximo);
%       
% Finalmente, para animais n�o detectados, matemos a sua posi��o atual!

function [pxn,pyn,detectado,caixa] = associateeuclid(nanimais, ndetect, pxa, pya, cx, cy, radius, boundingbox, detectado, dicax, dicay, caixa, l, c, frame)

                    %No uso da fun��o associate pxn/pxa representam as vari�veis px e py, que
pxn = pxa;          %guardam as posi��es em x e y dos frames ao longo dos quadros Novo e
pyn = pya;          %Anterior.

%se nenhum blob for achado minha fun��o termina
if ndetect==0
    return
end

%verifica a dica (caso em que a pessoa que est� fazendo o rastreio julgar necess�rio assinalar o local em que o peixe est�)
if dicax ~=-1 && dicay ~=-1
    
    %acha o animal mais proximo da dica
    mindist = l^2 + c^2;        %� irrelevante come�ar com o quadrado do tamanho da diagonal da tela de ratreio aqui (que � o caso).
    
    for k=1:nanimais
        dist = sqrt( (pxa(k) - dicax)^2 + (pya(k) - dicay)^2 );     %dist�ncia euclidiana entre os pontos e as dicas.
        
        if dist < mindist           %atualizar a mindist para a distancia entre os pontos e as dicas
            mindist = dist;
            maisproximod = k;       %pego o indice do animal mais proximo(?)
        end
        
    end
    
    %as posi��es dos animais de �ndice k recebem as posi��es das dicas
    %pode ser que inclusivem fossem suas posi��es originais.
    pxa(maisproximod) = dicax;
    pya(maisproximod) = dicay;
    
end


%INICIO PROPRIAMENTE DITO DA FUN��O ASSOCIATE

md = ones(ndetect,nanimais)*(l^2 + c^2);
for j=1:ndetect %blob j
    for k=1:nanimais %animal k
        md(j,k) = sqrt( (pxa(k) - cx(j))^2 + (pya(k) - cy(j))^2 ); 
    end
end

%enquanto tiver aniamis nao associados ou elementos a serem procurados na
%matriz md
while ~isempty(find(detectado==0)) && ~isempty(find(md~=(l^2 + c^2)));
    %acha o minimo atual
    [blob,animal]=find(md==min(min(md)));
    md(blob,:) = ones(1,nanimais)*(l^2 + c^2); %bota um valor alto para nao ser mais o minimo. nma verdade pode botar na linha inteira, ja que esse blob ja foi associado
    
    if ~detectado(animal) %associa o peixe c ao blob l, se ele ainda nao foi associado a algum blob
        detectado(animal) = 1;
        pxn(animal) = cx(blob);           %Associando o centro de massa do blob com a posi��o do animal
        pyn(animal) = cy(blob);
        caixa(animal,1:4) = boundingbox(blob,:);
    end
        
end
  


end

% %se foram achados menos blobs que animais ( [-]blobs e [+] animais )
% if ndetect < nanimais
%                                 %para cada blob, acha o animal mais proximo e associa o seu centro
%                                 %de massa a posicao atual deste animal
%     for j=1:ndetect %percorre os blobs
%         
%         maisproximo = -1;       %Flag para o caso de n�o houverem animais mais pr�ximos
%         mindist = l^2 + c^2;
%         
%         %o blob vai ter sua dist�ncia comparada com a de TODOS os animais.
%         for k=1:nanimais
%             dist = sqrt( (pxa(k) - cx(j))^2 + (pya(k) - cy(j))^2 );     %calcula a dist�ncia euclidiana.
%                                                                         %cx/cy correspondente ao 'c'entro de massa do blob,
%                                                                         %j� pxa/pya a posi��o atual do animal k!
%             if (dist < mindist) && (detectado(k) == 0)      %pra que a dist�ncia do blob seja associada com o do k-�simo animal, antes, precisa-se ter um k-�simo animal detectado
%                 mindist = dist;
%                 maisproximo = k;
%             end
%             
%         end
%         
%         if maisproximo ~= -1                    %s� descubro depois de verificar pra todos os peixes no for anterior
%             pxn(maisproximo) = cx(j);           %Associando o centro de massa do blob com a posi��o do animal
%             pyn(maisproximo) = cy(j);
%             
%             detectado(maisproximo) = 1;         %Aqui digo que foi detectado um blob correspondente ao k-�simo animal(?)
%             caixa(maisproximo,1:4) = boundingbox(j,:);  %a caixa do peixe vem da bounding box do blob
%         end
%         
%     end
% 
% %foram achados mais blobs que nanimais ( [+]blobs e [-]animais )
% else
%     
%     blobassociado = zeros(ndetect);     %vetor que ira decorar cada blob que foi associado a um animal
%     
%     %para cada animal, associa o blob mais proximo
%     for k=1:nanimais
%         maisproximo = -1;
%         mindist = l^2 + c^2;
%         
%         for j=1:ndetect
%             dist = sqrt( (pxa(k) - cx(j))^2 + (pya(k) - cy(j))^2 );     %calcula a dist�ncia euclidiana entre o centro de massa do blob e a posi��o atual do peixe.
%             
%             if (dist < mindist) && (blobassociado(j)==0)                %blobassociado(j)==0 � para saber se j� encontramos o devido peixe correspondente ao blob j
%                 mindist = dist;
%                 maisproximo = j;
%             end
%             
%         end
%         
%         if maisproximo ~= -1    %s� n�o haver�o blobs mais pr�ximos de animais caso n�o seja detectado nenhum blob naquele frame!
%             pxn(k) = cx(maisproximo);
%             pyn(k) = cy(maisproximo);
%             
%             blobassociado(maisproximo) = 1;
%             detectado(k) = 1;
%             caixa(k,1:4) = boundingbox(maisproximo,:);
%         end
%         
%     end
%     
% end
% 
% %procura animais nao detectados e atribui a ultima posicao (ou
% %a previsao do filtro de kalman se este for o tipo de filtro escolhido)
% for j=1:nanimais
%     if(~detectado(j))
%         pxn(j) = pxa(j);
%         pyn(j) = pya(j);
%     end
% end
% 
% end