function [pxn,pyn] = associacao_soma_matrizes(bc2_avg_vector,centroids, cx, cy, px_ant, py_ant)
%{
note que existem nanimais. Isso que define a quantidade de centroides 
(existem, por defini��o, a mesma quantidade de centr�ides que de animais).
Ao mesmo tempo, a quantidade de blobs � uma caracter�stica do frame em
quest�o.
Logo, � poss�vel definir duas matrizes, ambas de formato qtd_blobs x
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
    pontos_imagem = [px_ant py_ant];
    D_imagem = pdist2(centroides_boundingbox, pontos_imagem);
    pxn = 3
    pyn = 2
    disp(D_cores);
    disp(D_imagem);
end