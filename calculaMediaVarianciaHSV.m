%A ideia � que o usu�rio defina um intervalo em (tempo_inicial - tempo_final)
%de qualquer extens�o de forma que o mesmo possibilite gerar uma biblioteca
%de pontos resultante de m�ltiplos SURFS em m�ltiplos frames e uma m�dia e
%vari�ncia correspondente a cada peixe

%OBS:
%tol = threshrold na track.m, que serve para a subtra��o de fundo;
%Imback = wbackg do track.m;
%criavideo = criavideodiff do track.m;
%avi = aviobj2 do track.m (o input e n�o o output nessa fun��o!);
%wframe = working frame (double e em greyscale);
%frames_video(i) = frame do track.m;
%INTENSO = intervalo que dita o valor do V de HSV, ou seja, dita o limite para que as cores sejam mais 'intensas';
%V = Vrm do track.m;


%media e variancia s�o dois vetores, j� que posso ter mais de 1 peixe.
function [media, variancia] = calculaMediaVarianciaHSV(video, tempo_inicial, tempo_final ...
                                                       , Imback, V, nanimais, mascara, minpix, maxpix, tol, avi, criavideo, tipsubfundo ...
                                                       , caixa, l, c ...
                                                       , colorida, cor, tipfilt ...
                                                       , INTENSO)
    
    %vari�veis que preciso para o funcionamento do c�digo mas que n�o faz
    %sentido passar como par�metros.
    dicax = -1;
    dicay = -1;
    
    pxant=zeros(1,nanimais);
    pyant=zeros(1,nanimais);
    
    [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video); %aqui obtenho os �ndices final e inicial para a calibra��o.
    
    frames_video = read(video, [frame_inicial, frame_final]);                                %cria um vetor com todos os frames entre frame_incial e frame_final.
                                                                                             %Lembrando que para acessar o i-�simo frame, uso a nota��o frames_video(:,:,:,i);
    
    %vari�veis de controle do for, m�dia e vari�ncia.
    length_frames_video = (frame_final - frame_inicial) + 1;                                 %Necess�rio para a implementa��o do for (o +1 � pra incluir o primeiro termo!)
    
    mediaTOTAL = [];
    mediaBlobsEmFrame = 0;
    mediaFrameIndividual = 0; %(Em 1 peixe e muda em cada loop).
    
        
    %LOOP PRINCIPAL
    for i=1:1:length_frames_video
         
        %converte pra tons de cinza e double pra trabalhar
        if colorida || (cor == 1)
            wframe = double(frames_video(:,:,:,i));
        else
            wframe  = double(rgb2gray(frames_video(:,:,:,i)));
        end
        
        
        %faz a diferenca so na area de interesse e extrai o centro de massas
        %das regioes (blobs) maiores que minpix
        [cx, cy, radius, boundingbox, ndetect, ~, ~] = extractnblobs(wframe, Imback, V, nanimais, mascara, minpix, maxpix, tol, avi, criavideo, tipsubfundo);
    
        %vetor que ir� decorar cada animal que ja foi associado a um blob
        detectado = zeros(nanimais);
    
        if pxant(1)==0 %global variable;

            if  tipfilt == 1
                %previsao do filtro de kalman
                for j=1:nanimais
                    pdecorada = [pxant(j); pyant(j)];
                    predita = A*[pdecorada;v(:,j)] + Bu;
                    %garantir que esta dentro da imagem
                    predita(1) = min(max(predita(1),1),c);
                    predita(2) = min(max(predita(2),1),l);
                    pxant(j) = predita(1);
                    pyant(j) = predita(2);
                    v(:,j) = predita(3:4);
                end
            end
            
            
            %OLHAR POR PX E PY
            [px, py, detectado, caixa] = associateeuclid(nanimais, ndetect, pxant, pyant, cx, cy, radius, boundingbox, detectado, dicax, dicay ...
                                                                        , caixa, l, c, frames_video(:,:,:,i));
        end
        
        %aqui come�a a parte que trata do c�culo das m�dias
        
        frameHSV = rgb2hsv(frames_video(:,:,:,i));  %converte o i-�simo frame(frame atual) para HSV;
        wframe_log = logical(wframe);   %convertendo o wframe e logical(wframe) para separar as areas em regi�es pretas e brancas
                                        %s� fa�o isso pra pegar exatamente as areas dos peixes.
                                        
        %OBS: Somente conseguimos dizer que o k-�simo elemento do loop � o k-�simo peixe em todas as situa��es porque antes de
        %rodar esse loop, as fun��es extractnblobs() e associateeuclid() fora executadas!
                                        
        %percorrendo de k=1 at� o numero de animais (podemos ter mais de um blob por frame)
        for k=1:1:nanimais %blob individual do frame
            sizeOfBlob = 0; %number of pixels/blob;
            %disp(caixa(k,:))      PRA DEBUGAR DPS
            for m = floor(caixa(k, 1)):1:floor( caixa(k, 1) + caixa(k,3) )   %1 = x0, 2=y0, 3=width, 4=height; (goes from 'x0' to 'x0 + widith')
                for n=floor(caixa(k, 2)):1:floor( caixa(k, 2) + caixa(k,4) ) %(goes from 'y0' to 'y0 + height')
                    if(detectado(k))        %detectado(:) � a condi��o em 0's e 1's de ter um peixe ou n�o associado ao k-�simo blob(?)
                        if(wframe_log(m,n) == 1 && frameHSV(m,n,3) >= INTENSO) %testando para o vermelho aqui.
                            mediaFrameIndividual = mediaFrameIndividual + frameHSV(m,n,1);
                            sizeOfBlob = sizeOfBlob + 1;
                        end
                    end
                end
            end
            
            mediaFrameIndividual =  mediaFrameIndividual/sizeOfBlob;
            mediaBlobsEmFrame = mediaBlobsEmFrame + mediaFrameIndividual;
            
            %zerando as vari�veis de controle
            sizeOfBlob = 0;
            mediaFrameIndividual = 0;
        
        end
        
        mediaBlobsEmFrame = mediaBlobsEmFrame/ndetect;
        mediaTOTAL(i) = mediaBlobsEmFrame;
        
        %zerando as vari�veis de m�dia locais
        mediaBlobsEmFrame = 0;
        pxant=px;
        pyant=py;
    end
    
    media = mean(mediaTOTAL);  %MEDIA FINAL CALCULADA
    variancia = var(mediaTOTAL); %VARI�NCIA FINAL CALCULADA
    
    
end
    
    


%Fun��o para converter meu tempo inicial e final em termos dos frames correspondentes.
function [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video)
    frame_inicial = video.FrameRate*tempo_inicial;
    frame_final = video.FrameRate*tempo_final;  
end


function frames_video = geraVetor_frames_video(video, frame_inicial, frame_final)
    frames_video = read(video, [frame_inicial frame_final]);
end


%function [cc,cr,radius,boundingbox,ndetect,avi,foremm] = extractnblobs(Imwork,Imback,V,n,mascara,minpix,maxpix,tol,avi,criavideo,tipsubfundo)
%function [pxn,pyn,detectado,caixa] = associateeuclid(nanimais,ndetect,pxa,pya,cx,cy,radius,boundingbox,detectado,dicax,dicay,caixa,l,c,frame)
