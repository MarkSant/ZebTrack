%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Autor: Marcelo Borges Nogueira
%Data: 05/07/2011
%Descricao: extracts the center (cc,cr) and radius of the largest blobs
%recebe a imagem de fundo Imback, a imagem atual Imwork, o numero de blobs
%que desejamos detectar, o numero minimo de pixeis em um blob e a
%toloerancia tol para determinar se um pixel eh pixel de blob ou nao

%Inputs:
% Imwork -> Frame atual
% Imback -> wbackg que � o background;
% V ->
% n -> N�mero de animais a serem detectados (namimais);
% mascara -> A mascara (regi�o de interesse selecionada pelo usu�rio [� um array]);
% minpix, maxpix -> define o TAMANHO MINIMO e MAXIMO, em pixeis, de uma �rea para ser considerada de um animal.
% tol -> toler�ncia/threshold;
% avi -> aviobj2 que � o objeto de video diferen�a (n�o um v�deo!);
% criavideo -> flag pra criar o video-diferen�a (criavideodiff);
% tipsfundo -> flag que diz se h� dicas na detec��o no fundo;


%outputs:
% cc, cr ->
% radius ->
% boudingbox -> vetor que vem de stats(i).BoundingBox com as coordenadas [x0 y0 w(width) h(height)] onde x0 e y0 s�o as coordenadas do canto inferior esquerdo
% das bounding boxes dos blobs ([h w] seriam as dimens�es da bounding box enquanto matriz!);
% ndetect ->
% avi ->
% foremm -> foreground com a mascara aplicada (fore & mascara) e p�s opera��es morfol�gicas para eliminar blobs pequenos;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Autor: Marcelo Borges Nogueira
%Data: 05/07/2011
%Descricao: extracts the center (cc,cr) and radius of the largest blobs
%recebe a imagem de fundo Imback, a imagem atual Imwork, o numero de blobs
%que desejamos detectar, o numero minimo de pixeis em um blob e a
%toloerancia tol para determinar se um pixel eh pixel de blob ou nao

%Inputs:
% Imwork -> Frame atual
% Imback -> wbackg que � o background;
% V ->
% n -> N�mero de animais a serem detectados (namimais);
% mascara -> A mascara (regi�o de interesse selecionada pelo usu�rio [� um array]);
% minpix, maxpix -> define o TAMANHO MINIMO e MAXIMO, em pixeis, de uma �rea para ser considerada de um animal.
% tol -> toler�ncia/threshold;
% avi -> aviobj2 que � o objeto de video diferen�a (n�o um v�deo!);
% criavideo -> flag pra criar o video-diferen�a (criavideodiff);
% tipsfundo -> flag que diz se h� dicas na detec��o no fundo;


%outputs:
% cc, cr ->
% radius ->
% boudingbox -> vetor que vem de stats(i).BoundingBox com as coordenadas [x0 y0 w(width) h(height)] onde x0 e y0 s�o as coordenadas do canto inferior esquerdo
% das bounding boxes dos blobs ([h w] seriam as dimens�es da bounding box enquanto matriz!);
% ndetect ->
% avi ->
% foremm -> foreground com a mascara aplicada (fore & mascara) e p�s opera��es morfol�gicas para eliminar blobs pequenos;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Autor: Marcelo Borges Nogueira
%Data: 05/07/2011
%Descricao: extracts the center (cc,cr) and radius of the largest blobs
%recebe a imagem de fundo Imback, a imagem atual Imwork, o numero de blobs
%que desejamos detectar, o numero minimo de pixeis em um blob e a
%toloerancia tol para determinar se um pixel eh pixel de blob ou nao

%Inputs:
% Imwork -> Frame atual
% Imback -> wbackg que � o background;
% V ->
% n -> N�mero de animais a serem detectados (namimais);
% mascara -> A mascara (regi�o de interesse selecionada pelo usu�rio [� um array]);
% minpix, maxpix -> define o TAMANHO MINIMO e MAXIMO, em pixeis, de uma �rea para ser considerada de um animal.
% tol -> toler�ncia/threshold;
% avi -> aviobj2 que � o objeto de video diferen�a (n�o um v�deo!);
% criavideo -> flag pra criar o video-diferen�a (criavideodiff);
% tipsfundo -> flag que diz se h� dicas na detec��o no fundo;


%outputs:
% cc, cr ->
% radius ->
% boudingbox -> vetor que vem de stats(i).BoundingBox com as coordenadas [x0 y0 w(width) h(height)] onde x0 e y0 s�o as coordenadas do canto inferior esquerdo
% das bounding boxes dos blobs ([h w] seriam as dimens�es da bounding box enquanto matriz!);
% ndetect ->
% avi ->
% foremm -> foreground com a mascara aplicada (fore & mascara) e p�s opera��es morfol�gicas para eliminar blobs pequenos;



function [cc, cr, radius, boundingbox, ndetect, avi, foremm, fore] = extractnblobs(Imwork, Imback, V, n, mascara, minpix, maxpix, tol, avi, criavideo, tipsubfundo, ax1, ay1, ax2, ay2)
    cc = 0;
    cr = 0;
    radius = 0;
    ndetect = 0;
    boundingbox = 0;

    [MR, MC, cor] = size(Imback);

    if maxpix == 0
        maxpix = MR * MC / 2;
    end

    fore = zeros(MR, MC);
    colorida = (cor == 3);

    % Se coordenadas de bounding box forem fornecidas
    if nargin == 13
        labeled = zeros(MR, MC);
        for k = 1:length(ax1)
            % Extraia a subimagem dentro da bounding box
            fore = Imwork(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), :);
            Imback_sub = Imback(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), :);
            subMask = mascara(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)));

            % Subtracao de fundo dentro da bounding box
            if tipsubfundo == 0
                if ~colorida
                    fore = abs(Imback_sub - fore) > tol;
                else
                    fore = (abs(fore(:,:,1) - Imback_sub(:,:,1)) > tol) | (abs(fore(:,:,2) - Imback_sub(:,:,2)) > tol) | (abs(fore(:,:,3) - Imback_sub(:,:,3)) > tol);
                end
            else
                if ~colorida
                    fore = abs(Imback_sub - fore) > tol * V(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), 4);
                else
                    fore = (abs(fore(:,:,1) - Imback_sub(:,:,1)) > tol * V(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), 1)) ...
                            | (abs(fore(:,:,2) - Imback_sub(:,:,2)) > tol * V(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), 2)) ...
                            | (abs(fore(:,:,3) - Imback_sub(:,:,3)) > tol * V(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k)), 3));
                end
            end

            % Aplicar a m�scara na subimagem
            fore = fore & subMask;

            % Opera��es morfol�gicas na subimagem
            radImopen = max(1, round(sqrt((ay2(k) - ay1(k)) * (ax2(k) - ax1(k)) / (720 * 480))));
            foremm = imopen(fore, strel('disk', radImopen));
            radBwmorph = max(2, round(sqrt((MR * MC) / (720 * 480)) * 3));
            foremm = bwmorph(foremm, 'dilate', radBwmorph);

            % Posicionar a subimagem processada na imagem original
            labeled(round(ay1(k)):round(ay2(k)), round(ax1(k)):round(ax2(k))) = foremm;
        end
	stats = regionprops(labeled, ['basic']);
    else
        % Caso n�o receba coordenadas de bounding box, prossiga com a l�gica original
        if tipsubfundo == 0
    
    % subtracao de fundo basica: valor da diferen�a maior que threshold
    if ~colorida
        fore = abs(Imback - Imwork) > tol;
    else
        fore = (abs(Imwork(:,:,1) - Imback(:,:,1)) > tol) | (abs(Imwork(:,:,2) - Imback(:,:,2)) > tol) | (abs(Imwork(:,:,3) - Imback(:,:,3)) > tol);
    end
    
else
    
    % subtracao de fundo gaussiana: valor da diferen�a maior que
    % threshhold*raiz(variancia) para cada pixel
    if ~colorida
        fore = abs(Imback - Imwork) > tol*V(:,:,4);
    else
        fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > tol*V(:,:,1)) ...
            | (abs(Imwork(:,:,2) - Imback(:,:,2)) > tol*V(:,:,2)) ...
            | (abs(Imwork(:,:,3) - Imback(:,:,3)) > tol*V(:,:,3));
    end
    
end


%fzer um AND com a mascara
fore = fore & mascara;

% Morphology Operation  erode to remove small noise
%foremm = bwmorph(fore,'erode',2);
%foremm = bwmorph(foremm,'dilate',5);

%foremm = bwmorph(fore,'open',2);

%change the size of the elements of morphological operations based on image
%size. The base will be 720x480 images

ImArea = MR*MC;
mult = sqrt(ImArea/(720*480)); %since we specify radius below, root the multiplier
radImopen = max(1,round(mult*1));
radBwmorph = max(2,round(mult*3));

foremm = imopen(fore,strel('disk',radImopen));%erosion followed by a dilation
foremm = bwmorph(foremm,'dilate',radBwmorph);%dilate even more to join adjacent blobs

%remover operacoes morfologicas
%foremm = fore;

if criavideo
    %figure(h);
    junto = 255*foremm;
    imhandle = imshow(junto);
    set(imhandle,'ButtonDownFcn',@clickfigura );
    writeVideo(avi,uint8(junto));
end

% separete the objects found
labeled = bwlabel(foremm,8); %conectividade 8

stats = regionprops(labeled,['basic']);%basic mohem nist (only relevant information here: Area, centroid coordinates and Bounding box coordinates);
[N,W] = size(stats);                   %N-> n�mero de blobs;
if N < 1 %|| n>N %se nao achou nenhum ou achou menos que o pedido a fun��o acaba;
    return
end

% do bubble sort (large to small) on regions in case there are more than 1
id = zeros(N);
for i = 1 : N
    id(i) = i;
end
for i = 1 : N-1
    for j = i+1 : N
        if stats(i).Area < stats(j).Area
            tmp = stats(i);
            stats(i) = stats(j);
            stats(j) = tmp;
            tmp = id(i);
            id(i) = id(j);
            id(j) = tmp;
        end
    end
end


% conta quantos blobs tem mais que minpix e menos que maxpix
%falta remover os maiores que maxpix
cont=0;
for i=1:N
    if stats(i).Area > minpix && stats(i).Area < maxpix
        cont=cont+1;
    else
        break;
    end
end
selected = (labeled==id(1));
end

    % Calcular propriedades dos blobs detectados
    
    if length(stats) > 0
        ndetect = length(stats);
        for i = 1:ndetect
            centroid = stats(i).Centroid;
            radius(i) = sqrt(stats(i).Area / pi);
            cc(i) = centroid(1);
            cr(i) = centroid(2);
            boundingbox(i, 1:4) = stats(i).BoundingBox;
        end
    end

    return
end

