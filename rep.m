%generates report
vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];
n = length(e) * isfield(e,'t');
%for each experiment
for ne=1:n
    t=e(ne).t;
    posicao=e(ne).posicao;
    velocidade=e(ne).velocidade;
    parado=e(ne).parado;
    dormindo=e(ne).dormindo;
    tempoareas=e(ne).tempoareas;
    distperc=e(ne).distperc;
    comportamento=e(ne).comportamento;
    areaproc=e(1).areaproc;
    pxcm = e(1).pxcm;
    figdimensions = e(1).figdimensions;
    directory = e(1).directory;
    filename = e(1).filename;
    cont_parada_area = e(ne).contparado_area;
    coord_parada_area = e(ne).parado_area;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %data analysis

    fprintf('\n\n');
    disp('--------------------------------------------------------------');
    fprintf(['Results of experiment number ' num2str(ne) ':\n'])
    disp('--------------------------------------------------------------');
    fprintf('\n\n');

    nanimais = length(posicao); %descobre quantos animais foram rastreados
    
    %Ex: Basic Info: several data about the animals
    if e(1).basicinfo
        [trash, nareas]= size(tempoareas);
        for i=1:nanimais
            disp(['Animal ' num2str(i)])
            for j=1:nareas
                if length(tempoareas{i,j}) ~= 0  %se o peixe entrou pelo menos uma vez na �rea
                    tt = sum(tempoareas{i,j}.tf - tempoareas{i,j}.ti);
                else
                    tt = 0;
                end
                disp(['    Total time spent in area ' num2str(j) ': ' num2str(tt) 's'])
            end

            %Ex7: Distancia percorrida pelo peixe 1
            disp(['    Total distance of animal ' num2str(i) ': ' num2str(distperc(i)) 'cm'])


            %Ex8: Velocidade media:
            disp(['    Mean speed of animal ' num2str(i) ': ' num2str(mean(velocidade{i}.total)) 'cm/s']) 

            disp(['    Maximum speed of animal ' num2str(i) ': ' num2str(max(velocidade{i}.total)) 'cm/s'])


            %Ex9: tempo total parado:
            disp(['    Total time stoped for animal ' num2str(i) ': ' num2str(sum(parado{i}.tf-parado{i}.ti)) 's'])
            for j=1:nareas
                fprintf(['    Number of times the animal ' num2str(i) ' entered in area ' num2str(j) ': '])
                if tempoareas{i,j}.tf(1) ~= 0  %se o peixe entrou pelo menos uma vez na �rea
                    disp(num2str(length(tempoareas{i,j}.ti)))
                else
                    disp('0');
                end
            end
            fprintf('\n');
        end
    end

    %Ex: Behaviour Information: time spent in each behaviour
    if e(1).behaviourinfo 
        nc = max(comportamento.tipo); %numero de comportamentos
        tempcomp = zeros(1,nc);
        for i=1:length(comportamento.tipo)
           tempcomp(comportamento.tipo(i)) =  tempcomp(comportamento.tipo(i)) + comportamento.tf(i) - comportamento.ti(i);
        end
        for i=1:nc
            disp(['Time spent in behaviour ' num2str(i) ' : ' num2str(tempcomp(i))])
        end
        fprintf('\n');
        %behaviour transitions matrix
        btm = zeros(max(comportamento.tipo)) - eye(max(comportamento.tipo));
        for i=1:length(comportamento.tipo)-1
            btm(comportamento.tipo(i),comportamento.tipo(i+1)) = btm(comportamento.tipo(i),comportamento.tipo(i+1)) + 1;
        end
        disp('Behaviour Transition Matrix')
        disp(btm);
    end
    

    %Ex: Area Information
    if e(1).areainfo 
        if nareas~=0
            if isfield(e(1),'areaint') && ne==1
                f1=figure;
                backg = imread([directory,'/',filename,'.jpeg']);
                imshow(backg)
                hold on
                desenha_areas(e(1).areaint,'','b',1);
                desenha_areas(e(1).areaproc,'','g',1);
                if e(1).report
                    snapnow
                    close(f1)
                end
            end
            fprintf('\n');
            %Ex: statistics of each area
            for i=1:nanimais
                disp(['Animal ' num2str(i)])
                for j=1:nareas
                    disp(['   Statistics in Area ' num2str(j)])
                     if tempoareas{i,j}.tf(1) ~= 0  %se o peixe entrou pelo menos uma vez na �rea
                        velnaarea{i,j}.v=[];
                        for k=1:length(velocidade{i}.total);
                            for l=1:length(tempoareas{i,j}.ti)
                                if t(k) >= tempoareas{i,j}.ti(l) &&  t(k) < tempoareas{i,j}.tf(l) %neste tempo estava na area
                                    velnaarea{i,j}.v = [velnaarea{i,j}.v velocidade{i}.total(k)];
                                end
                            end
                        end
                        disp(['      Mean speed ' num2str(mean(velnaarea{i,j}.v))])
                        disp(['      Max speed ' num2str(max(velnaarea{i,j}.v))])
                        disp(['      Total distance ' num2str(mean(velnaarea{i,j}.v*sum(tempoareas{i,j}.tf - tempoareas{i,j}.ti)))])

                        %tempo parado em cada �rea
                        %totparado(j)=0;
                        %nvezesparado = length(parado{i}.ti);
                        %for k=1:nvezesparado
                        %    for l=1:length(tempoareas{i,j}.ti)
                        %        if parado{i}.ti(k) >= tempoareas{i,j}.ti(l) &&  parado{i}.ti(k) < tempoareas{i,j}.tf(l)
                        %            totparado(j) = totparado(j) + parado{i}.tf(k) - parado{i}.ti(k);
                        %        end
                        %    end
                        %end
                        totparado(j)=0; % Inicializa o tempo total parado na �rea 1 para o animal i
                        %area_atual_idx = 1; % �ndice da �rea atual
        
                        % Verifica se h� paradas registradas para este animal (i) nesta �rea (area_atual_idx)
                        % A contagem j� considera apenas paradas com dura��o >= tmin
                        if cont_parada_area(i, j) > 0
                            % Acessa os tempos de in�cio e fim das paradas espec�ficas desta �rea
                            % Verifica se os campos .ti e .tf existem na estrutura (boa pr�tica)
                            if isfield(coord_parada_area{i, j}, 'ti') && isfield(coord_parada_area{i, j}, 'tf')
                                tempos_inicio_parada_area = coord_parada_area{i, j}.ti;
                                tempos_fim_parada_area = coord_parada_area{i, j}.tf;

                                % Certifica-se de que os vetores t�m o mesmo tamanho e n�o est�o vazios
                                if ~isempty(tempos_inicio_parada_area) && (length(tempos_inicio_parada_area) == length(tempos_fim_parada_area))
                                    diferencas_tempo = tempos_fim_parada_area - tempos_inicio_parada_area;
                                    % Remove NaNs que podem surgir se uma parada n�o foi corretamente finalizada ou se vetores foram malformados
                                    diferencas_tempo_validas = diferencas_tempo(~isnan(diferencas_tempo)); 
                                    totparado(j) = sum(diferencas_tempo_validas); % Soma as dura��es de todas as paradas v�lidas na �rea
                                end
                            end
                        end
                        disp(['      Total time stopped: ' num2str(totparado(j))])
                        disp(['      Latency: ' num2str(tempoareas{i,j}.ti(1) - t(1))])
                     else
                         disp('      Animal did not enter the area');
                     end
                end
                %%CODIGO DE ASSIS AQUI
                
            end
        end
    end

    %Ex1: plot animal position
    if e(1).animalplot 
        for i=1:nanimais
            f1=figure;
            plot(t,posicao{i}.x);
            hold on %nao apagar o grafico da posicao x
            plot(t,posicao{i}.y,'r'); %em vermelho (red)
            title(['Animal ' num2str(i) ' position on x and y axis']);
            xlabel('Time (s)')
            ylabel('Position (cm)')
            legend('Position x','Position y');
            
                       
            if e(1).report
                snapnow
                close(f1)
            end
            
            f2=figure;
            %distance by time 
            plot(t(1:end-1),cumsum(velocidade{i}.total.*diff(t))) 
            title(['Animal ' num2str(i) ' distance traveled']);
            xlabel('Time (s)')
            ylabel('Distance (cm)')
            
            if e(1).report
                snapnow
                close(f2)
            end
            
        end
    end
    
    %Ex: plot of bacground with animals trajectories
    if e(1).backgplot
        f1=figure;
        
        try
            backg = imread([directory,'/',filename,'.jpeg']);
            imshow(backg)
        catch
            disp('Could not find background image');
        end
        
        hold on
        
        for j=1:nanimais
            px = posicao{i}.x*pxcm.x;
            py = figdimensions.l-posicao{i}.y*pxcm.y; %i
            plot(px,py,'Color',vcores(mod(j,7)+1,:));
        end
        
        if e(1).report
            snapnow
            close(f1)
        end
    end
    
    
    %Ex3: calcula a transformada de fourrier da posicao x do animal 1
    if e(1).fouriertransf
        for i=1:nanimais
            L = length(posicao{i}.x); %numero de pontos
            Fs = 1/(5/25); %frequencia de amostragem = 1/(procframe/fps)
            Y = fft(posicao{i}.x - mean(posicao{i}.x))/L; %calcula a tranformada
            f = Fs/2*linspace(0,1,L/2+1); %vetor das fequencias
            f1=figure;
            plot(f,2*abs(Y(1:floor(L/2+1)))); %plota um dos lados do modulo da transformada
            hold on
            Y = fft(posicao{i}.y - mean(posicao{i}.y))/L; %calcula a tranformada
            f = Fs/2*linspace(0,1,L/2+1); %vetor das fequencias
            plot(f,2*abs(Y(1:floor(L/2+1)))); %plota um dos lados do modulo da transformada
            title(['Fourrier Transform of animal ' num2str(i)]);
            xlabel('Frequencie (Hz)')
            ylabel('Amplitude (cm)')
            legend('x data','y data');
            if e(1).report
                snapnow
                close(f1)
            end
        end
    end

    %Ex4: calcula a distanica de todos os animais para um deteminado ponto e plota
    if e(1).distpointinfo
        f1 = figure;
        ponto(1) = e(1).distpoint.x/pxcm.x;
        ponto(2) = (figdimensions.l - e(1).distpoint.y)/pxcm.y;
        distancia = [];
        for i=1:nanimais
            distancia(i,:) = sqrt((posicao{i}.x - ponto(1)).^2 + (posicao{i}.y - ponto(2)).^2);
        end
        plot(t,distancia) %as cores dos graficos dos varios animais ficam diferentes
        title(['Distance of animal(s) from a fixed point (' num2str(ponto(1)) ',' num2str(ponto(2)) ')']);
        xlabel('Time (s)')
        ylabel('Distance (cm)')
        if e(1).report
            snapnow
            close(f1)
        end
    end

    %Ex5: figura em 3D mostrando a posicao do animal 1 no aquario em funcao do
    %tempo
    if e(1).animalplot3D 
        for i=1:nanimais
            f1=figure;
            plot3(posicao{i}.x,posicao{i}.y,t,'.');
            title(['Position of the animal ' num2str(i)]);
            xlabel('Position x (cm)')
            ylabel('Position y (cm)')
            zlabel('Time (s)')
            grid;
            if e(1).report
                snapnow
                close(f1)
            end
        end
    end
    
    %Ex11: dist�ncia para uma reta
    if e(1).distlineinfo
        %converte areaproc de px pra cm
        p1x = e(1).distlineini.x/pxcm.x;
        p1y = (figdimensions.l - e(1).distlineini.y)/pxcm.y;

        p2x = e(1).distlinefim.x/pxcm.x;
        p2y = (figdimensions.l - e(1).distlinefim.y)/pxcm.y;
        
        %reta ax + by + c que define tal aresta
        a =  (p2y - p1y) / (p2x - p1x);
        b = -1;
        c = p2y - a*p2x;

        distanciapfundo = [];
        for i=1:nanimais
            distanciapfundo(i,:) = abs(a*posicao{i}.x + b*posicao{i}.y + c)/sqrt(a^2+b^2);
            disp(['Mean distance from the line for animal ' num2str(i) ' : ' num2str(mean(distanciapfundo(i,:)))]);
        end
        
        f1 = figure;
        plot(t,distanciapfundo) %as cores dos graficos dos varios animais ficam diferentes
        title('Distance of animal(s) from a line');
        xlabel('Time (s)')
        ylabel('Distance (cm)')
        if e(1).report
            snapnow
            close(f1)
        end
    end
    
    %angular velocity
if e(1).angularvelocity
    vangular = zeros(nanimais, length(t));
    np = 7;
    deltat = t(2) - t(1);
    for i = 1:nanimais
        xf = movmean(posicao{i}.x*pxcm.x, np); % atrasa floor(np/2)
        dx = diff(xf); % perde um indice
        dx = movmean(dx, np); % atrasa mais np/2
        ddx = diff(dx); % perde 1 indice
        ddx = movmean(ddx, np); % atrasa mais np/2
        ddx = atan(abs(ddx)) * 180 / pi;
        ddx = ddx(floor(3/2 * np):end); % des atrasa sinal
        ddx(isnan(ddx)) = 0; % tirar nan para o peakfinder

        yf = movmean(posicao{i}.y*pxcm.y, np); % atrasa floor(np/2)
        dy = diff(yf); % perde um indice
        dy = movmean(dy, np); % atrasa mais np/2
        ddy = diff(dy); % perde 1 indice
        ddy = movmean(ddy, np); % atrasa mais np/2
        ddy = atan(abs(ddy)) * 180 / pi;
        ddy = ddy(floor(3/2 * np):end); % des atrasa sinal
        ddy(isnan(ddy)) = 0; % tirar nan para o peakfinder

        ddxy = sqrt(ddx.^2 + ddy.^2);

        sel = [];
        limmax = e(1).angularvelocitythreshold * 90;
        [picos, peakMag] = peakfinder(ddxy, sel, limmax);
        f1 = figure;
        plot(t(1:length(ddxy)), ddxy);
        csvwrite(fullfile(directory, ['angularvelocity' int2str(ne) '.csv']), [t(1:length(ddxy)); ddxy]);
        hold on
        plot(t(1:length(ddxy)), ones(length(ddxy)) * limmax, 'r');
        tpicos = t(1) + (picos - 1) * deltat;
        plot(tpicos, peakMag, 'ro', 'linewidth', 2);
        title(['Animal ' num2str(i) ' angular velocity']);
        xlabel('Time (s)')
        ylabel('Angular velocity (degree/frame)')
        if e(1).report
            snapnow
            close(f1)
        end
        disp(['    Total number of sharp turns: ' num2str(length(picos))])
        global total_sharp_turns;
        total_sharp_turns = length(picos);
        disp(['    Number of sharp turns per minute: ' num2str(length(picos) * 60 / (t(end) - t(1)))])
        global number_sharp_turns_minute;
        number_sharp_turns_minute = length(picos) * 60 / (t(end) - t(1));
    end
end



    
    
    
   %computes heat map
    if e(1).heat_map
        for j=1:nanimais
            heat_map_figure = zeros(figdimensions.l, figdimensions.c);
            for i=1:length(posicao{j}.x)%a quantidade de pontos pintados depende s� de uma das coordenanadas,
                                        %mais especificamente do quantidade
                                        %armaezenada em posicao{}.x da
                                        %mesma.
                %dimens�es do retangulo em que desejamos pintar
                for k = -5:1:5
                    for m = -5:1:5
                        heat_map_figure(floor(figdimensions.l-posicao{j}.y(i)*pxcm.y) + m, floor(posicao{j}.x(i)*pxcm.x) + k) =  heat_map_figure(floor(figdimensions.l-posicao{j}.y(i)*pxcm.y) + m, floor(posicao{j}.x(i)*pxcm.x) + k) + 1;
                    end
                end
                
            end
            
            %max(max(heat_map_figure)); %to normalize the heatmap matrix.
            hmfb = ind2rgb(uint8(heat_map_figure), jet(max(max(heat_map_figure)))); %� prefer�vel que os valores de jet sejam baixos!

            
            f1 = figure;
            imshow(hmfb);
            
            %sobrepor
            alpha = 0.5;
            f2 = figure;
            
%             tentado modificar com uso de OPERA��ES MORFOL�FICAS e o filtro
%             gaussiano.
%             
%             SE = strel('disk',1); %referencia de um circulo com raio de tamnho 1 pixel!
%             heatMapBonitoDilatado = imdilate(hmfb,SE); %dilata a figura.
            
               
            hmfb = imgaussfilt(hmfb, 2);    %aplica��o do filtro gaussiano aqui!
            
            sobreposta = (1-alpha)*double(backg) + alpha*double(255*hmfb);%multiplied by 255 given that ind2rgb returns a value between 0 and 1.
            imshow(uint8(sobreposta));
            
            if e(1).report
                snapnow
                close(f1);
                close(f2);
            end
            
        end
    end


    
    %Group statistcs
    if nanimais > 1  %so faz as estatisticas de grupo se for mais de um animal
        %Pr� alocando os arrays para o c�lculo das m�tricas de coes�o de grupo
        meandist = zeros(1, length(t));
        dist = zeros(nanimais, length(t));
        if e(1).groupInfo || true
            meanx = mean(posicao{2:end}.x);
            meany = mean(posicao{2:end}.y);

            varx = var(posicao{2:end}.x);
            vary = var(posicao{2:end}.y);

            for i=1:length(t)

                %distance
                for j=1:nanimais
                   dist(j,i) = norm([posicao{j}.x(i)-meanx posicao{j}.y(i)-meany]);
                end
                meandist(i) = mean(dist(:,i));
                %disp(['n-�sima varia�ao em x: ' num2str(varx(i))]);
                %disp(['n-�sima posi��o em x: ' num2str(var(posicao{2:end}.x(i)))]);
            end
            variancia_media_x = mean(varx);
            variancia_media_y = mean(vary);
            vartotal = var(posicao{2:end}.x) * var(posicao{2:end}.y);
            %disp(['Mean distance: ' num2str(mean(meandist)) ' cm'])
            disp(['Coefficient of group cohesion: ' num2str(vartotal)]);
            if e(1).report
               snapnow
               close(f1);
               close(f2);
            end

        end
        distanimaloneprocentro = zeros(1, length(t));
        meandist = zeros(1, length(t));
        dist = zeros(nanimais, length(t));
        if e(1).groupInfoVsanimalOne || true
            varx = var(posicao{2:end}.x);
            vary = var(posicao{2:end}.y);

            meanx = mean(posicao{2:end}.x);
            meany = mean(posicao{2:end}.y);
            for i =1:length(t)
                %distance
                for j=2:nanimais
                   dist(j,i) = norm([posicao{j}.x(i)-meanx posicao{j}.y(i)-meany] );
                end
                meandist(i) = mean(dist(:,i));
                %Vs animal one
                %verificar se presta
                distanimaloneprocentro(i) = norm([meanx-posicao{1}.x(i) meany-posicao{1}.y(i)]);
            end
            disp(['Mean distance from animal 1 to the centroid of the group: ' num2str(mean(distanimaloneprocentro))]);
            disp(['Variance of mean distance from animal 1 to the centroid of the group: ' num2str(var(distanimaloneprocentro))]);
            if e(1).report
               snapnow
               close(f1);
               close(f2);
            end

        end
        if ~e(1).report && ne~=n 
             fprintf('\n\n');
             disp('Press any key to see the results of the next experiment (or Ctrl+C to stop showing results, in case you saved it in another format)')
             pause
        end
    end
    
    if e(1).areasequence
        areasequence_computation(tempoareas)
    end
    
end %do for de cada experimento