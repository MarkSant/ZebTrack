video = videoinput('winvideo', 1, 'I420_320x240');
%inicia um objeto videoinput que acessa a webcam, o entrada, no caso a web
%cam seria '1' o tipo de imagem e a resolu��o
set(video, 'FramesPerTrigger', inf);
set(video, 'ReturnedColorspace', 'rgb');
video.FrameGrabInterval = 5;
%o tempo em milisegundos que o v�deo captura um frame da webcam
start(video);
video_processing = VideoWriter('tempo_real.avi','Indexed AVI');
%iniciando a captura
open(video_processing);
while(video.FramesAcquired <= 200)
    frame = getsnapshot(video);
    %exibindo na tela cada frame do v�deo
    imshow(frame);
    writeVideo(video_processing, frame);
    %lembrando que para nossa aplica��o precisamos de um objeto v�deo,
    %ent�o devemos usar um loop para gerar um video com o frames adquiridos
    %e depois process�-los
end
close(video_processing);
%refer�ncias
%https://la.mathworks.com/help/supportpkg/usbwebcams/ug/webcam.html
%https://la.mathworks.com/help/imaq/videoinput.html
%https://la.mathworks.com/help/imaq/obj2mfile.html
%https://la.mathworks.com/help/imaq/examples/managing-image-acquisition-objects.html