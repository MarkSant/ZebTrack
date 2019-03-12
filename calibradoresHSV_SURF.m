%A ideia � que o usu�rio defina um intervalo em (tempo_inicial - tempo_final)
%de qualquer extens�o de forma que o mesmo possibilite gerar uma biblioteca
%de pontos resultante de m�ltiplos SURFS em m�ltiplos frames e uma m�dia e
%vari�ncia correspondente a cada peixe

%OBS:
%tolerancia = threshrold na track.m, que serve para a subtra��o de fundo.


%media e variancia s�o dois vetores, j� que posso ter mais de 1 peixe.
function [media, variancia] = calculaMediaVarianciaHSV(video_rastreio, tempo_inicial, tempo_final, ...
                                                       ,Imwork, Imback, V, n, mascara, minpix, maxpix, tol, avi, criavideo, tipsubfundo)

    [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video_rastreio); %aqui obtenho os �ndices final e inicial para a calibra��o.
    frames_video = read(video_rastreio, [frame_inicial, frame_final]);      %cria um vetor com todos os frames entre frame_incial e frame_final.
                                                                            %Lembrando que para acessar o i-�simo frame, uso a nota��o frames_video(:,:,:,i);
    
    %vari�veis de controle do for, m�dia e vari�ncia.
    length_frames_video = (frame_final - frame_inicial) + 1;                %Necess�rio para a implementa��o do for (o +1 � pra incluir o primeiro termo!)
                                                                            
    %loop para pegar a m�dia e a vari�ncia dos frames do v�deo.
    for i=1:1:length_frames_video
        
    end
    
end


%Fun��o para converter meu tempo inicial e final em termos dos frames correspondentes.
function [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video_rastreio)
    frame_inicial = video_rastreio.FrameRate*tempo_inicial;
    frame_final = video_rastreio.FrameRate*tempo_final;  
end


function frames_video = geraVetor_frames_video(video_rastreio, frame_inicial, frame_final)
    frames_video = read(video_rastreio, [frame_inicial frame_final]);
end
