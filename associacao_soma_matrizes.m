function [pxn,pyn] = associacao_soma_matrizes()
%{
note que existem nanimais. Isso que define a quantidade de centroides 
(existem, por defini��o, a mesma quantidade de centr�ides que de animais).
Ao mesmo tempo, a quantidade de blobs � uma caracter�stica do frame em
quest�o.
Logo, � poss�vel definir duas matrizes, ambas de formato qtd_blobs x
nanimais (qtd_centroids), tanto no espa�o de cores quanto no espa�o da imagem.
Como definir essas matrizes?

o primeiro passo � o seguinte:

>> centro_de_blobs = boundingbox(:,1:2) +0.5*boundingbox(:,3:4)

isso far� com que tenhamos os centros dos blobs (dos quadrados)
o segundo passo � captar os pontos passados:

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
end