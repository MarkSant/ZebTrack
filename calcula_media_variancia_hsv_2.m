%{
Para esse c�digo, estou deliberadamente ignorando a dica
%}

function [media, variancia] = calcula_media_variancia_hsv_2(video, tempo_inicial, tempo_final ...
                                                       , Imback, V, nanimais, mascara, minpix, maxpix, tol, avi, criavideo, tipsubfundo ...
                                                       , caixa, l, c ...
                                                       , colorida, cor, tipfilt ...
                                                       , INTENSIDADE)


    [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video); %aqui obtenho os �ndices final e inicial para a calibra��o.
    new_video = VideoReader([video.Path,'\',video.Name]); % preciso criar um novo VideoReader pra evitar um bug  
    frames_video = read(new_video, floor([frame_inicial, frame_final]));                         %cria um vetor com todos os frames entre frame_incial e frame_final.
                                                                                             %Lembrando que para acessar o i-�simo frame, uso a nota��o frames_video(:,:,:,i);                                                   
    length_frames_video = (floor(frame_final) - floor(frame_inicial)) + 1;                   %Necess�rio para a implementa��o do for (o +1 � pra incluir o primeiro termo!)
    %disp(['frame_inicial =', num2str(frame_inicial),'; frame_final = ',num2str(frame_final)]);                                                                                             
    %media = 0;
    %variancia = 1;
end


%Fun��o para converter meu tempo inicial e final em termos dos frames correspondentes.
function [frame_inicial, frame_final] = extraiIntervaloFrames(tempo_inicial, tempo_final, video)
    frame_inicial = video.FrameRate*tempo_inicial;
    frame_final = video.FrameRate*tempo_final;  
end

