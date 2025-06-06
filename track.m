%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Autor: Marcelo Borges Nogueira
%Data: 17/04/2013
%Descricao: Programa que faz o rastreamento de um ou mais animais a partir
%de imagens, e ao final informa varios dados relativos a
%posicao/velocidade dos animais
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%retornos (variaveis de saida):
%   t: vetor tempo (em segundos)
%   posicao: estrutura, com nanimais elementos, com campos x e y que
%           representam a posicao, em cm, de cada peixe em funcao do tempo
%           nos eixos x e y
%   velocidade: estrutura, com nanimais elementos, com campos x, y e total
%           que representam a velocidade de cada animal em funcao do tempo,
%           em cm/s, nos eixos x, y e velocidade total
%   parado: vetor com estrutura - tempo inicial, tempo final e
%           posicao inicial e final em que cada animal esteve parado
%   dormindo: vetor com estrutura - tempo inicial, tempo final e
%           posicao inicial e final em que cada animal esteve dormindo
%   tempoareas: matriz com estrutura - tempo inicial e tempo final em que
%           um certo animal esteve dentro de cada �rea informada na entrada
%   distperc: vetor com a distancia percorrida total de cada peixe (em cm)
%   comportamento: vetor com estrutura - tipo (codigo numerico) do comportamento atual,
%           tempo inicial, tempo final e posicao inicial e final de cada
%           peixe
%
%argumentos (variaveis de entrada):
%   mostraresnatela: dize se mostra o resultado na tela enquanto executa
%           0 -> nao mostra,  1 -> mostra
%   quadroini, quadrofim: numero dos quadros inicias e finais que deve ser
%           processados
%   fotos: caminho onde se encontra o  video e onde serao salbos os resultados.
%   video: objeto de video com o video do experimento
%   pixelcm: estrutura com campos x e y que informa a rela��o
%           pixel-centimetro (em pixels por centimetro)
%   nanimais: numero de animais que queremos detectar
%   procframe: processar 1 a cada procframe
%   corte: estrutura com campos xi,yi,xf,yf que especificam o retangulo no
%           qual sera feito o processamento para cortar a superficie do
%           aquario e outras areas com movimentos marginais (em pixels)
%   areas: vetor de estruturas xi,yi,xf,yf que definem areas de interesse (em
%           pixels)
%   areasexc: vetor de estruturas xi,yi,xf,yf que definem areas de exclusao (em
%           pixels)
%   viddiff: informa se vai criar o video com as imagens diferencas
%   thresh : o quanto cada pixel tem que mudar do fundo para se considerar
%           que houve movimento
%   filt: valor do filtro que depende da velocidade maxima do animal (valor
%           entre 0 -> filtragem maxima (animal nao mexe), e 1 -> sem filtragem)
%   handles: referencia para a janela grafica (para mostrar resultados do
%           tracking nela)
%   fundodinamico: indica se vamos utilizar fundo adaptativo
%   tipfilt: tipo de filtragem utilizada 0 -> media movel  1 -> kalman
%   tipsubfundo: tipo de subtracao de fundo 0 -> subtracao basica  1 ->
%           subtracao que leva em consideracao a estatistica (variancia) da imagem
%           de fundo criada
%   velmin: velocidade minima, em cm/s, para que um animal seja considerado parado
%   tempmin: tempo minimo, em segundos, para que um animal com velocidade
%           abaixo de velmin seja considerado parado
%   tempminparado: tempo m�nimo parado, em segundos, para que seja
%           considerado que esta dormindo
%   subcor: usar imagem colorida na subtracao de fundo: 0 -> imagem tons de
%           cinza  1 -> imagem colorida
%   cameralenta: indica, em segundos, o valor de pausa entre a exibi��o de
%           cada processamento
%   trackmouse: indica se o programa ira apenas rastrear o mouse
%   
%   liveTracking: faz o rastreamento a partir de imagens obtidas de uma
%   webcam
%   trackindividuals: flag para utilizar um banco de features para idendificar cada
%   animal 
%   labels = vetor de caracteristicas de cada animal
%  labels_cov = matriz de covariancia dos labels
%   actions: conjunto de a��es para envio para hardware externo
%   pinicial: posi��o inicial do peixe




function [t,posicao,velocidade,parado,dormindo,tempoareas,distperc,comportamento,parado_area,contparado_area] = track(mostraresnatela,quadroini,quadrofim,fotos,video,pixelcm,nanimais,procframe...
    ,corte,areas,areasexc,criavideores,viddiff,thresh,filt,handles,fundodinamico,tipfilt,tipsubfundo,velmin,tempmin,tempminparado,subcor,cameralenta,trackmouse,liveTracking,trackindividuals,labels,labels_cov,actions,pinicial,csvPositionData)

    %CONSTANTES A SEREM AJUSTADAS:
    
     % Verifica��o do par�metro csvPositionData
    if exist('csvPositionData', 'var') && ~isempty(csvPositionData)
        %disp('csvPositionData est� presente e n�o est� vazio.');
        
        % Adicione o c�digo necess�rio para processar os dados do CSV
        timestamps = csvPositionData.timestamp;
        frames = csvPositionData.frame;
        ax1 = csvPositionData.x1;
        ay1 = csvPositionData.y1;
        ax2 = csvPositionData.x2;
        ay2 = csvPositionData.y2;
        confidence = csvPositionData.confidence;
    else
        if ~exist('csvPositionData', 'var')
            disp('csvPositionData n�o est� presente.');
        elseif isempty(csvPositionData)
            disp('csvPositionData est� presente, mas est� vazio.');
        end
    end

    %define o TAMANHO MINIMO e MAXIMO, em pixeis, de uma �rea para ser considerada
    %um animal
    minpix = 2;
    maxpix = 0; %se o tamanho maximo for zero, fica sendo 50% da imagem

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Informa se queremos trabalhar com a imagem colodira ou em tons de cinza
    %1 - > colorida     0-> tons de cinza
    colorida = subcor;

    %VELOCIDADE MINIMA abaixo da qual consideramos que o animal esta PARADO
    %Valor em cm/s
    vmin = velmin;

    %TEMPO MINIMO, em segundos, para se considerar que um animal ficou PARADO
    tmin = tempmin;

    %TEMPO, em segundos, que o animal tem que ficar PARADO para se considerar que DORMIU
    tminparado = tempminparado;
    
    


    %threshold adaptativo
    global threshadaptativo;

    %variavel global para informar o frame atual para o gui
    global  numframeatual;

    if ~exist('nanimais','var')
        nanimais=1;
    end

    if ~exist('procframe','var')
        procframe=1;
    end

    if exist('thresh','var')
        threshold = thresh;
    else
        threshold = 10;
    end

    if exist('filt','var')
        alpha = filt;
    else
        alpha = 0.6;
    end

    if exist('viddiff','var')
        criavideodiff = viddiff;
    else
        criavideodiff = 0;
    end

    if ~exist('fundodinamico','var')
        fundodinamico = false;
    end

    if ~exist('tipfilt','var')
        tipfilt = 0;
    end

    if ~exist('liveTracking','var')
        liveTracking = 0;
    end

    if ~exist('trackindividuals','var')
        trackindividuals = 0;
    end
    V = zeros(handles.l,handles.c);
    %numero de QUADROS por SEGUNDO do video
    if liveTracking
        fps = 1;
        tipsubfundo=0;
        V = handles.V;
    else
        fps = handles.frameRate;
    end

    global abort
    if isempty(abort)
        abort = 0;
    end

    global pausar
    if isempty(pausar)
        pausar = 0;
    end

    global dicax
    if isempty(dicax)
        dicax = -1;
    end
    global dicay
    if isempty(dicay)
        dicay = -1;
    end

    global tecla
    if isempty(tecla)
        tecla = 0;
    end

    global apertada
    if isempty(apertada)
        apertada = 0;
    end

    %for trackmouse
    global pmousex;
    global pmousey;
    pmousex=-1;
    pmousey=-1;

    %ajusta o alpha de acordo com o procframe
    %     if tipfilt == 0
    %         novoalpha = 0;
    %         for i=1:procframe
    %            novoalpha = novoalpha + (-1)^(i-1)*alpha^i*calctermoserie(procframe,i);
    %         end
    %         alpha = novoalpha/procframe;
    %     end
    %

    %carrega a imagem de fundo
    if ~liveTracking
        backg = imread([fotos,'/',handles.filenameSemExtensao,'.jpeg']);
        %carrega varicancia da imagem de fundo (variavel V)
        load([fotos,'/',handles.filenameSemExtensao,'V.mat']);
    else
        backg = imread('./live/live.jpeg');
    end

    [l,c,cor] = size(backg);    %Pegando as dimens�es do meu fundo.

    if colorida || (cor == 1)
        wbackg = double(backg);
    else
        wbackg = double(rgb2gray(backg));
    end

    %vetor com cores
    vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];

    if criavideores
        %aviobj = avifile([fotos,'/result.avi'],'fps',fps*1/procframe);
        aviobj = VideoWriter([fotos,'/',handles.filenameSemExtensao,'result.avi']);
        aviobj.FrameRate = fps*1/procframe;
        open(aviobj);
    end

    %pega o tamanho da tela
    tela = get(0,'ScreenSize');

    %seta o tamanho das figura que irao aparecer
    xifig = min(c,tela(3)/2)+1;
    yifig = max(tela(4)-l-50,1);
    txfig = min(c,tela(3)/2);
    tyfig = min(l,tela(4)-200);

    iptsetpref('ImshowBorder','tight'); %remover bordas
    figvid = figure(5);
    set(figvid,'units','pix');
    set(figvid,'position',[xifig yifig  txfig tyfig]);
    if (~mostraresnatela) || exist('handles','var')
        set(figvid,'Visible', 'off');
    end

    if criavideodiff
        %aviobj2 = avifile([fotos,'/resultdiff.avi'],'fps',fps*1/procframe);
        aviobj2 = VideoWriter([fotos,'/',handles.filenameSemExtensao,'resultdiff.avi']);
        aviobj2.FrameRate = fps*1/procframe;
        open(aviobj2);
        %figvideodiff = figure(6);
        %set(figvideodiff,'units','pix');
        %set(figvideodiff,'position',[1 yifig min(2*c,tela(3)-1) min(l,tela(4)-201)]);
    else
        aviobj2=0;
        figvideodiff=0;
    end


    quadroini = floor(quadroini);
   
    %gera o vetor tempo, iniciando no tempo inicial da rastreio
    t = 1/fps*(quadroini-1:procframe:quadrofim-1);

    %aloca espa�o para px e py para aumentar velocidade
    global px;
    global py;
    px=zeros(nanimais,floor((quadrofim-quadroini)/procframe));
    py=zeros(nanimais,floor((quadrofim-quadroini)/procframe));

    %indica se um animal esta parado no momento
    indparado = zeros(nanimais);
    %indica se um animal esta dormindo no momento
    inddormindo = zeros(nanimais);
    %variaveis que servem pra contar quantas vezes cada animal ficou parado e dormindo
    contparado = zeros(nanimais);
    contdormindo = zeros(nanimais);

    parado={};
    dormindo = {};
    for j=1:nanimais
        parado{j}.ti(1)=0;
        parado{j}.tf(1)=0;
        parado{j}.xi(1)=1;
        parado{j}.yi(1)=1;
        parado{j}.xf(1)=1;
        parado{j}.yf(1)=1;

        dormindo{j}.xi(1) = 1;
        dormindo{j}.yi(1) = 1;
        dormindo{j}.ti(1) = 0;
        dormindo{j}.xf(1) = 1;
        dormindo{j}.yf(1) = 1;
        dormindo{j}.tf(1) = 0;
    end


    tempoareas = {};
    if exist('areas','var')
        nareas = length(areas); %numero de areas passadas pelo usuario
        dentroarea = zeros(nanimais,nareas); %se cada animal esta dentro ou fora de cada area
        contareas = zeros(nanimais,nareas); %numero de vezes que cada animal entrou e saiu de uma area
    else
        nareas = 0;
    end

    indparado_area = zeros(nanimais, nareas);
    contparado_area = zeros(nanimais, nareas);
    parado_area = cell(nanimais, nareas);

    quadros_fora_area_consecutivos = zeros(nanimais, nareas);
    min_quadros_fora_area = 3;
    esta_parado_animal = zeros(nanimais, 1);
    
    %para que todas as areas aparecam na resp, colocar que todos os peixes
    %entraram e sairam no temop zero em cada uma
    for i=1:nanimais
        for j=1:nareas
            tempoareas{i,j}.ti = 0;
            tempoareas{i,j}.tf = 0;
        end
    end

    comportamento = {}; %cria variavel pra nao haver erros
    contcomportamento = 0;
    vetorletras = ['q' 'w' 'e' 'r' 't' 'y' 'u' 'i' 'o' 'p' 'a' 's' 'd' 'f' 'g' 'h' 'j' 'k' 'l'];

    if ~exist('areasexc', 'var')
        areasexc = [];
    end
    nareasexc = length(areasexc);

    distperc = zeros(1,nanimais); %distancia percorrida por cada animal
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % listagem de passagem por areas
    % por mtxslv
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if tipfilt == 1
        % Kalman filter para cada animal
        R = [[5 ,0]',[0,5]']; %erro na medicao em pixels: no maximo 3*sqrt(var) pixels
        H = [[1,0]',[0,1]',[0,0]',[0,0]'];
        Q = 0.1*filt*eye(4); %erro do processo
        dt = fps/procframe; %pixels/time step
        A = [[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]']; %modelo com posicao x e y e velocidade constante dx e dy
        Bu = [0,0,0,0]'; %velocidade constante. se fosse algo caindo seria Bu = [0,0,0,g]' (positivo pq y aumenta pra baixo)
        %na hora da filtragem eu freio o animal para que, caso nao seja detectado por
        %um certo tempo, nao saia da area da figura
        %Bu(3:4) = -.25*v(:,j);
        P = zeros(4,4,nanimais);
        for j=1:nanimais
            P(:,:,j) = 100*eye(4); %incerteza inicial alta
        end
        v = zeros(2,nanimais);
    end

    %calcular a mascara
    mascara = calculamascara(corte,areasexc,wbackg);


    global cont;
    cont = 1;

    Vrm =  V.^.5;
    %garante que todo mundo em Vrm eh no m�nimo 0.5
    Vrm(Vrm<0.5) = 0.5;


    i=quadroini;
    %for i=quadroini:procframe:quadrofim

    centroides = labels;
    cov_matrix = labels_cov;
 
    if liveTracking
        videoLive = videoinput('winvideo');
        triggerconfig(videoLive, 'manual');
        %cria um objeto videoinput, com o adptador e formatos suportados pelo
        %hardware da maquina onde será executado o programa
        src = getselectedsource(videoLive);
        %videoLive.FramesPerTrigger = 300;
        %definição da quantidade de frames capturados para gerar o video que
        %será usado para criação do fundo
        start(videoLive);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %comandos para hadware externo
    if actions.nactions>0
        %fecha todas as abertas atualmente
        if ~isempty(instrfind)
            fclose(instrfind);
        end
        %conecta na porta serial
        serialcom = serial(actions.serialport, 'BaudRate',actions.serialspeed);
        try
            fopen(serialcom);
        catch
            disp('Could not connect to serial device');
        end
    else
        serialcom = [];
    end

    ti=tic;
%     vetor_Ximagem = [];
%     vetor_Yimagem = [];
%     vetor_Xcores = [];
%     vetor_Ycores = [];
%     indice_atual_medias = 1;
    
    while i <= quadrofim
        

    % Vari�vel global para informar o frame atual para o GUI
    numframeatual = i;

    % Obter o frame atual
    if liveTracking
        frame = getsnapshot(videoLive);
        t(cont) = toc(ti);
    else
        frame = read(video, floor(i));
        
        
    end

    % Converter para tons de cinza e double para trabalhar
    if colorida || (cor == 1)
        wframe = double(frame);
    else
        wframe = double(rgb2gray(frame));
    end

    % Verificar se csvPositionData est� dispon�vel
    if isfield(handles, 'csvPositionData')
        csvData = handles.csvPositionData;
        
        % Encontrar o �ndice do frame mais pr�ximo
        [~, idx] = min(abs(csvData.frame - i));
        
    
        % Pegar a linha de csvData que cont�m o valor de frame mais pr�ximo
        linhaProxima = csvData(idx, :);
    
        % Pega as coordenadas da bounding box do frame mais pr�ximo
        ax1 = linhaProxima.x1;
        ay1 = linhaProxima.y1;
        ax2 = linhaProxima.x2;
        ay2 = linhaProxima.y2;

        % Chamar extractnblobs com as coordenadas da bounding box
        [cx, cy, radius, boundingbox, ndetect, aviobj2, imdif] = extractnblobs(wframe, wbackg, Vrm, nanimais, mascara, minpix, maxpix, threshold, aviobj2, criavideodiff, tipsubfundo, ax1, ay1, ax2, ay2);
    else
        % Chamar extractnblobs sem as coordenadas da bounding box
        
        [cx, cy, radius, boundingbox, ndetect, aviobj2, imdif] = extractnblobs(wframe, wbackg, Vrm, nanimais, mascara, minpix, maxpix, threshold, aviobj2, criavideodiff, tipsubfundo);
    end

        if threshadaptativo
            if ndetect < nanimais && threshold > 2 %ficara no minimo com 2
                threshold = threshold - 1;
                if ndetect == 1 %evita achar um blob gigante que ocupa mais da metade da imagem
                    if radius(1)^2*pi < l*c/2
                        threshold = threshold + 5;
                    end
                end
            elseif ndetect > nanimais && threshold < 50
                threshold = threshold + 1;
            end
            %mostra na barra de trheshold no ambiente grafico
            set(handles.slider3,'Value',threshold);
            set(handles.threshold,'String',num2str(threshold));

        else
            %pega o valor em tempo real
            threshold = round(get(handles.slider3,'Value'));
        end


        %vetor que ir� decorar cada animal que ja foi associado a um blob
        detectado=zeros(1,nanimais);



        if cont >1

            if  tipfilt == 1
                %previsao do filtro de kalman
                for j=1:nanimais
                    pdecorada = [px(j,cont-1); py(j,cont-1)];
                    predita = A*[pdecorada;v(:,j)] + Bu;
                    %garantir que esta dentro da imagem
                    predita(1) = min(max(predita(1),1),c);
                    predita(2) = min(max(predita(2),1),l);
                    px(j,cont-1) = predita(1);
                    py(j,cont-1) = predita(2);
                    v(:,j) = predita(3:4);
                end
            end


            if(trackindividuals)
                %adicionaremos associatefudera depois!
                %{
                vetor_cores_atuais = blob_colours(frame, l, c, ...
                                                  cx, cy, radius, boundingbox, ndetect, imdif, ...
                                                  INTENSO);
                %}
                avg_vector = blob_colours_2(frame, boundingbox, ndetect...
                                                    ,imdif, 0.15,0.5); % avg_vector � o novo vetor_cores_atuais
                %definindo um valor para alpha:
                alpha_distancia = 0;    %20% para a dist�ncia euclidiana e 80% para a dist�ncia no espa�o de cores.
               
                
                %{
                [px(:,cont),py(:,cont),detectado,caixa] = associatefudera(nanimais, ndetect, px(:,cont-1), py(:,cont-1), cx, cy, radius,...
                                                                          boundingbox, detectado, dicax, dicay, caixa, l, c, frame, ...
                                                                          vetor_cores_atuais, media, variancia, ...
                                                                          alpha_distancia);
                %}                                                      
                %centroides = [72.8047 22.3412 30.9006; 23.3055 25.0995 57.2719]% definir na m�o antes de rodar o c�digo                                                      
                [px(:,cont),py(:,cont),detectado,caixa] =  associacao_soma_matrizes(nanimais, ndetect,avg_vector,centroides,cx,cy, px(:,cont-1), py(:,cont-1),l,c,detectado,caixa, boundingbox);                                                      
%                     vetor_Ximagem(indice_atual_medias) = Ximagem;
%                     vetor_Yimagem(indice_atual_medias) = Yimagem;
%                     vetor_Xcores(indice_atual_medias) = Xcores;
%                     vetor_Ycores(indice_atual_medias) = Ycores;
%                     indice_atual_medias = indice_atual_medias + 1;
            else
                [px(:,cont) ,py(:,cont), detectado, caixa] = associateeuclid(nanimais, ndetect, px(:,cont-1), py(:,cont-1), cx, cy, radius, ...
                                                                             boundingbox, detectado, dicax, dicay, ...
                                                                             caixa, l, c, frame);
            end

            %zera as dicas
            dicax = -1;
            dicay = -1;

            %salva as imagens e mascaras dos peixes achados
            %              for j=1:nanimais
            %                     xi = round(max(1,caixa(j,1) - 3));
            %                     yi = round(max(1,caixa(j,2) - 3));
            %                     xf = round(min(caixa(j,1) + caixa(j,3) + 3,c));
            %                     yf = round(min(caixa(j,2) + caixa(j,4) + 3,l));
            %                     imwrite(frame(yi:yf,xi:xf,:),fullfile(handles.directoryname,['a' num2str(j) 'f' num2str(cont) '.png']));
            %                     imwrite(uint8(255*imdif(yi:yf,xi:xf,:)),fullfile(handles.directoryname,['a' num2str(j) 'm' num2str(cont) '.png']));
            %              end



            %filtragem das posicoes
            for k=1:nanimais
                if tipfilt == 0
                    %m�dia m�vel
                    px(k,cont)=alpha*px(k,cont) + (1-alpha)*px(k,cont-1);
                    py(k,cont)=alpha*py(k,cont) + (1-alpha)*py(k,cont-1);
                end
                if tipfilt == 1
                    %kalman
                    PP(:,:,j) = A*P(:,:,j)*A' + Q;
                    K = PP(:,:,j)*H'*inv(H*PP(:,:,j)*H'+R);
                    filtrada = (predita + K*([px(j,cont),py(j,cont)]' - H*predita))'; %erro [cc(i),cr(i)]' - H*xp
                    P(:,:,j) = (eye(4)-K*H)*PP(:,:,j);
                    px(j,cont) = filtrada(1);
                    py(j,cont) = filtrada(2);
                    v(:,j) = filtrada(3:4);
                    %devolve valores da posicao passada, que antes estavam
                    %com as posicoes previstas
                    px(j,cont-1) = pdecorada(1);
                    py(j,cont-1) = pdecorada(2);
                    %freia o animal para que, caso nao seja detectado por
                    %um certo tempo, nao saia da area da figura
                    Bu(3:4) = -.25*v(:,j);
                end
            end


            if apertada
                areaescolhida = str2num(tecla);
                if ~ isnan(areaescolhida)
                    if areaescolhida<=nareas %nao foi letra nem um numero de areas que nao existe
                        %centro de massa
                        tx = mean(areas(areaescolhida).x);
                        ty = mean(areas(areaescolhida).y);
                        if ~inpolygon(tx,ty,areas(areaescolhida).x,areas(areaescolhida).y) %se nao estiver dentro, pega na borda
                            tx = mean(areas(areaescolhida).x(1:2));
                            ty = mean(areas(areaescolhida).y(1:2));
                        end

                        px(1,cont) = tx;
                        py(1,cont) = ty;
                    end
                else
                    %procura qual letra foi
                    for indletra = 1:length(vetorletras)
                        if tecla == vetorletras(indletra)
                            %testa se � diferente do comportamento atual
                            if comportamento.tipo(contcomportamento) ~= indletra %novo comportamento
                                %fecha comportamento atual
                                comportamento.tf(contcomportamento) = t(cont-1);
                                comportamento.xf(:,contcomportamento) = px(:,cont-1)/pixelcm.x;
                                comportamento.yf(:,contcomportamento) =(l-py(:,cont-1))/pixelcm.y;
                                %abre novo comportamento
                                contcomportamento = contcomportamento + 1;
                                comportamento.tipo(contcomportamento) = indletra;
                                comportamento.ti(contcomportamento) = t(cont-1);
                                comportamento.xi(:,contcomportamento) = px(:,cont-1)/pixelcm.x;
                                comportamento.yi(:,contcomportamento) =(l-py(:,cont-1))/pixelcm.y;
                            end

                        end
                    end
                end
            end

            if trackmouse && pmousex~=-1 && pmousey~=-1
                px(1,cont) = pmousex;
                py(1,cont) = pmousey;
            end

            %ajeita as caixas para as posicoes filtradas
            for j=1:nanimais
                caixa(j,1:4) = [px(j,cont)-round(caixa(j,3)/2) py(j,cont)-round(caixa(j,4)/2) caixa(j,3) caixa(j,4)];
            end


        else %primeira iteracao
            %se tiver recebido a posicao inicial dos animais, simplesmente
            %atribui elas
            if ~exist('pinicial','var') 
                if length(pinicial.x)==nanimais
                    px(:,cont)=pinicial.x;
                    py(:,cont)=pinicial.y;
                    for j=1:nanimais
                        detectado(j)=1;
                        caixa(j,1:4) = [px(j,cont)-10 py(j,cont)-10 20 20];
                    end
                else
                    %escolhe os animais na ordem em que foram ordenados os blobs
                    for j=1:min(ndetect,nanimais)
                        px(j,cont)=round(cx(j));
                        py(j,cont)=round(cy(j));
                        %marca que tal animal foi detectado nesta iteracao
                        detectado(j)=1;
                        caixa(j,1:4) = boundingbox(j,:);
                    end
                    %procura animais nao detectados na primeira iteracao
                    for j=ndetect+1:nanimais
                        %bota o animal pra iniciar nomeio da imagem
                        px(j,cont)=round(c/2);
                        py(j,cont)=round(l/2);
                        detectado(j)=1;
                        caixa(j,1:4) = [px(j,cont)-10 py(j,cont)-10 20 20];
                    end
                end
            else
                %escolhe os animais na ordem em que foram ordenados os blobs
                for j=1:min(ndetect,nanimais)
                    px(j,cont)=round(cx(j));
                    py(j,cont)=round(cy(j));
                    %marca que tal animal foi detectado nesta iteracao
                    detectado(j)=1;
                    caixa(j,1:4) = boundingbox(j,:);
                end
                %procura animais nao detectados na primeira iteracao
                for j=ndetect+1:nanimais
                    %bota o animal pra iniciar nomeio da imagem
                    px(j,cont)=round(c/2);
                    py(j,cont)=round(l/2);
                    detectado(j)=1;
                    caixa(j,1:4) = [px(j,cont)-10 py(j,cont)-10 20 20];
                end
            end
            comportamento.tipo(1) = 1; %inicia no comportamento numero 1
            comportamento.ti(1) = t(cont);
            comportamento.xi(:,1) = px(:,cont)/pixelcm.x; %posicoes dos animais
            comportamento.yi(:,1) =(l-py(:,cont))/pixelcm.y;
            contcomportamento = 1;
        end




        for j=1:nanimais
            %determina se o animal esta parado
            if cont >1 %&& detectado(j) %se o animal foi detectado
                vp = sqrt(((px(j,cont)  - px(j,cont-1))/pixelcm.x)^2 + ((py(j,cont) - py(j,cont-1))/pixelcm.y)^2)*fps/procframe;
                if vp < vmin  %velocida menor que a minima
                    pa = 1;
                    esta_parado_animal(j)=1;
                else
                    pa = 0;
                    esta_parado_animal(j)=0;
                end
            else
                pa=0;
            end

            %se nao estava parado e agora parou
            if(~indparado(j) && pa)
                contparado(j) = contparado(j)+1;
                indparado(j) = 1;
                parado{j}.ti(contparado(j)) = t(cont);
                parado{j}.xi(contparado(j)) = px(j,cont)/pixelcm.x;
                parado{j}.yi(contparado(j)) = (l-py(j,cont))/pixelcm.y;
            end

            %teste se j� esta mai de tminparado segundos parado, pra mudar
            %a cor do plot
            if indparado(j)
                if t(cont) - parado{j}.ti(contparado(j)) > tminparado
                    inddormindo(j)=1;
                end
            end

            %se estava parado e agora comecou a mexer
            if(indparado(j) && ~pa)
                indparado(j)=0;
                inddormindo(j)=0;
                parado{j}.tf(contparado(j)) = t(cont);
                parado{j}.xf(contparado(j)) = px(j,cont)/pixelcm.x;
                parado{j}.yf(contparado(j)) = (l-py(j,cont))/pixelcm.y;
                %se o animal ficou parado menos tempo que tempmin, eh
                %desconsiderado
                if parado{j}.tf(contparado(j)) - parado{j}.ti(contparado(j)) < tmin

                    if contparado(j) == 1
                        parado{j}.ti(1)=0;
                        parado{j}.tf(1)=0;
                        parado{j}.xi(1)=1;
                        parado{j}.yi(1)=1;
                        parado{j}.xf(1)=1;
                        parado{j}.yf(1)=1;
                    else
                        parado{j}.ti(contparado(j)) = [];
                        parado{j}.xi(contparado(j)) = [];
                        parado{j}.yi(contparado(j)) = [];
                        parado{j}.tf(contparado(j)) = [];
                        parado{j}.xf(contparado(j)) = [];
                        parado{j}.yf(contparado(j)) = [];
                    end
                    contparado(j)=contparado(j)-1;
                else

                    %testa se ficou tempo suficiente parado pra se considerar
                    %que o animal dormiu
                    if parado{j}.tf(contparado(j)) - parado{j}.ti(contparado(j)) >= tminparado
                        %copia para e estrutura parado para a estrutura
                        %dormindo
                        contdormindo(j) = contdormindo(j) + 1;
                        dormindo{j}.xi(contdormindo(j)) = parado{j}.xi(contparado(j));
                        dormindo{j}.yi(contdormindo(j)) = parado{j}.yi(contparado(j));
                        dormindo{j}.ti(contdormindo(j)) = parado{j}.ti(contparado(j));
                        dormindo{j}.xf(contdormindo(j)) = parado{j}.xf(contparado(j));
                        dormindo{j}.yf(contdormindo(j)) = parado{j}.yf(contparado(j));
                        dormindo{j}.tf(contdormindo(j)) = parado{j}.tf(contparado(j));
                    end
                end
            end
        end

        % Testa se animal está dentro da área
        alguemdentro = zeros(1, nareas); % Inicializa para o quadro atual 'cont'

        for k = 1:nareas % Loop para cada área de interesse
            for j = 1:nanimais % Loop para cada animal

                % 1. Determinar se o animal tem ALGUM VÉRTICE DENTRO da área k NESTE QUADRO (overlap instantâneo)
                box = caixa(j, :); % Formato [x, y, width, height] do canto superior esquerdo
                vx = [box(1), box(1) + box(3), box(1) + box(3), box(1)]; % Coordenadas x dos 4 vértices
                vy = [box(2), box(2), box(2) + box(4), box(2) + box(4)]; % Coordenadas y dos 4 vértices
        
                is_currently_overlapping_area = any(inpolygon(vx, vy, areas(k).x, areas(k).y));

                % 2. Chamada da função 'factions' e atualização de 'alguemdentro' (baseado no overlap instantâneo)
                % Esta parte mantém a lógica original de 'factions' e 'alguemdentro'
                if is_currently_overlapping_area
                    alguemdentro(k) = 1; % Marca que há pelo menos um animal na área k neste quadro
                    factions(3, k, j, actions, serialcom); % Código 3: animal (j) tem overlap com área (k)
                else
                    factions(4, k, j, actions, serialcom); % Código 4: animal (j) NÃO tem overlap com área (k)
                end

                % 3. Atualizar estado 'dentroarea(j,k)' (ENTRADA/SAÍDA CONFIRMADA da área com filtro de fluttering)
                %    e registrar tempos em 'tempoareas'
        
                if is_currently_overlapping_area
                    % Animal está sobrepondo a área neste quadro
                    quadros_fora_area_consecutivos(j,k) = 0; % Reseta o contador de quadros fora
            
                    if ~dentroarea(j,k) % Se NÃO estava 'confirmado dentro' da área k antes
                        % É uma nova ENTRADA CONFIRMADA na área k
                        dentroarea(j,k) = 1;
                        contareas(j,k) = contareas(j,k) + 1;
                        idx_ca = contareas(j,k);
                        tempoareas{j,k}.ti(idx_ca) = t(cont);
                        % Assegurar que não há um 'tf' perdido para esta nova entrada
                        if length(tempoareas{j,k}.tf) >= idx_ca
                            tempoareas{j,k}.tf(idx_ca) = NaN; 
                        else
                            % Se o vetor tf for menor, preencher com NaNs até o índice atual
                            % Isso pode acontecer se os vetores foram esvaziados e re-preenchidos
                            tempoareas{j,k}.tf = [tempoareas{j,k}.tf, nan(1, idx_ca - length(tempoareas{j,k}.tf))];
                        end
                    end
                else
                    % Animal NÃO está sobrepondo a área neste quadro
                    if dentroarea(j,k) % Se ESTAVA 'confirmado dentro' da área k antes
                        quadros_fora_area_consecutivos(j,k) = quadros_fora_area_consecutivos(j,k) + 1;
                        if quadros_fora_area_consecutivos(j,k) >= min_quadros_fora_area
                            % É uma nova SAÍDA CONFIRMADA da área k
                            dentroarea(j,k) = 0;
                            idx_ca = contareas(j,k);
                            if idx_ca > 0 % Só registra 'tf' se houve uma entrada correspondente
                                % Verifica se o ti existe para este índice antes de registrar o tf
                                if length(tempoareas{j,k}.ti) >= idx_ca && ~isnan(tempoareas{j,k}.ti(idx_ca))
                                    tempoareas{j,k}.tf(idx_ca) = t(cont);
                                end
                            end
                        end
                    end
                end

                % 4. Lógica de TEMPO PARADO DENTRO DA ÁREA ('parado_area')
                % Baseada no estado 'esta_parado_animal(j)' (parado individual) e 'dentroarea(j,k)' (confirmado dentro/fora da área)

                % CONDIÇÃO PARA INICIAR uma nova contagem de tempo parado na área:
                if esta_parado_animal(j) && dentroarea(j,k) && ~indparado_area(j,k)
                    % Animal está parado (esta_parado_animal(j)==1), E está confirmado dentro da área (dentroarea==1), 
                    % E não estava já registrado como parado NA ÁREA (~indparado_area==0)
                    indparado_area(j,k) = 1; % Marca que o animal j está agora parado na área k
                    contparado_area(j,k) = contparado_area(j,k) + 1;
                    idx_cpa = contparado_area(j,k);
                    if isempty(parado_area{j,k}) || ~isfield(parado_area{j,k}, 'tf')
                    parado_area{j,k}.ti = [];
                    parado_area{j,k}.tf = [];
                    parado_area{j,k}.xi = [];
                    parado_area{j,k}.yi = [];
                    parado_area{j,k}.xf = [];
                    parado_area{j,k}.yf = [];
                    end
                    parado_area{j,k}.ti(idx_cpa) = t(cont);
                    parado_area{j,k}.xi(idx_cpa) = px(j,cont)/pixelcm.x;
                    parado_area{j,k}.yi(idx_cpa) = (l - py(j,cont))/pixelcm.y;
                    
                    % Inicializar tf, xf, yf como NaN para esta nova parada em curso
                    % Assegurar que os vetores têm tamanho suficiente
                    if length(parado_area{j,k}.tf) < idx_cpa
                        parado_area{j,k}.tf = [parado_area{j,k}.tf, nan(1, idx_cpa - length(parado_area{j,k}.tf))];
                        parado_area{j,k}.xf = [parado_area{j,k}.xf, nan(1, idx_cpa - length(parado_area{j,k}.xf))];
                        parado_area{j,k}.yf = [parado_area{j,k}.yf, nan(1, idx_cpa - length(parado_area{j,k}.yf))];
                    end
                    parado_area{j,k}.tf(idx_cpa) = NaN;
                    parado_area{j,k}.xf(idx_cpa) = NaN;
                    parado_area{j,k}.yf(idx_cpa) = NaN;
                end

                % CONDIÇÃO PARA TERMINAR a contagem de tempo parado na área atual:
                if indparado_area(j,k) && (~esta_parado_animal(j) || ~dentroarea(j,k))
                    % Estava registrado como parado na área (indparado_area==1), 
                    % E (animal começou a se mover (esta_parado_animal(j)==0) OU foi confirmado fora da área (dentroarea==0))
            
                    indparado_area(j,k) = 0; % Não está mais classificado como parado DENTRO desta área específica
                    idx_cpa = contparado_area(j,k);

                    if idx_cpa > 0 % Só processa se houver uma parada registrada para finalizar
                        % Verifica se o ti foi realmente registrado e se tf ainda não foi (é NaN)
                        if length(parado_area{j,k}.ti) >= idx_cpa && ~isnan(parado_area{j,k}.ti(idx_cpa)) && ...
                        (length(parado_area{j,k}.tf) < idx_cpa || isnan(parado_area{j,k}.tf(idx_cpa)))
                    
                            parado_area{j,k}.tf(idx_cpa) = t(cont);
                            parado_area{j,k}.xf(idx_cpa) = px(j,cont)/pixelcm.x;
                            parado_area{j,k}.yf(idx_cpa) = (l - py(j,cont))/pixelcm.y;

                            % Se o tempo parado dentro da área foi menor que tmin, descarta a parada
                            duracao_parada_area = parado_area{j,k}.tf(idx_cpa) - parado_area{j,k}.ti(idx_cpa);
                            if duracao_parada_area < tmin
                                % Remove os dados da última parada na área (a que acabou de ser registrada)
                                % Esta é a forma mais segura de remover o último elemento se idx_cpa é o contador atual
                                if idx_cpa == 1 % Se é a única entrada
                                    parado_area{j,k}.ti = []; parado_area{j,k}.xi = []; parado_area{j,k}.yi = [];
                                    parado_area{j,k}.tf = []; parado_area{j,k}.xf = []; parado_area{j,k}.yf = [];
                                else % Se há mais de uma entrada, remove a última
                                    parado_area{j,k}.ti(idx_cpa) = []; parado_area{j,k}.xi(idx_cpa) = []; parado_area{j,k}.yi(idx_cpa) = [];
                                    parado_area{j,k}.tf(idx_cpa) = []; parado_area{j,k}.xf(idx_cpa) = []; parado_area{j,k}.yf(idx_cpa) = [];
                                end
                                contparado_area(j,k) = contparado_area(j,k) - 1;
                                if contparado_area(j,k) < 0; contparado_area(j,k) = 0; end % Segurança
                            end
                        end
                    end
                end
            end % Fim do loop j (animais)
        end % Fim do loop k (áreas)


        %para acelerar o funcionamento, so mostra na tela de tempos em
        %tempos
        if rem(cont,round(get(handles.slider11,'Value'))) == 0

            if criavideores

                set(0,'CurrentFigure',figvid); %seta com atual sem mostrar

                %desenha as localizacoes dos animais
                hold off
                imshow(frame);
                hold on

                for j=1:nanimais
                    xi = max(1,caixa(j,1) - 3);
                    yi = max(1,caixa(j,2) - 3);
                    xf = min(caixa(j,1) + caixa(j,3) + 3,c);
                    yf = min(caixa(j,2) + caixa(j,4) + 3,l);
                    if indparado(j) && ~inddormindo(j)
                        numer = (t(cont) - parado{j}.ti(contparado(j)));
                        denom = tmin;
                        line([xi xf xf xi xi],[yi yi yf yf yi],'Color',max((1 - numer/denom),0)*vcores(mod(j,7)+1,:));
                    else
                        if inddormindo(j)
                            line([xi xf xf xi xi],[yi yi yf yf yi],'Color',[1 0.6 0]);
                        else
                            line([xi xf xf xi xi],[yi yi yf yf yi],'Color',vcores(mod(j,7)+1,:));
                        end
                    end
                    text(xi+2,yi+7,num2str(j),'FontSize',11,'Color',vcores(mod(j,7)+1,:));
                end

                for k=1:nareas
                    %desenha as areas mudando a cor se tiver alguem dentro
                    if(alguemdentro(k)==1)
                        desenha_areas(areas(k),'','w',k);
                    else
                        desenha_areas(areas(k),'','b',k);
                    end
                end

                %warning ('off','all');
                %frameavi = im2frame(zbuffer_cdata(figvid)); %pega e o frame fica invisivel. em breve nao sera mais suportado
                %warning ('on','all');

                frameavi = print(figvid,'-RGBImage'); %jeito novo (2015a) (mais lento)

                %adiciona o frame ao video
                writeVideo(aviobj,frameavi);

            end

            %plota no GUI
            if exist('handles','var') && mostraresnatela
                set(0,'CurrentFigure',handles.figure1);
                set(handles.figure1,'CurrentAxes',handles.axes4);
                hold off
                imhandle = imshow(frame);
                set(imhandle,'ButtonDownFcn',@clickfigura );
                hold on

                for j=1:nanimais
                    xi = max(1,caixa(j,1) - 3);
                    yi = max(1,caixa(j,2) - 3);
                    xf = min(caixa(j,1) + caixa(j,3) + 3,c);
                    yf = min(caixa(j,2) + caixa(j,4) + 3,l);
                    if indparado(j) && ~inddormindo(j)
                        numer = (t(cont) - parado{j}.ti(contparado(j)));
                        denom = tmin;
                        phandle = line([xi xf xf xi xi],[yi yi yf yf yi],'Color',max((1 - numer/denom),0)*vcores(mod(j,7)+1,:));
                        set(phandle,'ButtonDownFcn',@clickfigura );
                    else
                        if inddormindo(j)
                            phandle = line([xi xf xf xi xi],[yi yi yf yf yi],'Color',[1 0.6 0]);
                            set(phandle,'ButtonDownFcn',@clickfigura );
                        else
                            phandle = line([xi xf xf xi xi],[yi yi yf yf yi],'Color',vcores(mod(j,7)+1,:));
                            set(phandle,'ButtonDownFcn',@clickfigura );
                        end
                    end
                    thandle = text(xi+2,yi+7,num2str(j),'FontSize',11,'Color',vcores(mod(j,7)+1,:));
                    set(thandle,'ButtonDownFcn',@clickfigura );
                end
                %areas de interesse
                for k=1:nareas
                    %desenha as areas mudando a cor se tiver alguem dentro
                    if(alguemdentro(k)==1)
                        desenha_areas(areas(k),@clickfigura,'w',k);
                    else
                        desenha_areas(areas(k),@clickfigura,'b',k);
                    end

                end
                %areas de exclusao
                desenha_areas(areasexc,@clickfigura,'r',-1);


                %plota rastro (os ultimos pontos onde o peixe foi
                %detectado)
                global nulitimospontos;
                if(nulitimospontos ~= 0)
                    plot(px(1,max(cont-nulitimospontos,1):cont),py(1,max(cont-nulitimospontos,1):cont),'o');
                    plot(px(1,max(cont-nulitimospontos,1):cont),py(1,max(cont-nulitimospontos,1):cont));
                end

                %                 if criavideores
                %                     frameavi = getframe(handles.axes4);
                %                     %adiciona o frame ao video
                %                     writeVideo(aviobj,frameavi);
                %                 end

            end

            if ~liveTracking
                set(handles.tamin,'String',num2str(floor((numframeatual)/(handles.frameRate*60))));
                set(handles.taseg,'String',num2str(floor((numframeatual)/(handles.frameRate) - 60*floor((numframeatual)/(handles.frameRate*60)))));
            end

            if cameralenta>0
                pause(cameralenta)
            end

        end

        %estima tempo que ainda falta para terminar
        if mod(cont,10) == 5
            tf=toc(ti);
            tgasto=tf/60; %em minutos
            if liveTracking
                set(handles.tgasto,'String',num2str(tgasto,2));
            else
                tmedio=tf/(cont*60);
                trestante=tmedio*((quadrofim-quadroini)/procframe-cont);
                %mostra no gui
                if exist('handles','var')
                    set(handles.trest,'String',num2str(trestante,2));
                    set(handles.tgasto,'String',num2str(tgasto,2));
                    handles.waibar.setvalue(tgasto/(trestante+tgasto));
                else
                    disp(['Tempo gasto: ' num2str(tgasto) ' minutos. Tempo restante: ' num2str(trestante) ' minutos'])
                end
            end

        end
        drawnow
        %calculo do fundo dinamico
        if fundodinamico
            filtrofundo1 = 0.99;
            filtrofundo2 = 0.95;

            %atualiza o fundo nas regioes em que nao tem animais detectados
            for j=1:nanimais
                xi = max(1,round(caixa(j,1) - 10));
                yi = max(1,round(caixa(j,2) - 10));
                xf = min(round(caixa(j,1) + caixa(j,3) + 10),c);
                yf = min(round(caixa(j,2) + caixa(j,4) + 10),l);
                %figure(7)
                %imshow(uint8(wframe(yi:yf,xi:xf)))
                wframe(yi:yf,xi:xf) = filtrofundo2*wbackg(yi:yf,xi:xf) + (1-filtrofundo2)*wframe(yi:yf,xi:xf);
            end
            %atualiza variancia de acordo com a formula em http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
            %vamos supor sempre que estamos adicionando o 100 frame ao conjutno
            if ~colorida 
                medianova = wbackg + (wframe - wbackg)/100;
                V(:,:,4) = (99*V(:,:,4) + (wframe - wbackg).*(wframe - medianova))/100;
            end
            %calcula novo fundo
            wbackg = filtrofundo1*wbackg + (1-filtrofundo1)*wframe;
            Vrm =  V.^.5;

        end

        while pausar
            pause(0.2)
        end

        cont = cont+1;

        if abort
            px = px(:,1:cont-1);
            py = py(:,1:cont-1);
            t = t(1:cont-1);
            break;
        end

        i = i + procframe;  

        if liveTracking
            quadrofim=i+1;
        end
     end
     
%      figure ('Name','Gr�fico da m�dia de dist�ncias euclidianas e cores')
%      plot (vetor_Ximagem,vetor_Yimagem,'k*',vetor_Xcores,vetor_Ycores,'r*')
%      legend ('Euclidiana', 'Cores')
%      figure ('Name','Gr�fico da m�dia de dist�ncias euclidianas')
%      plot (vetor_Ximagem,vetor_Yimagem,'k*')
%      legend ('Euclidiana')
%      figure ('Name','Gr�fico da m�dia de dist�ncias de cores')
%      plot (vetor_Xcores,vetor_Ycores,'r*')
%      legend ('Cores')
     
    if liveTracking
        delete(videoLive);
    end
     if actions.nactions>0
        fclose(serialcom);
     end

    %verifica se tinha gente parado que ficou parado at� o final do
    %rastreamento
    for j=1:nanimais
        %se terminou o rastreamento e continua parado
        if(indparado(j))
            indparado(j)=0;
            parado{j}.tf(contparado(j)) = t(cont-1);
            parado{j}.xf(contparado(j)) = px(j,cont-1);
            parado{j}.yf(contparado(j)) = py(j,cont-1);
            %se o animal ficou parado menos tempo que tempmin, eh
            %desconsiderado
            if parado{j}.tf(contparado(j)) - parado{j}.ti(contparado(j)) < tmin
                if contparado(j) == 1
                    parado{j}.ti(1)=0;
                    parado{j}.tf(1)=0;
                    parado{j}.xi(1)=1;
                    parado{j}.yi(1)=1;
                    parado{j}.xf(1)=1;
                    parado{j}.yf(1)=1;
                else
                    parado{j}.ti(contparado(j)) = [];
                    parado{j}.xi(contparado(j)) = [];
                    parado{j}.yi(contparado(j)) = [];
                    parado{j}.tf(contparado(j)) = [];
                    parado{j}.xf(contparado(j)) = [];
                    parado{j}.yf(contparado(j)) = [];
                    contparado(j)=contparado(j)-1;
                end
            else
                %testa se ficou tempo suficiente parado pra se considerar
                %que o animal dormiu
                if parado{j}.tf(contparado(j)) - parado{j}.ti(contparado(j)) < tminparado
                    %copia para e estrutura parado para a estrutura
                    %dormindo
                    contdormindo(j) = contdormindo(j) + 1;
                    dormindo{j}.xi(contdormindo(j)) = parado{j}.xi(contparado(j));
                    dormindo{j}.yi(contdormindo(j)) = parado{j}.yi(contparado(j));
                    dormindo{j}.ti(contdormindo(j)) = parado{j}.ti(contparado(j));
                    dormindo{j}.xf(contdormindo(j)) = parado{j}.xf(contparado(j));
                    dormindo{j}.yf(contdormindo(j)) = parado{j}.yf(contparado(j));
                    dormindo{j}.tf(contdormindo(j)) = parado{j}.tf(contparado(j));
                end
            end
        end
    end

    %acabou o rastreamento e devemos botar o tempo que saiu da area
    for k=1:nareas
        for j=1:nanimais
            %se estava dentro e acabou o rastreamento
            if dentroarea(j,k)
                dentroarea(j,k) = 0;
                tempoareas{j,k}.tf(contareas(j,k)) = t(cont-1);
            end
        end
    end

    %fecha o ultimo comportamento
    comportamento.tf(contcomportamento) = t(cont-1);
    comportamento.xf(:,contcomportamento) = px(:,cont-1)/pixelcm.x;
    comportamento.yf(:,contcomportamento) =(l-py(:,cont-1))/pixelcm.y;

    if criavideores
        close(aviobj);
    end

    if criavideodiff
        close(aviobj2);
    end

    if (~mostraresnatela) || exist('handles','var')
        set(0,'CurrentFigure',figvid); %seta com atual sem mostrar
    else
        figure(figvid);  %mostra na tela
    end

    hold off
    imshow(backg)
    hold on
    if ~exist('handles','var')
        set(figvid,'Visible', 'on')
    end

    %desenha as areas e salva
    desenha_areas(areas,'','b',1);

    saveas(figvid,[fotos,'/',handles.filenameSemExtensao,'areas.jpg']);

    if (~mostraresnatela) || exist('handles','var')
        set(0,'CurrentFigure',figvid); %seta com atual sem mostrar
    else
        figure(figvid);  %mostra na tela
    end

    %salva as trajetorias todas juntas
    hold off
    imshow(backg)
    hold on
    if ~exist('handles','var')
        set(figvid,'Visible', 'on')
    end

    for j=1:nanimais
        plot(px(j,:),py(j,:),'Color',vcores(mod(j,7)+1,:));
    end

    saveas(figvid,[fotos,'/',handles.filenameSemExtensao,'result.jpg']);

    %salva as trajetorias de cada animal
    if nanimais>1
        for j=1:nanimais
            hold off
            imshow(backg)
            hold on
            if ~exist('handles','var')
                set(figvid,'Visible', 'on')
            end
            plot(px(j,:),py(j,:),'Color',vcores(mod(j,7)+1,:));
            saveas(figvid,[fotos,'/',handles.filenameSemExtensao,'result',num2str(j),'.jpg']);
        end
    end

    if (~mostraresnatela) || exist('handles','var')
        close(figvid);
    end

    %if criavideodiff
    %    close(figvideodiff);
    %end

    if exist('handles','var')
        axes(handles.axes4);
        hold off
        imhandle = imshow(backg);
        set(imhandle,'ButtonDownFcn',handles.pontButtonDown);
        hold on
        for j=1:nanimais
            plot(px(j,:),py(j,:),'Color',vcores(mod(j,7)+1,:));
        end
    end


    %transforma a posicao dos animais de pixel pra cm
    pxcm = px/pixelcm.x;
    pycm = (l-py)/pixelcm.y; %inverte o eixo y

    difft = diff(t);
    for i=1:nanimais
        %calcula o vetor velocidade
        %velocidade{i}.x = diff(pxcm(i,:))*fps/procframe;
        velocidade{i}.x = diff(pxcm(i,:)) ./ difft;
        %velocidade{i}.y = diff(pycm(i,:))*fps/procframe;
        velocidade{i}.y = diff(pycm(i,:)) ./ difft;
        velocidade{i}.total = sqrt(velocidade{i}.x.^2+velocidade{i}.y.^2);
        %calcula a distancia percorrida por cada animal
        %distperc(i) = sum(velocidade{i}.total*procframe/fps);
        distperc(i) = sum(velocidade{i}.total .* difft);
    end

    if exist('handles','var')
        set(handles.trest,'String',num2str(0));
        handles.waibar.setvalue(1);
    end

    %variaveis de retorno
    for i=1:nanimais
        posicao{i}.x = pxcm(i,:);
        posicao{i}.y = pycm(i,:);
    end

end


%calcula os termos da seria da filtragem considerando deslocamentos iguais
%entre espa�os de tempo iguais
function y = calctermoserie(n,i)
    if i == 1
        y = sum(1:n);
    else
        if i>n
            y = 0;
        else
            y = calctermoserie(n-1,i) + calctermoserie(n-1,i-1);
        end
    end
end

function im = desenharect(im, rect, cor,esp)

    if nargin == 3
        esp = 0;
    end

    [l,c,nc] = size(im);

    xi = max(rect(1),1);
    yi = max(rect(2),1);
    xf = min(xi + rect(3),l);
    yf = min(yi + rect(4),c);

    im(xi:xi+esp,yi:yf,1) = cor(1);
    im(xi:xf,yf-esp:yf,1) = cor(1);
    im(xf-esp:xf,yi:yf,1) = cor(1);
    im(xi:xf,yi:yi+esp,1) = cor(1);
    if nc>1
        im(xi:xi+esp,yi:yf,2) = cor(2);
        im(xi:xf,yf-esp:yf,2) = cor(2);
        im(xf-esp:xf,yi:yf,2) = cor(2);
        im(xi:xf,yi:yi+esp,2) = cor(2);
        im(xi:xi+esp,yi:yf,3) = cor(3);
        im(xi:xf,yf-esp:yf,3) = cor(3);
        im(xf-esp:xf,yi:yf,3) = cor(3);
        im(xi:xf,yi:yi+esp,3) = cor(3);
    end
end


function clickfigura(hObject, eventdata, handles)

    handles = guidata(hObject);

    axesHandle  = get(hObject,'Parent');
    pos=get(axesHandle,'CurrentPoint');
    pos = pos(1,1:2);

    global pausar

    if pausar == 0 %nao esta pausado, portanto eh dica
        %garante que o ponto esta dentro da imagem
        global dicax
        global dicay
        dicax = min(pos(1),handles.c);
        dicay= min(pos(2),handles.l);
        %else %esta pausado, portanto eh pra ajeitar posicoes antigas
        %    display('ajeitar posicao antiga')
    end
end