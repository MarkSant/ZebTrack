function [pxn,pyn] = associacao_soma_matrizes(bc2_avg_vector,centroids, cx, cy, px_ant, py_ant)
%{
note que existem nanimais. Isso que define a quantidade de centroides 
(existem, por defini��o, a mesma quantidade de centr�ides que de animais).
Ao mesmo tempo, a quantidade de blobs � uma caracter�stica do frame em
quest�o.
Logo, � poss�vel definir duas matrizes de distancia, ambas de formato qtd_blobs x
nanimais (qtd_centroids), tanto no espa�o de cores quanto no espa�o da imagem.
Como definir essas matrizes?
Vale saber que [cx cy] s�o os centr�ides dos blobs.

o primeiro passo � captar os pontos passados:

>> px_antes = px(:,cont-1); py_antes = py(:,cont-1);

e coloc�-los numa matriz:

>> mat_pxs = [px_antes py_antes];

agora define-se as matrizes:

>> D_cores = pdist2(mat_bc2_avg_v, centroids); 
>> D_imagem = pdist2(centro_de_blobs, mat_pxs);

da� basta somar:

>> D = D_cores + D_imagem
--------------
%}

    mat_bc2_avg_v = cell2mat(bc2_avg_vector);
    D_cores = pdist2(mat_bc2_avg_v, centroids);
    
    centroides_boundingbox = [cx' cy'];
    pontos_anteriores_imagem = [px_ant py_ant];
    D_imagem = pdist2(centroides_boundingbox, pontos_anteriores_imagem);
   % disp(D_cores);
    D = D_cores + D_imagem;
   % disp(D);
    %disp(centroides_boundingbox);
    %disp(pontos_anteriores_imagem);
    [~,I] = min(D,[],1);
    centroides_escolhidos = centroides_boundingbox(I,:);
    pxn = centroides_escolhidos(:,1);
    pyn = centroides_escolhidos(:,2);
    %disp(centroides_boundingbox(I,:));
    %disp(['positions = ' num2str(I)]);
    %disp(D);
    disp(centroides_boundingbox);
end