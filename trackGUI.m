%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Autor: Marcelo Borges Nogueira
%Data: 30/04/2013
%Descricao: Parte visual para o trackGUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = trackGUI(varargin)
% trackGUI M-file for trackGUI.fig
%      trackGUI, by itself, creates a new trackGUI or raises the existing
%      singleton*.
%
%      H = trackGUI returns the handle to a new trackGUI or the handle to
%      the existing singleton*.
%
%      trackGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in trackGUI.M with the given input
%      arguments.
%
%      trackGUI('Property','Value',...) creates a new trackGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trackGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trackGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trackGUI

% Last Modified by GUIDE v2.5 30-Apr-2025 08:57:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trackGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @trackGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end
% --- Executes just before trackGUI is made visible.
function trackGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trackGUI (see VARARGIN)

% Choose default command line output for trackGUI
handles.output = hObject;

handles.areaproc = [];
handles.areaint = [];
handles.areaexc = [];
handles.axes4 = findobj('Tag', 'axes4');
handles.e = [];
handles.directoryname = [];

handles.waibar = uiwaitbar(handles.axes5);

handles.waibarfundo = uiwaitbar([0.35 0.36 0.34 0.08],handles.uipanel2);


% handles.waibar.visivel('on');
% handles.waibar.setvalue(0);
handles.waibarfundo.visivel('off');

handles.definirapc = 0;

set(handles.saveres,'Enable','off')
set(handles.splitres,'Enable','off');
set(handles.saveresexcel,'Enable','off')
set(handles.saveresword,'Enable','off')
set(handles.viewrep,'Enable','off')
set(handles.selrepitems,'Enable','off')
set(handles.mensagem,'Visible','off');
set(handles.radiofk,'Value',0)
set(handles.radiofpb,'Value',1)
set(handles.radiosfb,'Value',0)
set(handles.radiosfe,'Value',1)
set(handles.posicaomouse,'String','');
set(handles.posicaomouse2,'String','');
set(handles.posicaomouse,'Visible','off');
set(handles.posicaomouse2,'Visible','off');
set(handles.pause,'Enable','off')
set(handles.splitres,'Enable','off');
uistack(handles.uipanel7,'bottom');

%para passar o ponteiro da funcao de clique pra dentro do track
handles.pontButtonDown = @axes4_ButtonDownFcn;

global threshadaptativo;
threshadaptativo = 0;

handles.live = false;
%apaga objetos de video ao vivo que estejam ocupando a camera
objects = imaqfind;
delete(objects);

movegui(hObject,'center')

handles.nactions = 0;
%esconder todas as caixas de acoes
for i=3:3*10+2
   eval(['set(handles.popupmenu' num2str(i) ',''Visible'',''off'');']);
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trackGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = trackGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.e;
varargout{2} = handles.directoryname;
delete(handles.figure1);
end


function pasta_Callback(hObject, eventdata, handles)
% hObject    handle to pasta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pasta as text
%        str2double(get(hObject,'String')) returns contents of pasta as a double
[directoryname,filename,ext] = fileparts(get(handles.pasta,'String'));
directoryname = [directoryname '\'];
filenameSemExtensao = filename;
filename = [filename ext];

 
if ~isempty( directoryname )
    %le o video na memoria
    handles.video = VideoReader([directoryname,filename]);
    
    set(handles.pasta,'String',fullfile(directoryname, filename));
    handles.directoryname = directoryname;
    handles.filename = filename;
    handles.filenameSemExtensao = filenameSemExtensao;
    
    
    %handles.areaproc = [];
    %handles.areaint = [];
    
    set(handles.visualizar,'Enable','on')
    
    set(handles.apclick,'Enable','off')
    set(handles.aiclick,'Enable','off')
    set(handles.btareaintlimpar,'Enable','off')
    set(handles.aeclick,'Enable','off')
    set(handles.btareaexclimpar,'Enable','off')
    set(handles.run,'Enable','off')
    set(handles.calcpxcm,'Enable','off')
    set(handles.btcriafundo,'Enable','off')

    axes(handles.axes1);
    cla reset
    set(handles.axes1,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
    axes(handles.axes2);
    cla reset
    set(handles.axes2,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
    axes(handles.axes3);
    cla reset
    set(handles.axes3,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
    axes(handles.axes4);
    cla reset
    set(handles.axes4,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
    
    %barras de roalgem do video
    set(handles.sliderti,'Min',1);
    set(handles.slidertf,'Min',handles.frameRate);
    set(handles.sliderti,'Max',handles.video.NumberOfFrames - handles.frameRate); %seta maximo
    set(handles.slidertf,'Max',handles.video.NumberOfFrames); %seta maximo
    set(handles.sliderti,'Value',1); %seta valor inicial
    set(handles.slidertf,'Value',handles.video.NumberOfFrames); %seta valor inicial
    
    handles.valsliti = round(get(handles.sliderti,'Value'));
    handles.valslitf = round(get(handles.slidertf,'Value'));
    
    set(handles.sliderti,'Value',handles.valsliti);
    set(handles.slidertf,'Value',handles.valslitf);
    set(handles.tfimmin,'String',num2str(floor(handles.valslitf/(handles.frameRate*60))));
    set(handles.tfimseg,'String',num2str(floor(handles.valslitf/(handles.frameRate) - 60*floor(handles.valslitf/(handles.frameRate*60)))));
    
    %set(handles.qini,'String','1'); 
    set(handles.tinimin,'String','0')
    set(handles.tiniseg,'String','0')
    %set(handles.qfim,'String',num2str(handles.video.NumberOfFrames));
    %set(handles.tfimmin,'String',num2str(floor(handles.video.Duration/60)));
    %set(handles.tfimseg,'String',num2str( floor( handles.video.Duration -  floor(handles.video.Duration/60)*60 )));
    
    
    handles.frameini = floor((str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1);
    handles.framefim = floor((str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate);

   
    %if handles.framefim > handles.video.NumberOfFrames
    %    handles.framefim = handles.video.NumberOfFrames - handles.frameRate;
    %end
    
    
    
    try
        fundo = imread([handles.directoryname, '/',filenameSemExtensao, '.jpeg']);
        load([handles.directoryname,'/', filenameSemExtensao,'V.mat']);
    catch
        %se nao tem, cria
        %ajusta a quantidade de iamgens utilizadas de acordo com a duraÃ§Ã£o do
        %video
        set(handles.fundoframe,'String',num2str(round(handles.video.NumberOfFrames*0.004)));
        p = imread('processando.jpeg');
        axes(handles.axes3);
        imshow(p);
        drawnow;
        %set(handles.waibarfundo,'Visible','on');
        [fundo,V] = criafundo(handles.directoryname,handles.filenameSemExtensao,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')),handles.waibarfundo);
    end

[l,c,~]=size(fundo);
handles.c = c;
handles.l = l;
handles.fundo = fundo;
handles.V = V;
handles.waibarfundo.setvalue(0);
handles.waibarfundo.visivel('off');
axes(handles.axes3);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);
axes(handles.axes4);
hold off
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
    
    guidata(hObject, handles);

    visualizar_Callback(hObject, eventdata, guidata(hObject))

    handles=guidata(hObject);
    guidata(hObject,handles);
end
end

% --- Executes during object creation, after setting all properties.
function pasta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pasta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function qini_Callback(hObject, eventdata, handles)
% hObject    handle to qini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qini as text
%        str2double(get(hObject,'String')) returns contents of qini as a double

end
% --- Executes during object creation, after setting all properties.
function qini_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function qfim_Callback(hObject, eventdata, handles)
% hObject    handle to qfim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qfim as text
%        str2double(get(hObject,'String')) returns contents of qfim as a double
end
% --- Executes during object creation, after setting all properties.
function qfim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qfim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in visualizar.
function visualizar_Callback(hObject, eventdata, handles)
% hObject    handle to visualizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.live
    handles.frameini = floor((str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1);
    handles.framefim = floor((str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate);


    if handles.framefim<=handles.frameini
        handles.framefim = handles.frameini + handles.frameRate;
    end
    %if handles.framefim > handles.video.NumberOfFrames
    %        handles.framefim = handles.video.NumberOfFrames - handles.frameRate;
    %end
    set(handles.sliderti,'Value',handles.frameini);
    set(handles.slidertf,'Value',handles.framefim);

    set(handles.tfimmin,'String',num2str(floor(handles.framefim/(handles.frameRate*60))));
    set(handles.tfimseg,'String',num2str(floor(handles.framefim/(handles.frameRate) - 60*floor(handles.framefim/(handles.frameRate*60)))));


    try
        fini = read(handles.video,handles.frameini);
        %fini = read(handles.video,str2double(get(handles.qini,'String')));
        %fini = imread([handles.directoryname,'/frame',get(handles.qini,'String') ,'.jpeg']);
    catch
        msgbox('Starting frame not found!','Erro','error');
        set(handles.apclick,'Enable','off')
        set(handles.aiclick,'Enable','off')
        set(handles.btareaintlimpar,'Enable','off')
        set(handles.aeclick,'Enable','off')
        set(handles.btareaexclimpar,'Enable','off')
        set(handles.run,'Enable','off')
        set(handles.calcpxcm,'Enable','off')
        set(handles.btcriafundo,'Enable','off')
       return 
    end
    axes(handles.axes1);
    axe1handle=imshow(fini);
    set(axe1handle,'ButtonDownFcn', @axes1_ButtonDownFcn);

    try
        ffim = read(handles.video,handles.framefim);
        %ffim = read(handles.video,str2double(get(handles.qfim,'String')));
        %ffim = imread([handles.directoryname,'/frame',get(handles.qfim,'String') ,'.jpeg']);
    catch
        msgbox('Ending frame not found!','Erro','error'); 
        set(handles.apclick,'Enable','off')
        set(handles.aiclick,'Enable','off')
        set(handles.btareaintlimpar,'Enable','off')
        set(handles.aeclick,'Enable','off')
        set(handles.btareaexclimpar,'Enable','off')
        set(handles.run,'Enable','off')
        set(handles.calcpxcm,'Enable','off')
        set(handles.btcriafundo,'Enable','off')
       return 
    end
    axes(handles.axes2);
    axe2handle=imshow(ffim);
    set(axe2handle,'ButtonDownFcn', @axes2_ButtonDownFcn);
end
axes(handles.axes4);
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);
hold on
if length(handles.areaproc) == 0
    handles.areaproc.x(1) = 1;
    handles.areaproc.y(1) = 1;
    handles.areaproc.x(2) = handles.c;
    handles.areaproc.y(2) = 1;
    handles.areaproc.x(3) = handles.c;
    handles.areaproc.y(3) = handles.l;
    handles.areaproc.x(4) = 1;
    handles.areaproc.y(4) = handles.l;
    handles.areaproc.x(5) = 1;
    handles.areaproc.y(5) = 1;
end
set(handles.apclick,'Enable','on')
set(handles.aiclick,'Enable','on')
set(handles.btareaintlimpar,'Enable','on')
set(handles.aeclick,'Enable','on')
set(handles.btareaexclimpar,'Enable','on')
set(handles.run,'Enable','on')
set(handles.calcpxcm,'Enable','on')
set(handles.visualizar,'Enable','on')
set(handles.btcriafundo,'Enable','on')
hold on
%area de processamento
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
%areas de interesse
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);

%areas de exclusao
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);

guidata(hObject, handles);


end
% --- Executes on button press in btcriafundo.
function btcriafundo_Callback(hObject, eventdata, handles)
% hObject    handle to btcriafundo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = imread('processando.jpeg');
axes(handles.axes3);
imshow(p);
set(handles.btcriafundo,'Enable','off')
set(handles.run,'Enable','off')
drawnow;

handles.frameini = (str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1;
handles.framefim = (str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate;

handles.waibarfundo.visivel('on');
[fundo,V] = criafundo(handles.directoryname,handles.filenameSemExtensao,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')),handles.waibarfundo);
handles.fundo = fundo;
handles.V = V;
axes(handles.axes3);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);
axes(handles.axes4);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);

desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);

%areas de exclusao
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);

set(handles.btcriafundo,'Enable','on')
set(handles.run,'Enable','on')
handles.waibarfundo.setvalue(0);
handles.waibarfundo.visivel('off');
guidata(hObject, handles);
end
% --- Executes on button press in btbrowse.
function btbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Variable to indicate completion status
handles.processingComplete = false;

% Verificar se já existem informações do vídeo fornecidas pelo CreatProjectButton_Callback
if isfield(handles, 'directoryname') && isfield(handles, 'filename') && ~isempty(handles.directoryname) && ~isempty(handles.filename)
    % Usar as informações já existentes
    directoryname = handles.directoryname;
    filename = handles.filename;
else
    % Caso contrário, solicitar ao usuário via uigetfile
    [filename, directoryname] = uigetfile('*.avi;*.mov;*.mp4;*.wmv;*.flv', 'Choose the video file:');
    if filename == 0
        return; % Se o usuário cancelar, sair da função
    end
    % Atualizar handles com as informações obtidas do uigetfile
    handles.directoryname = directoryname;
    handles.filename = filename;
end

% Leitura do vídeo na memória
warning ('off', 'all');
handles.video = VideoReader(fullfile(directoryname, filename));
warning ('on', 'all');
set(handles.pasta, 'String', fullfile(directoryname, filename));
[~, filenameSemExtensao, ~] = fileparts(get(handles.pasta, 'String'));
handles.filenameSemExtensao = filenameSemExtensao;

% Continuar o processamento como na lógica original...
% Restante do código permanece igual

%handles.areaproc = [];
%handles.areaint = [];

set(handles.visualizar,'Enable','on')

set(handles.apclick,'Enable','off')
set(handles.aiclick,'Enable','off')
set(handles.btareaintlimpar,'Enable','off')
set(handles.aeclick,'Enable','off')
set(handles.btareaexclimpar,'Enable','off')
set(handles.run,'Enable','off')
set(handles.calcpxcm,'Enable','off')
set(handles.btcriafundo,'Enable','off')

axes(handles.axes1);
cla reset
set(handles.axes1,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes2);
cla reset
set(handles.axes2,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes3);
cla reset
set(handles.axes3,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes4);
cla reset
set(handles.axes4,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');

%disp(['numero de frames ' num2str(handles.video.NumberOfFrames)])
handles.frameRate = handles.video.NumberOfFrames/handles.video.Duration;
%disp(handles.frameRate);
%disp(handles.video.NumberOfFrames);
%disp(handles.video.Duration);
%barras de roalgem do video
set(handles.sliderti,'Min',1);
set(handles.slidertf,'Min',handles.frameRate);
set(handles.sliderti,'Max',handles.video.NumberOfFrames - handles.frameRate); %seta maximo   handles.frameRate
set(handles.slidertf,'Max',handles.video.NumberOfFrames); %seta maximo
set(handles.sliderti,'Value',1); %seta valor inicial
set(handles.slidertf,'Value',handles.video.NumberOfFrames); %seta valor inicial

handles.valsliti = round(get(handles.sliderti,'Value'));
handles.valslitf = round(get(handles.slidertf,'Value'));

set(handles.sliderti,'Value',handles.valsliti);
set(handles.slidertf,'Value',handles.valslitf);
set(handles.tfimmin,'String',num2str(floor(handles.valslitf/(handles.frameRate*60))));
set(handles.tfimseg,'String',num2str(floor(handles.valslitf/(handles.frameRate) - 60*floor(handles.valslitf/(handles.frameRate*60)))));

%set(handles.qini,'String','1'); 
set(handles.tinimin,'String','0')
set(handles.tiniseg,'String','0')
%set(handles.qfim,'String',num2str(handles.video.NumberOfFrames));
%set(handles.tfimmin,'String',num2str(floor(handles.video.Duration/60)));
%set(handles.tfimseg,'String',num2str( floor( handles.video.Duration -  floor(handles.video.Duration/60)*60 )));


handles.frameini = floor((str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1);
handles.framefim = floor((str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate);

%disp(['frame fim ' num2str(handles.framefim)])

%if handles.framefim > handles.video.NumberOfFrames
%    handles.framefim = handles.video.NumberOfFrames - handles.frameRate;
%end


try
    fundo = imread([handles.directoryname,'/',filenameSemExtensao,'.jpeg']);
    load([handles.directoryname,'/', filenameSemExtensao,'V.mat']);
catch
    %se nao tem, cria
    %ajusta a quantidade de iamgens utilizadas de acordo com a duração do
    %video
    set(handles.fundoframe,'String',num2str(round(handles.video.NumberOfFrames*0.004)));
    p = imread('processando.jpeg');
    axes(handles.axes3);
    imshow(p);
    drawnow;
    %[fundo,V] = criafundo(handles.directoryname,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')));
    handles.waibarfundo.visivel('on');
    [fundo,V] = criafundo(handles.directoryname,handles.filenameSemExtensao,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')),handles.waibarfundo);
end

[l,c,~]=size(fundo);
handles.c = c;
handles.l = l;
handles.fundo = fundo;
handles.V = V;
axes(handles.axes3);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);
axes(handles.axes4);
hold off
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
handles.waibarfundo.setvalue(0);
handles.waibarfundo.visivel('off');

%area de processamento na imagem toda
handles.areaproc.x(1) = 1;
handles.areaproc.y(1) = 1;
handles.areaproc.x(2) = handles.c;
handles.areaproc.y(2) = 1;
handles.areaproc.x(3) = handles.c;
handles.areaproc.y(3) = handles.l;
handles.areaproc.x(4) = 1;
handles.areaproc.y(4) = handles.l;
handles.areaproc.x(5) = 1;
handles.areaproc.y(5) = 1;
    
guidata(hObject, handles);

visualizar_Callback(hObject, eventdata, guidata(hObject))

handles=guidata(hObject);

% Set the processing complete flag to true
handles.processingComplete = true;

guidata(hObject,handles);
end


function npeixes_Callback(hObject, eventdata, handles)
% hObject    handle to npeixes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npeixes as text
%        str2double(get(hObject,'String')) returns contents of npeixes as a double

end
% --- Executes during object creation, after setting all properties.

function npeixes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npeixes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function pxcmx_Callback(hObject, eventdata, handles)
% hObject    handle to pxcmx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxcmx as text
%        str2double(get(hObject,'String')) returns contents of pxcmx as a double

end
% --- Executes during object creation, after setting all properties.

function pxcmx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxcmx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function pxcmy_Callback(hObject, eventdata, handles)
% hObject    handle to pxcmy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxcmy as text
%        str2double(get(hObject,'String')) returns contents of pxcmy as a double
end
% --- Executes during object creation, after setting all properties.

function pxcmy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxcmy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function procframe_Callback(hObject, eventdata, handles)
% hObject    handle to procframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of procframe as text
%        str2double(get(hObject,'String')) returns contents of procframe as a double
end
% --- Executes during object creation, after setting all properties.


function procframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to procframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggleTooltips(handles.figure1,'off'); 
visu = 1;
if ~handles.live
    handles.frameini = floor((str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1);
        handles.framefim = floor((str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate);
end
fini = handles.frameini;
%disp(fini);
ffim = handles.framefim;
%disp(ffim);
np = str2double(get(handles.npeixes,'String'));
pxcm.x = str2double(get(handles.pxcmx,'String')); 
pxcm.y = str2double(get(handles.pxcmy,'String')); 
if ~handles.live
    procf = str2double(get(handles.procframe,'String')); 
else
    procf=1;
end
criavideores = get(handles.resvideo,'Value'); 
mostradiff = get(handles.checkbox2,'Value');
tipsubfundo = get(handles.radiosfe,'Value');
thresh = round(get(handles.slider3,'Value'));
filt = get(handles.slider4,'Value');
tipfilt = get(handles.radiofk,'Value');
fundodina = get(handles.fundodinamico,'Value');
subcor = get(handles.subtracaocolorida,'Value');
velmin = str2double(get(handles.vminima,'String')); 
tempmin = str2double(get(handles.tminparado,'String')); 
tempminparado = str2double(get(handles.tmindormindo,'String'));
camlent = str2double(get(handles.cameralenta,'String'));
trackmouse = get(handles.trackmouse,'Value');
liveTracking = handles.live;
trackindividuals = get(handles.checkboxTrack_Ind,'Value'); 
if trackindividuals 
    try
        centroids = handles.centroids;
        cov_matrices = handles.cov_matrices;
    catch
        msgbox('Generate Feature Dataset First! ','Erro','error');
        return;
    end
else
    centroids = [];
    cov_matrices = [];
end
actions.nactions = handles.nactions;
if actions.nactions > 0
    ind = get(handles.serialports,'Value');
    str = get(handles.serialports,'String');
    tmp = str(ind);
    actions.serialport = tmp{1};
    
    ind = get(handles.popupmenu2,'Value');
    str = get(handles.popupmenu2,'String');
    tmp = str(ind);
    actions.serialspeed = str2num(tmp{1});
    
    for i = 1:actions.nactions
        eval(['actions.condition(i) = get(handles.popupmenu' num2str(3*i) ',''Value'');']);
        eval(['actions.area(i) = get(handles.popupmenu' num2str(3*i+1) ',''Value'');']);
        eval(['actions.command(i) = get(handles.popupmenu' num2str(3*i+2) ',''Value'');']);
    end
end

set(handles.run,'Visible','off');
set(handles.abortar,'Visible','on');
set(handles.pause,'Enable','on');
handles.waibar.setvalue(0);
global abort;
abort = 0;
global pausar;
pausar = 0;
set(handles.pause,'Enable','on');
global nulitimospontos;
nulitimospontos = str2double(get(handles.rastro,'String'));
set(handles.mensagem,'String','If the tracking process looses the animal, click on it to help its detection');
set(handles.mensagem,'Visible','on');
global px;
global py;

if trackmouse
    set(handles.figure1,'WindowButtonMotionFcn', @trackmousemovment);
end

if get(handles.splitexperiment,'Value')
    splitframe = str2double(get(handles.splittime,'String'))*handles.frameRate;
    set(handles.expnumber,'Visible','on');
    handles.e(1).areaproc = handles.areaproc;
    handles.e(1).pxcm = pxcm;
    handles.e(1).figdimensions.l = handles.l;
    handles.e(1).figdimensions.c = handles.c;
    handles.e(1).directory = handles.directoryname;
    handles.e(1).filename = handles.filenameSemExtensao;
    handles.e(1).areaint = handles.areaint;
    
    for i = 1:ceil((ffim - fini) / splitframe)
        set(handles.expnumber,'String',['Experiment number ' num2str(i) ' of ' num2str(ceil((ffim - fini) / splitframe))]);
        finitemp = fini + (i - 1) * splitframe;
        ffimtemp = min(fini + (i) * splitframe, ffim);
        handles.frameini = finitemp;
        handles.framefim = ffimtemp;
        guidata(hObject, handles);
        if i == 1
            
            [handles.e(i).t, handles.e(i).posicao, handles.e(i).velocidade, handles.e(i).parado, handles.e(i).dormindo, handles.e(i).tempoareas, handles.e(i).distperc, handles.e(i).comportamento] = ...
            track(visu, finitemp, ffimtemp, handles.directoryname, handles.video, pxcm, np, procf, handles.areaproc, handles.areaint, handles.areaexc, criavideores, mostradiff, thresh, filt, handles, fundodina, tipfilt, tipsubfundo, velmin, tempmin, tempminparado, subcor, camlent, trackmouse, liveTracking, trackindividuals, centroids, cov_matrices, actions);
        else
            
            pinicial.x(:,1) = px(:,end);
            pinicial.y(:,1) = py(:,end);
            [handles.e(i).t, handles.e(i).posicao, handles.e(i).velocidade, handles.e(i).parado, handles.e(i).dormindo, handles.e(i).tempoareas, handles.e(i).distperc, handles.e(i).comportamento] = ...
            track(visu, finitemp, ffimtemp, handles.directoryname, handles.video, pxcm, np, procf, handles.areaproc, handles.areaint, handles.areaexc, criavideores, mostradiff, thresh, filt, handles, fundodina, tipfilt, tipsubfundo, velmin, tempmin, tempminparado, subcor, camlent, trackmouse, liveTracking, trackindividuals, centroids, cov_matrices, actions);
        end
        
        if abort
            break;
        end
    end
    
else
    
    if isfield(handles, 'csvPositionData')
    csvPositionData = handles.csvPositionData;
    else
    csvPositionData = [];
    end
    pinicial = struct();
    [handles.e.t, handles.e.posicao, handles.e.velocidade, handles.e.parado, handles.e.dormindo, handles.e.tempoareas, handles.e.distperc, handles.e.comportamento, handles.e.parado_area, handles.e.contparado_area] = ...
    track(visu, fini, ffim, handles.directoryname, handles.video, pxcm, np, procf, handles.areaproc, handles.areaint, handles.areaexc, criavideores, mostradiff, thresh, filt, handles, fundodina, tipfilt, tipsubfundo, velmin, tempmin, tempminparado, subcor, camlent, trackmouse, liveTracking, trackindividuals, centroids, cov_matrices, actions, pinicial, csvPositionData);

    handles.e.areaproc = handles.areaproc;
    handles.e.pxcm = pxcm;
    handles.e.figdimensions.l = handles.l;
    handles.e.figdimensions.c = handles.c;
    handles.e.directory = handles.directoryname;
    handles.e.areaint = handles.areaint;
    handles.e.filename = handles.filenameSemExtensao;
    
end

try 
    load aleluia
    sound(aleluia)
catch
end

set(handles.expnumber,'Visible','off');
set(handles.figure1,'WindowButtonMotionFcn', '');
set(handles.run,'Enable','on');
set(handles.run,'Visible','on');
set(handles.abortar,'Visible','off');
set(handles.saveres,'Enable','on');
set(handles.splitres,'Enable','on');
set(handles.saveresexcel,'Enable','on');
set(handles.saveresword,'Enable','on');
set(handles.selrepitems,'Enable','on');
set(handles.viewrep,'Enable','on');
toggleTooltips(handles.figure1,'on'); 
set(handles.pause,'Enable','off');

e = handles.e;
save(fullfile(handles.directoryname, [handles.filenameSemExtensao '.mat']), 'e');
set(handles.mensagem,'String',['Result automatically saved to "' handles.filenameSemExtensao '.mat"']);

saveresword_Callback(hObject, eventdata, handles);

saveresexcel_Callback(hObject, eventdata, handles);

guidata(hObject, handles);
end

% --- Executes on button press in csvPositionDataButton.
function csvPositionDataButton_Callback(hObject, eventdata, handles)
    % hObject    handle to csvPositionDataButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    handles.processingComplete3 = false;
    % Verificar se os dados de posição já estão nos handles
    if isfield(handles, 'csv_position_data_path') && ~isempty(handles.csv_position_data_path)
        % Utilizar o caminho armazenado nos handles
        fullpath = handles.csv_position_data_path;
    else
        % Abrir a janela de seleção de arquivo
        [file, path] = uigetfile('*.csv', 'Select CSV file with Position Data');
        if isequal(file, 0)
            disp('User selected Cancel');
            return;
        else
            fullpath = fullfile(path, file);
            % Armazenar o caminho no handles para uso futuro
            handles.csv_position_data_path = fullpath;
            guidata(hObject, handles); % Atualizar os handles
        end
    end

    % Ler o arquivo CSV de dados de posição
    csvPositionData = readtable(fullpath);
    
    % Guardar os dados no handles
    handles.csvPositionData = csvPositionData;

    % Calcular os intervalos entre os frames
    frame_numbers = csvPositionData.frame;
    frame_intervals = diff(frame_numbers);

    % Calcular a média dos intervalos
    processing_rate = mean(frame_intervals);

    % Definir o valor de Processing Rate no handles
    processing_rate_int = round(processing_rate);
    proc_r = num2str(processing_rate_int);
    set(handles.procframe, 'String', proc_r);
    handles.processingComplete3 = true;
    % Atualiza a estrutura handles
    guidata(hObject, handles);

    % Chamar a função run_Callback diretamente para iniciar o processamento
    run_Callback(hObject, eventdata, handles);
end



function apxi_Callback(hObject, eventdata, handles)
% hObject    handle to apxi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apxi as text
%        str2double(get(hObject,'String')) returns contents of apxi as a double
end
% --- Executes during object creation, after setting all properties.

function apxi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apxi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function apxf_Callback(hObject, eventdata, handles)
% hObject    handle to apxf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of apxf as text
%        str2double(get(hObject,'String')) returns contents of apxf as a double
end
% --- Executes during object creation, after setting all properties.

function apxf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apxf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function apyi_Callback(hObject, eventdata, handles)
% hObject    handle to apyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apyi as text
%        str2double(get(hObject,'String')) returns contents of apyi as a double
end
% --- Executes during object creation, after setting all properties.

function apyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function apyf_Callback(hObject, eventdata, handles)
% hObject    handle to apyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apyf as text
%        str2double(get(hObject,'String')) returns contents of apyf as a double
end
% --- Executes during object creation, after setting all properties.

function apyf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function aixi_Callback(hObject, eventdata, handles)
% hObject    handle to aixi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aixi as text
%        str2double(get(hObject,'String')) returns contents of aixi as a double
end
% --- Executes during object creation, after setting all properties.

function aixi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aixi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function aixf_Callback(hObject, eventdata, handles)
% hObject    handle to aixf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aixf as text
%        str2double(get(hObject,'String')) returns contents of aixf as a double
end
% --- Executes during object creation, after setting all properties.

function aixf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aixf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function aiyi_Callback(hObject, eventdata, handles)
% hObject    handle to aiyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aiyi as text
%        str2double(get(hObject,'String')) returns contents of aiyi as a double
end
% --- Executes during object creation, after setting all properties.

function aiyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aiyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function aiyf_Callback(hObject, eventdata, handles)
% hObject    handle to aiyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aiyf as text
%        str2double(get(hObject,'String')) returns contents of aiyf as a double
end
% --- Executes during object creation, after setting all properties.

function aiyf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aiyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btareaintlimpar.
function btareaintlimpar_Callback(hObject, eventdata, handles)
% hObject    handle to btareaintlimpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = length(handles.areaint);
if t == 1
    handles.areaint = [];
else
    handles.areaint = handles.areaint(1:end-1);
end
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on

desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);


guidata(hObject, handles);

end
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.e(1).report = false;
handles.e(1).basicinfo = get(handles.basicinfo,'Value');
handles.e(1).animalplot = get(handles.animalplot,'Value');
handles.e(1).areainfo = get(handles.areainfo,'Value');
handles.e(1).behaviourinfo = get(handles.behaviourinfo,'Value');
handles.e(1).fouriertransf = get(handles.fouriertransf,'Value');
handles.e(1).distpointinfo = get(handles.distpointinfo,'Value');
handles.e(1).distlineinfo = get(handles.distlineinfo,'Value');
handles.e(1).animalplot3D = get(handles.animalplot3D,'Value');
handles.e(1).backgplot = get(handles.backgplot,'Value');
handles.e(1).angularvelocity = get(handles.angularvelocity,'Value');
handles.e(1).angularvelocitythreshold = get(handles.angvelthres,'Value');
handles.e(1).heat_map = get(handles.HeatMap,'Value');
handles.e(1).areasequence = get(handles.areasequence,'Value');
handles.e(1).groupInfo = false;
handles.e(1).groupInfoVsanimalOne = false;
guidata(hObject, handles);
% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'),'waiting')
    uiresume(hObject)
else
    delete(hObject);
end

end

function fundoframe_Callback(hObject, eventdata, handles)
% hObject    handle to fundoframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fundoframe as text
%        str2double(get(hObject,'String')) returns contents of fundoframe as a double
end
% --- Executes during object creation, after setting all properties.

function fundoframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fundoframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function trest_Callback(hObject, eventdata, handles)
% hObject    handle to trest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trest as text
%        str2double(get(hObject,'String')) returns contents of trest as a double
end
% --- Executes during object creation, after setting all properties.
function trest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
end


function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double
set(handles.slider3,'Value',str2double(get(handles.threshold,'String')));
end
% --- Executes during object creation, after setting all properties.

function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.threshold,'String',num2str(round(get(handles.slider3,'Value'))));
guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.

function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.filtragem,'String',num2str(get(handles.slider4,'Value')));
guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.

function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


function filtragem_Callback(hObject, eventdata, handles)
% hObject    handle to filtragem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtragem as text
%        str2double(get(hObject,'String')) returns contents of filtragem as a double
set(handles.slider4,'Value',str2double(get(handles.filtragem,'String')));
end
% --- Executes during object creation, after setting all properties.

function filtragem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtragem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function tgasto_Callback(hObject, eventdata, handles)
% hObject    handle to tgasto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tgasto as text
%        str2double(get(hObject,'String')) returns contents of tgasto as a double
end
% --- Executes during object creation, after setting all properties.

function tgasto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tgasto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --------------------------------------------------------------------
function arquivo_Callback(hObject, eventdata, handles)
% hObject    handle to arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --------------------------------------------------------------------

function salvar_Callback(hObject, eventdata, handles)
% hObject    handle to salvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v1 = handles.directoryname;
v2 = get(handles.tinimin,'String');
v3 = get(handles.tfimmin,'String');
v4 = get(handles.npeixes,'String');
v5 = get(handles.pxcmx,'String');
v6 = get(handles.pxcmy,'String');
v7 = get(handles.procframe,'String');
v8 = round(get(handles.slider3,'Value'));
v9 = get(handles.slider4,'Value');
v10 = handles.areaproc;
v11 = handles.areaint;
v12 = get(handles.fundodinamico,'Value');
v13 = get(handles.radiofpb,'Value');
v14 = handles.areaexc;
v15 = get(handles.tiniseg,'String');
v16 = get(handles.tfimseg,'String');
v17 = handles.filename;
v18 = get(handles.radiosfe,'Value');
v19 = get(handles.vminima,'String');
v20 = get(handles.tminparado,'String');
v21 = get(handles.tmindormindo,'String');
v22 = get(handles.rastro,'String');
v23 = get(handles.cameralenta,'String');
v24 = get(handles.trackmouse,'Value');
v25 = get(handles.resvideo,'Value');
v26 = get(handles.thresholdadaptativo,'Value');
v27 = get(handles.splitexperiment,'Value');
v28 = get(handles.splittime,'String');

uisave({'v1','v2','v3','v4','v5','v6','v7','v8','v9','v10','v11','v12','v13','v14','v15','v16','v17','v18','v19','v20','v21','v22','v23','v24','v25','v26','v27','v28'},'conf');
end
% --------------------------------------------------------------------

function carregar_Callback(hObject, eventdata, handles)
% hObject    handle to carregar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen
if ~exist('v1','var')
    msgbox('Invalid configuration file!','Erro','error'); 
    return
end
handles.directoryname = v1;
handles.filename = v17;

%le o video na memoria
handles.video = VideoReader([handles.directoryname,handles.filename]);
set(handles.pasta,'String',fullfile(handles.directoryname, handles.filename));

set(handles.tinimin,'String',v2);
set(handles.tfimmin,'String',v3);
set(handles.tiniseg,'String',v15);
set(handles.tfimseg,'String',v16);

set(handles.npeixes,'String',v4);
set(handles.pxcmx,'String',v5);
set(handles.pxcmy,'String',v6);
set(handles.procframe,'String',v7);
set(handles.slider3,'Value',v8);
set(handles.threshold,'String',num2str(v8));
set(handles.slider4,'Value',v9);
set(handles.filtragem,'String',num2str(v9));


handles.areaproc = v10;
handles.areaint = v11;
handles.areaexc = v14;
if exist('v12','var')
    set(handles.fundodinamico,'Value',v12);
end
if exist('v13','var')
    set(handles.radiofpb,'Value',v13)
    set(handles.radiofk,'Value',~v13)
end

if exist('v18','var')
    set(handles.radiosfe,'Value',v13)
    set(handles.radiosfb,'Value',~v13)
end



if exist('v19','var') %se existe 19, tem ate a 28
    set(handles.vminima,'String',v19);
    set(handles.tminparado,'String',v20);
    set(handles.tmindormindo,'String',v21);
    set(handles.rastro,'String',v22);
    set(handles.cameralenta,'String',v23);
    set(handles.trackmouse,'Value',v24);
    set(handles.resvideo,'Value',v25);
    set(handles.thresholdadaptativo,'Value',v26);
    global threshadaptativo;
    threshadaptativo = get(handles.thresholdadaptativo,'Value');
    set(handles.splitexperiment,'Value',v27);
    set(handles.splittime,'String',v28);
end
    
%barras de roalgem do video
    set(handles.sliderti,'Min',1);
    set(handles.slidertf,'Min',handles.frameRate);
    set(handles.sliderti,'Max',handles.video.NumberOfFrames - handles.frameRate); %seta maximo
    set(handles.slidertf,'Max',handles.video.NumberOfFrames); %seta maximo
      
    handles.frameini = (str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1;
    handles.framefim = (str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate;

try
    fundo = imread([handles.directoryname,'/fundo.jpeg']);
    load([handles.directoryname,'/V.mat']);
catch
    %se nao tem, cria
    %ajusta a quantidade de iamgens utilizadas de acordo com a duraÃ§Ã£o do
    %video
    set(handles.fundoframe,'String',num2str(round(handles.video.NumberOfFrames*0.004)));
    p = imread('processando.jpeg');
    axes(handles.axes3);
    imshow(p);
    drawnow;
    %[fundo,V] = criafundo(handles.directoryname,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')));
    handles.waibarfundo.visivel('on');
    [fundo,V] = criafundo(handles.directoryname,handles.video,handles.frameini,handles.framefim,str2double(get(handles.fundoframe,'String')),handles.waibarfundo);
end

[l,c,~]=size(fundo);
handles.c = c;
handles.l = l;
handles.fundo = fundo;
handles.V = V;
handles.waibarfundo.setvalue(0);
handles.waibarfundo.visivel('off');
axes(handles.axes3);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);

guidata(hObject, handles);

visualizar_Callback(hObject, eventdata, guidata(hObject))

guidata(hObject, handles);

handles=guidata(hObject);
guidata(hObject,handles);

end

% --------------------------------------------------------------------
function ajuda_Callback(hObject, eventdata, handles)
% hObject    handle to ajuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --------------------------------------------------------------------

function sair_Callback(hObject, eventdata, handles)
% hObject    handle to sair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

end
% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exportfigs

end
% --- Executes on button press in abortar.
function abortar_Callback(hObject, eventdata, handles)
% hObject    handle to abortar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global abort
abort = 1;

end
function trackmousemovment(hObject, eventdata, handles)
handles = guidata(hObject);
pos=get(handles.axes4,'CurrentPoint');
pos = pos(1,1:2);
global pmousex;
global pmousey;
if pos(1)>1 && pos(1)<handles.c && pos(2)>1 && pos(2)<handles.l

      pmousex = pos(1);
      pmousey = pos(2);
else
      pmousex = -1;
      pmousey = -1;
end
end
function axes4_ButtonMotionFcn(hObject, eventdata, handles)
handles = guidata(hObject);
pos=get(handles.axes4,'CurrentPoint');
pos = pos(1,1:2);



if pos(1)>1 && pos(1)<handles.c && pos(2)>1 && pos(2)<handles.l
    
    axes(handles.axes4)
    hold off
    fundohandle = imshow(handles.fundo);
    set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
    
    set(handles.posicaomouse,'String',strcat( '(', num2str(floor(pos(1)-handles.clickini(1))), ',', num2str(floor(pos(2)-handles.clickini(2))) ,')' ));
    set(handles.posicaomouse2,'String',strcat( '(', num2str(round(pos(1))), ',', num2str(round(pos(2))) ,')' ));

    hold on
    if handles.definirapc == 1 || handles.definirapc == 3 || handles.definirapc == 10
        desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
        desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
        desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);

    end
    if handles.definirapc == 2  %area processamento
        handles.areaproc.x(handles.nvertice) = round(pos(1));
        handles.areaproc.y(handles.nvertice) = round(pos(2));
        handles.areaproc.x(handles.nvertice+1) = handles.areaproc.x(1);
        handles.areaproc.y(handles.nvertice+1) = handles.areaproc.y(1);
        desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);

    end
    if handles.definirapc == 4  %area de interesse
        desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
        desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);

        n = length(handles.areaint);
        handles.areaint(n).x(handles.nvertice) = round(pos(1));
        handles.areaint(n).y(handles.nvertice) = round(pos(2));
        handles.areaint(n).x(handles.nvertice+1) = handles.areaint(n).x(1);
        handles.areaint(n).y(handles.nvertice+1) = handles.areaint(n).y(1);
        desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);

    end

    if handles.definirapc == 11  %area deexclusao
        desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);

        desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);    

        n = length(handles.areaexc);
        handles.areaexc(n).x(handles.nvertice) = round(pos(1));
        handles.areaexc(n).y(handles.nvertice) = round(pos(2));
        handles.areaexc(n).x(handles.nvertice+1) = handles.areaexc(n).x(1);
        handles.areaexc(n).y(handles.nvertice+1) = handles.areaexc(n).y(1);
        desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);

    end

    if handles.definirapc == 16 %linha
        lhandle = line([handles.e(1).distlineini.x,pos(1)],[handles.e(1).distlineini.y,pos(2)],'Color','y');
        set(lhandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
    end

    set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
    if handles.definirapc == 13 %modificacao de posicao
        hold off
        imhandle = imshow(handles.framep);
        set(imhandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
        hold on
        %desenha bolinha na posicao atual do mouse
        vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];
        bhandle = plot(pos(1),pos(2),'o','Color',vcores(mod(handles.animalclicado,7)+1,:));
        set(bhandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
    end

end
guidata(hObject,handles);
end
% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if length(handles.areaproc) == 0 %nao tem imagem carregada
    set(handles.mensagem,'String','Error! Before difingin the area, click on "Visualize"!');
    return;
end
axesHandle  = get(hObject,'Parent');
pos=get(axesHandle,'CurrentPoint');
pos = pos(1,1:2);

%garante que o ponto esta dentro da imagem
pos(1) = min(pos(1),handles.c);
pos(2) = min(pos(2),handles.l);

handles.clickini = pos;

if handles.definirapc == 1 %ponto inicial da area de processamento
    
        handles.areaproc.x(handles.nvertice) = round(pos(1));
        handles.areaproc.y(handles.nvertice) = round(pos(2));
        handles.nvertice = handles.nvertice + 1;
        set(handles.apxi,'String',num2str(round(pos(1))));
        set(handles.apyi,'String',num2str(round(pos(2))));
       handles.definirapc = 2; 
       set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
       
else
    if handles.definirapc == 2  %ponto 2 em diante
        
        switch get(gcf,'SelectionType')
          case 'normal' % Click left mouse button. add vertex
           handles.areaproc.x(handles.nvertice) = round(pos(1));
            handles.areaproc.y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            set(handles.apxi,'String',num2str(round(pos(1))));
            set(handles.apyi,'String',num2str(round(pos(2))));
          case 'open'   % Double-click any mouse button.  add last vertex  
            handles.areaproc.x(handles.nvertice) = round(pos(1));
            handles.areaproc.y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            handles.areaproc.x(handles.nvertice)=handles.areaproc.x(1);
            handles.areaproc.y(handles.nvertice)=handles.areaproc.y(1);
            set(handles.apxi,'String',num2str(round(pos(1))));
            set(handles.apyi,'String',num2str(round(pos(2))));
            handles.definirapc = 0;
            set(handles.mensagem,'Visible','off');
            set(handles.figure1,'WindowButtonMotionFcn','');
            set(handles.posicaomouse,'Visible','off');
            set(handles.posicaomouse2,'Visible','off');
            set(handles.areaprocaddvert,'Enable','off');
            %plota na figura
            axes(handles.axes4)
            hold off
            fundohandle = imshow(handles.fundo);
            set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
            hold on
            desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
            desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);    
            desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
      
        end
             
    end
end

if handles.definirapc == 3  %ponto inicial da area de interesse
    n = length(handles.areaint) + 1;
    handles.areaint(n).x(handles.nvertice) = round(pos(1));
    handles.areaint(n).y(handles.nvertice) = round(pos(2));
    handles.nvertice = handles.nvertice + 1;
    set(handles.aixi,'String',num2str(round(pos(1))));
    set(handles.aiyi,'String',num2str(round(pos(2))));
   handles.definirapc = 4; 
   set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
   set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
else
    if handles.definirapc == 4  %ponto final da area de interesse
        
        n = length(handles.areaint);
        switch get(gcf,'SelectionType')
          case 'normal' % Click left mouse button.
           
            handles.areaint(n).x(handles.nvertice) = round(pos(1));
            handles.areaint(n).y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            set(handles.aixi,'String',num2str(round(pos(1))));
            set(handles.aiyi,'String',num2str(round(pos(2))));
  
           case 'open'   % Double-click any mouse button.    
            handles.areaint(n).x(handles.nvertice) = round(pos(1));
            handles.areaint(n).y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            handles.areaint(n).x(handles.nvertice)=handles.areaint(n).x(1);
            handles.areaint(n).y(handles.nvertice)=handles.areaint(n).y(1);
            set(handles.aixi,'String',num2str(round(pos(1))));
            set(handles.aiyi,'String',num2str(round(pos(2))));
            handles.definirapc = 0; 
            set(handles.mensagem,'Visible','off');
            set(handles.posicaomouse,'Visible','off');
            set(handles.posicaomouse2,'Visible','off');
            set(handles.areaintaddvert,'Enable','off');
        set(handles.areaintfinish,'Enable','off');
            set(handles.figure1,'WindowButtonMotionFcn','');
            %plota na figura
            axes(handles.axes4)
            hold off
            fundohandle = imshow(handles.fundo);
            set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
            hold on
            desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
            desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);    
            desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
               
        end
        
    end
end

if handles.definirapc == 5  %ponto inicial da calibracao pixel/cm
    handles.dim1p1 = round(pos);
    set(handles.mensagem,'String','Click on the end point of the object in dimension 1:');
    handles.definirapc = 6;
else
   if  handles.definirapc == 6
        handles.dim1p2 = round(pos);
        linehandle = line([handles.dim1p1(1) handles.dim1p2(1)],[handles.dim1p1(2) handles.dim1p2(2)],'Color','y');
        set(linehandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
        handles.definirapc = 7;
        dimensao = inputdlg('Length, in centimeters, in dimension 1;','Dimensions of the object');
        handles.dim1cm = str2double(dimensao{:});
        axes(handles.axes4);

        set(handles.mensagem,'String','Click on the starting point of the object in dimension 2:');
        handles.clickini = [0 0];
   else
       if handles.definirapc == 7
            handles.dim2p1 = round(pos);
            set(handles.mensagem,'String','Click on the end point of the object in dimension 2:');
            handles.definirapc = 8;
       else
           if  handles.definirapc == 8
                handles.dim2p2 = round(pos);
                linehandle = line([handles.dim2p1(1) handles.dim2p2(1)],[handles.dim2p1(2) handles.dim2p2(2)],'Color','y');
                set(linehandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
                handles.definirapc = 0;
                dimensao = inputdlg('Length, in centimeters, in dimension 2;','Dimensions of the object');
                handles.dim2cm = str2double(dimensao{:});
                set(handles.mensagem,'Visible','off');
                [pxcmx,pxcmy] = calculapixelcm(handles.dim1p1,handles.dim1p2,handles.dim2p1,handles.dim2p2,handles.dim1cm,handles.dim2cm);
                set(handles.pxcmx,'String',num2str(pxcmx));
                set(handles.pxcmy,'String',num2str(pxcmy));
                set(handles.posicaomouse,'Visible','off');
                set(handles.posicaomouse2,'Visible','off');
           end
       end
   end
end


if handles.definirapc == 10  %ponto inicial da area de exclusao
   
    n = length(handles.areaexc) + 1;
    handles.areaexc(n).x(handles.nvertice) = round(pos(1));
    handles.areaexc(n).y(handles.nvertice) = round(pos(2));
    handles.nvertice = handles.nvertice + 1;
    set(handles.aexi,'String',num2str(round(pos(1))));
    set(handles.aeyi,'String',num2str(round(pos(2))));
   handles.definirapc = 11; 
   set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
   set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
else
    if handles.definirapc == 11  %ponto final da area de exclusao
        n = length(handles.areaexc);
        
         switch get(gcf,'SelectionType')
          case 'normal' % Click left mouse button.
           
            handles.areaexc(n).x(handles.nvertice) = round(pos(1));
            handles.areaexc(n).y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            set(handles.aexi,'String',num2str(round(pos(1))));
            set(handles.aeyi,'String',num2str(round(pos(2))));
  
           case 'open'   % Double-click any mouse button.    
            handles.areaexc(n).x(handles.nvertice) = round(pos(1));
            handles.areaexc(n).y(handles.nvertice) = round(pos(2));
            handles.nvertice = handles.nvertice + 1;
            handles.areaexc(n).x(handles.nvertice)=handles.areaexc(n).x(1);
            handles.areaexc(n).y(handles.nvertice)=handles.areaexc(n).y(1);
            handles.definirapc = 0; 
            set(handles.mensagem,'Visible','off');
            set(handles.posicaomouse,'Visible','off');
            set(handles.posicaomouse2,'Visible','off');
            set(handles.areaexcaddvert,'Enable','off');
            set(handles.areaexcfinish,'Enable','off');
            set(handles.figure1,'WindowButtonMotionFcn','');
            %plota na figura
            axes(handles.axes4)
            hold off
            fundohandle = imshow(handles.fundo);
            set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
            hold on
            desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
            desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);    
            desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
         end
    end
end

if handles.definirapc == 12
    %checar se clicou perto da posicao de algum peixe no frame atual
    global cont;
    global px;
    global py;
    %disp('vai mudar posicao do peixe antiga')
    handles.animalclicado = 0;
    for j=1:str2double(get(handles.npeixes,'String'))
        dist = sqrt( (pos(1)- px(j,cont+handles.avanco))^2 + (pos(2)- py(j,cont+handles.avanco))^2 );
        if dist < 10
            handles.animalclicado = j;
            handles.definirapc = 13;
            set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
            set(handles.mensagem,'String','Click on the new desired position');
        end
    end
else
    if handles.definirapc == 13 %mudando posicao que foi clicada
        global cont;
        global px;
        global py;
        px( handles.animalclicado,cont+handles.avanco) = pos(1);
        py( handles.animalclicado,cont+handles.avanco) = pos(2);
        set(handles.figure1,'WindowButtonMotionFcn', '');
        set(handles.mensagem,'String','Click on the detected position to change it');
        handles.definirapc = 12;
        %plota os animais
        vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];
        for j=1:str2double(get(handles.npeixes,'String'))
            phandle = plot(px(j,cont+handles.avanco),py(j,cont+handles.avanco),'o','Color',vcores(mod(j,7)+1,:));
            set(phandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
        end
    end
end

if handles.definirapc == 14 %distancia para um ponto
    
   handles.e(1).distpoint.x =  pos(1);
   handles.e(1).distpoint.y =  pos(2);
   set(handles.mensagem,'String','Point successfully added');
   set(handles.posicaomouse,'Visible','off');
   set(handles.posicaomouse2,'Visible','off');
   set(handles.figure1,'WindowButtonMotionFcn','');
   set(handles.distpointinfo,'Value',true);
   handles.definirapc = 0; 
   plot(pos(1),pos(2),'ro');
end

if handles.definirapc == 15 %criando linha pra calcular distancia
    
   handles.e(1).distlineini.x =  pos(1);
   handles.e(1).distlineini.y =  pos(2);
   set(handles.mensagem,'String','Click on the second point of the line');
   handles.definirapc = 16; 
else
    if handles.definirapc == 16
    
       handles.e(1).distlinefim.x =  pos(1);
       handles.e(1).distlinefim.y =  pos(2);
       set(handles.mensagem,'String','Line successfully added');
       set(handles.posicaomouse,'Visible','off');
       set(handles.posicaomouse2,'Visible','off');
       set(handles.figure1,'WindowButtonMotionFcn','');
       set(handles.distlineinfo,'Value',true);
       handles.definirapc = 0; 
    end
end

if handles.definirapc == 17  %criacao de grid de areas de interesse
    handles.inigrid = round(pos);
    set(handles.mensagem,'String','Click on the end point of the grid (rigth bottom corner):');
    handles.definirapc = 18;
else
   if  handles.definirapc == 18
        handles.fimgrid = round(pos);
        nlinhas = inputdlg('Number of lines;','Grid Dimensions');
        nlinhas = str2double(nlinhas{:});
        ncolunas = inputdlg('Number of columns;','Grid Dimensions');
        ncolunas = str2double(ncolunas{:});

        %criar as nlinhas x ncolunas areas (se ja existir uma área, antiga,
        %deixa ela lá. se depois o usuario quiser adicinar mais areas,
        %tambem pode)
        n = length(handles.areaint);
        hx = abs(handles.fimgrid(1) - handles.inigrid(1))/ncolunas;
        hy = abs(handles.fimgrid(2) - handles.inigrid(2))/nlinhas; %lembrando que a origem do y fica em cima
        for l = 1:nlinhas
            for c = 1:ncolunas
                n = n + 1;
                %cria os 5 vertices (repete o ultimo)              
                handles.areaint(n).x(1) = round(min(handles.inigrid(1),handles.fimgrid(1)) + (c-1)*hx);
                handles.areaint(n).y(1) = round(min(handles.inigrid(2),handles.fimgrid(2)) + (l-1)*hy);
                
                handles.areaint(n).x(2) = round(handles.areaint(n).x(1) + hx) ;
                handles.areaint(n).y(2) = handles.areaint(n).y(1);
                
                handles.areaint(n).x(3) = handles.areaint(n).x(2);
                handles.areaint(n).y(3) = round(handles.areaint(n).y(2) + hy);
                
                handles.areaint(n).x(4) = handles.areaint(n).x(1) ;
                handles.areaint(n).y(4) = handles.areaint(n).y(3);
                
                handles.areaint(n).x(5) = handles.areaint(n).x(1) ;
                handles.areaint(n).y(5) = handles.areaint(n).y(1) ;
            end
        end
        handles.definirapc = 0;
        set(handles.mensagem,'Visible','off');
        set(handles.posicaomouse,'Visible','off');
        set(handles.posicaomouse2,'Visible','off');
        set(handles.figure1,'WindowButtonMotionFcn','');
        %plota na figura
        axes(handles.axes4)
        hold off
        fundohandle = imshow(handles.fundo);
        set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
        hold on
        desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
        desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);    
        desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
   end
end
   
% Update handles structure
guidata(axesHandle, handles);
end
function [pxcmx, pxcmy] = calculapixelcm(d1p1, d1p2, d2p1, d2p2, d1cm, d2cm)

pesopxcmxd1 = 1;
pesopxcmyd1 = 1;
pesopxcmxd2 = 1;
pesopxcmyd2 = 1;

%dimensao 1
dx = abs(d1p1(1) - d1p2(1));
dy = abs(d1p1(2) - d1p2(2));
ang = atan(dy/dx);
pcmy = sin(ang)*d1cm;
pcmx = cos(ang)*d1cm;
pxcmxd1 = dx/pcmx;
pxcmyd1 = dy/pcmy;

if dx < 20
    pesopxcmxd1 = 0;
end

if dy < 20
    pesopxcmyd1 = 0;
end

%dimensao 2
dx = abs(d2p1(1) - d2p2(1));
dy = abs(d2p1(2) - d2p2(2));
ang = atan(dy/dx);
pcmy = sin(ang)*d2cm;
pcmx = cos(ang)*d2cm;
pxcmxd2 = dx/pcmx;
pxcmyd2 = dy/pcmy;

if dx < 20
    pesopxcmxd2 = 0;
end

if dy < 20
    pesopxcmyd2 = 0;
end

pxcmx = (pesopxcmxd1*pxcmxd1 + pesopxcmxd2*pxcmxd2) / (pesopxcmxd1 + pesopxcmxd2);
pxcmy = (pesopxcmyd1*pxcmyd1 + pesopxcmyd2*pxcmyd2) / (pesopxcmyd1 + pesopxcmyd2);


if isnan(pxcmx)  || isnan(pxcmy)
    msgbox('It was not possible to compute the pixel/cm relation!','Erro','error');
    pxcmx = 1;
    pxcmy = 1;
end

end
% --- Executes on button press in apclick.
function apclick_Callback(hObject, eventdata, handles)
% hObject    handle to apclick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.definirapc = 1;
handles.nvertice = 1;
handles.areaproc.x = [];
handles.areaproc.y = [];
handles.clickini = [0 0];
set(handles.mensagem,'String','Click on the starting vertex of the area:');
set(handles.mensagem,'Visible','on');
set(handles.posicaomouse,'Visible','on');
set(handles.posicaomouse2,'Visible','on');
set(handles.areaprocaddvert,'Enable','on');
set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
% Update handles structure
guidata(hObject, handles);

end
% --- Executes on button press in aiclick.
function aiclick_Callback(hObject, eventdata, handles)
% hObject    handle to aiclick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.definirapc = 3;
handles.nvertice = 1;
handles.clickini = [0 0];
set(handles.mensagem,'String','Click on the starting vertex of the area:');
set(handles.mensagem,'Visible','on');
set(handles.posicaomouse,'Visible','on');
set(handles.posicaomouse2,'Visible','on');
set(handles.areaintaddvert,'Enable','on');
set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
% Update handles structure
guidata(hObject, handles);

end
% --------------------------------------------------------------------
function instru_Callback(hObject, eventdata, handles)
% hObject    handle to instru (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('documentacao\doc.pdf')
end
% --------------------------------------------------------------------
function sobre_Callback(hObject, eventdata, handles)
% hObject    handle to sobre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sobre
end
% --- Executes on button press in calcpxcm.
function calcpxcm_Callback(hObject, eventdata, handles)
% hObject    handle to calcpxcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.definirapc = 5;
handles.clickini = [0 0];
set(handles.mensagem,'String','Click on the starting point of the object in dimension 1:');
set(handles.mensagem,'Visible','on');
set(handles.posicaomouse,'Visible','on');
set(handles.posicaomouse2,'Visible','on');
set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
guidata(hObject, handles);
end
% --------------------------------------------------------------------
function resultados_Callback(hObject, eventdata, handles)
% hObject    handle to resultados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --------------------------------------------------------------------
function saveres_Callback(hObject, eventdata, handles)
% hObject    handle to saveres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


e = handles.e;

uisave({'e'},'result');
end
% --------------------------------------------------------------------
function loadres_Callback(hObject, eventdata, handles)
% hObject    handle to loadres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen
if ~exist('e','var')
    msgbox('Invalid result file!','Erro','error'); 
    return
end
handles.e = e;
set(handles.saveres,'Enable','on')
set(handles.splitres,'Enable','on');
set(handles.saveresword,'Enable','on')
set(handles.selrepitems,'Enable','on')
set(handles.viewrep,'Enable','on')
set(handles.saveresexcel,'Enable','on')
guidata(hObject, handles);
handles.e(1)
msgbox('Results successfully loaded!'); 
end
% --------------------------------------------------------------------
function saveresword_Callback(hObject, eventdata, handles)
% hObject    handle to saveresword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [FileName,PathName] = uiputfile('*.doc','Save as',handles.directoryname);
FileName = [handles.e(1).filename, '_Resultados.doc'];
PathName = handles.e(1).directory;
handles.e(1).report = true;
handles.e(1).basicinfo = get(handles.basicinfo,'Value');
handles.e(1).animalplot = get(handles.animalplot,'Value');
handles.e(1).areainfo = get(handles.areainfo,'Value');
handles.e(1).behaviourinfo = get(handles.behaviourinfo,'Value');
handles.e(1).fouriertransf = get(handles.fouriertransf,'Value');
handles.e(1).distpointinfo = get(handles.distpointinfo,'Value');
handles.e(1).distlineinfo = get(handles.distlineinfo,'Value');
handles.e(1).animalplot3D = get(handles.animalplot3D,'Value');
handles.e(1).backgplot = get(handles.backgplot,'Value');
handles.e(1).angularvelocity = get(handles.angularvelocity,'Value');
handles.e(1).angularvelocitythreshold = get(handles.angvelthres,'Value');
handles.e(1).heat_map = get(handles.HeatMap,'Value');
handles.e(1).areasequence = get(handles.areasequence,'Value');
handles.e(1).groupInfo = false;
handles.e(1).groupInfoVsanimalOne = false;

 assignin('base', 'e', handles.e);
 publish('rep.m','format','doc','showCode',false,'outputDir',PathName, 'useNewFigure',false);
 movefile(fullfile(PathName,'rep.doc'),fullfile(PathName,FileName),'f')
 disp('Report successfully saved in Word!');
 handles.e(1).report = false;
 guidata(hObject, handles);

end
% --- Executes on button press in fundodinamico.
function fundodinamico_Callback(hObject, eventdata, handles)
% hObject    handle to fundodinamico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fundodinamico

end
% --- Executes on button press in radiofk.
function radiofk_Callback(hObject, eventdata, handles)
% hObject    handle to radiofk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiofk
set(handles.radiofpb,'Value',0)
guidata(hObject, handles);
end
% --- Executes on button press in radiofpb.
function radiofpb_Callback(hObject, eventdata, handles)
% hObject    handle to radiofpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiofpb
set(handles.radiofk,'Value',0)
guidata(hObject, handles);
end
% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
figure();
imshow(handles.fundo);
title(['Background Image']);
load([handles.directoryname,'/',handles.filenameSemExtensao,'V.mat']);
figure();
imagesc(sqrt(V(:,:,4)));
title(['Variance of Backgound Image']);

end
% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4

end
% --- Executes on button press in aeclick.
function aeclick_Callback(hObject, eventdata, handles)
% hObject    handle to aeclick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.definirapc = 10;
handles.nvertice = 1;
handles.clickini = [0 0];
set(handles.mensagem,'String','Click on the starting vertex of the area:');
set(handles.mensagem,'Visible','on');
set(handles.posicaomouse,'Visible','on');
set(handles.posicaomouse2,'Visible','on');
set(handles.areaexcaddvert,'Enable','on');
set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
% Update handles structure
guidata(hObject, handles);
end
% --- Executes on button press in btareaexclimpar.
function btareaexclimpar_Callback(hObject, eventdata, handles)
% hObject    handle to btareaexclimpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = length(handles.areaexc);
if t == 1
    handles.areaexc = [];
else
    handles.areaexc = handles.areaexc(1:end-1);
end
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on

desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);


guidata(hObject, handles);
end

function aexi_Callback(hObject, eventdata, handles)
% hObject    handle to aexi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aexi as text
%        str2double(get(hObject,'String')) returns contents of aexi as a double

end
% --- Executes during object creation, after setting all properties.
function aexi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aexi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function aexf_Callback(hObject, eventdata, handles)
% hObject    handle to aexf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aexf as text
%        str2double(get(hObject,'String')) returns contents of aexf as a double

end
% --- Executes during object creation, after setting all properties.
function aexf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aexf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function aeyi_Callback(hObject, eventdata, handles)
% hObject    handle to aeyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aeyi as text
%        str2double(get(hObject,'String')) returns contents of aeyi as a double

end
% --- Executes during object creation, after setting all properties.
function aeyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aeyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function aeyf_Callback(hObject, eventdata, handles)
% hObject    handle to aeyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aeyf as text
%        str2double(get(hObject,'String')) returns contents of aeyf as a double

end
% --- Executes during object creation, after setting all properties.
function aeyf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aeyf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
  
global tecla
tecla = eventdata.Key;
global apertada
apertada = 1;
if ~ isnan(str2double(tecla))
    if (str2double(tecla) == 1 || str2double(tecla) == 2 || str2double(tecla) == 3 || str2double(tecla) == 4 || str2double(tecla) == 5 || str2double(tecla) == 6 || str2double(tecla) == 7 || str2double(tecla) == 8 || str2double(tecla) == 9) && str2double(tecla)<=length(handles.areaint)
        set(handles.mensagem,'String',['Animal forced to be on area ' tecla] );    
        set(handles.mensagem,'Visible','on');
    end
else
    vetorletras = ['q' 'w' 'e' 'r' 't' 'y' 'u' 'i' 'o' 'p' 'a' 's' 'd' 'f' 'g' 'h' 'j' 'k' 'l'];
     for indletra = 1:length(vetorletras)
       if tecla == vetorletras(indletra)
            set(handles.mensagem,'String',['Starting behaviour ' num2str(indletra)] );  
            set(handles.mensagem,'Visible','on');
        end
    end
end
% Update handles structure
guidata(hObject, handles);

end
% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
global apertada
apertada = 0;
set(handles.mensagem,'Visible','off');

end

function tinimin_Callback(hObject, eventdata, handles)
% hObject    handle to tinimin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tinimin as text
%        str2double(get(hObject,'String')) returns contents of tinimin as a double

end
% --- Executes during object creation, after setting all properties.
function tinimin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tinimin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function tiniseg_Callback(hObject, eventdata, handles)
% hObject    handle to tiniseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tiniseg as text
%        str2double(get(hObject,'String')) returns contents of tiniseg as a double

end
% --- Executes during object creation, after setting all properties.
function tiniseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tiniseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function tfimmin_Callback(hObject, eventdata, handles)
% hObject    handle to tfimmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tfimmin as text
%        str2double(get(hObject,'String')) returns contents of tfimmin as a double

end
% --- Executes during object creation, after setting all properties.
function tfimmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfimmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function tfimseg_Callback(hObject, eventdata, handles)
% hObject    handle to tfimseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tfimseg as text
%        str2double(get(hObject,'String')) returns contents of tfimseg as a double
end

% --- Executes during object creation, after setting all properties.
function tfimseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tfimseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in radiosfb.
function radiosfb_Callback(hObject, eventdata, handles)
% hObject    handle to radiosfb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiosfb
set(handles.radiosfe,'Value',0)
guidata(hObject, handles);
end

% --- Executes on button press in radiosfe.
function radiosfe_Callback(hObject, eventdata, handles)
% hObject    handle to radiosfe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiosfe
set(handles.radiosfb,'Value',0)
guidata(hObject, handles);

end

function vminima_Callback(hObject, eventdata, handles)
% hObject    handle to vminima (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vminima as text
%        str2double(get(hObject,'String')) returns contents of vminima as a double
end

% --- Executes during object creation, after setting all properties.
function vminima_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vminima (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function tminparado_Callback(hObject, eventdata, handles)
% hObject    handle to tminparado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tminparado as text
%        str2double(get(hObject,'String')) returns contents of tminparado as a double
end

% --- Executes during object creation, after setting all properties.
function tminparado_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tminparado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function tmindormindo_Callback(hObject, eventdata, handles)
% hObject    handle to tmindormindo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmindormindo as text
%        str2double(get(hObject,'String')) returns contents of tmindormindo as a double
end

% --- Executes during object creation, after setting all properties.
function tmindormindo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmindormindo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in subtracaocolorida.
function subtracaocolorida_Callback(hObject, eventdata, handles)
% hObject    handle to subtracaocolorida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subtracaocolorida

end
% --- Executes on slider movement.
function sliderti_Callback(hObject, eventdata, handles)
% hObject    handle to sliderti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.valsliti = round(get(handles.sliderti,'Value'));
set(handles.tinimin,'String',num2str(floor(handles.valsliti/(handles.frameRate*60))));
set(handles.tiniseg,'String',num2str(floor(handles.valsliti/(handles.frameRate) - 60*floor(handles.valsliti/(handles.frameRate*60)))));


 guidata(hObject, handles);

    visualizar_Callback(hObject, eventdata, guidata(hObject))

    handles=guidata(hObject);
    guidata(hObject,handles);


end
% --- Executes during object creation, after setting all properties.
function sliderti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end
% --- Executes on slider movement.
function slidertf_Callback(hObject, eventdata, handles)
% hObject    handle to slidertf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.valsliti = round(get(handles.sliderti,'Value'));
handles.valslitf = round(get(handles.slidertf,'Value'));
%if(handles.valslitf<=handles.valsliti)
%    handles.valslitf = handles.valsliti+handles.frameRate;
%end
set(handles.slidertf,'Value',handles.valslitf);
set(handles.tfimmin,'String',num2str(floor(handles.valslitf/(handles.frameRate*60))));
set(handles.tfimseg,'String',num2str(floor(handles.valslitf/(handles.frameRate) - 60*floor(handles.valslitf/(handles.frameRate*60)))));

 guidata(hObject, handles);

    visualizar_Callback(hObject, eventdata, guidata(hObject))

    handles=guidata(hObject);
    guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.
function slidertf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidertf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end
% --------------------------------------------------------------------
function saveresexcel_Callback(hObject, eventdata, handles)
% hObject    handle to saveresexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% varargout{1} = handles.t;
% varargout{2} = handles.posicao;
% varargout{3} = handles.velocidade;
% varargout{4} = handles.parado;
% varargout{5} = handles.dormindo;
% varargout{6} = handles.tempoareas;
% varargout{7} = handles.distperc;
% varargout{8} = handles.directoryname;
% varargout{9} = handles.comportamento;

handles.e(1).areainfo = get(handles.areainfo,'Value');
handles.e(1).distlineinfo = get(handles.distlineinfo,'Value');
handles.e(1).angularvelocity = get(handles.angularvelocity,'Value');
handles.e(1).angularvelocitythreshold = get(handles.angvelthres,'Value');
handles.e(1).behaviourinfo = get(handles.behaviourinfo,'Value');
handles.e(1).heat_map = get(handles.HeatMap,'Value');
handles.e(1).groupInfo = false;
handles.e(1).groupInfoVsanimalOne = false;

% Declarar s como global
global tj;
global s;

if handles.e(1).distlineinfo
s ={'animal' 'mean speed' 'maximum speed' 'total distance' 'total time stoped' 'mean distance from a line' 'area number' 'time spent in area' 'latency'};
else
s ={'animal' 'mean speed' 'maximum speed' 'total distance' 'total time stoped' 'number of turns' 'turns per minute' 'area number' 'time spent in area' 'latency'};    
end

if handles.e(1).areainfo
    s = [s {'mean speed in area' 'max speed in area' 'total distance in area' 'total time stopped in area' 'total of times entered in area'}];
    
end
tj = s;
% [FileName,PathName] = uiputfile('*.xls','Save as',handles.directoryname);
FileName = [handles.e(1).filename, '_Resultados.xls'];
PathName = handles.e(1).directory;
output_xlsx_path = fullfile(PathName, FileName);

try 
    [v1,v2,s] = xlsread(fullfile(PathName,FileName));
    disp('added to selected file');
catch
    disp('Creating new Excel file to Single Results.');
end
n = length(handles.e);
for ne=1:n
    nanimais = length(handles.e(ne).posicao);
    [v1, nareas]= size(handles.e(ne).tempoareas);
    
  
    if handles.e(1).distlineinfo
        %converte areaproc de px pra cm
        p1x = handles.e(1).distlineini.x/handles.e(1).pxcm.x;
        p1y = (handles.e(1).figdimensions.l - handles.e(1).distlineini.y)/handles.e(1).pxcm.y;

        p2x = handles.e(1).distlinefim.x/handles.e(1).pxcm.x;
        p2y = (handles.e(1).figdimensions.l - handles.e(1).distlinefim.y)/handles.e(1).pxcm.y;
        
        %reta ax + by + c que define tal aresta
        a =  (p2y - p1y) / (p2x - p1x);
        b = -1;
        c = p2y - a*p2x;
        distanciapfundo = [];
    end
    global total_sharp_turns;
    global number_sharp_turns_minute;

    for i=1:nanimais
        if handles.e(1).distlineinfo
            distanciapfundo(i,:) = abs(a*handles.e(ne).posicao{i}.x + b*handles.e(ne).posicao{i}.y + c)/sqrt(a^2+b^2);
        
            noval = {handles.filenameSemExtensao, mean(handles.e(ne).velocidade{i}.total), max(handles.e(ne).velocidade{i}.total), handles.e(ne).distperc(i), sum(handles.e(ne).parado{i}.tf-handles.e(ne).parado{i}.ti), mean(distanciapfundo(i,:)) }; 
        else
           noval = {handles.filenameSemExtensao, mean(handles.e(ne).velocidade{i}.total), max(handles.e(ne).velocidade{i}.total), handles.e(ne).distperc(i), sum(handles.e(ne).parado{i}.tf-handles.e(ne).parado{i}.ti), total_sharp_turns, number_sharp_turns_minute};
           
        end

        velocidade = handles.e(ne).velocidade;
        tempoareas = handles.e(ne).tempoareas;
        parado = handles.e(ne).parado;
        t = handles.e(ne).t;
        cont_parada_area = handles.e(ne).contparado_area;
        coord_parada_area = handles.e(ne).parado_area;
        

        %tempo na primeira area
        if nareas > 0 && handles.e(ne).tempoareas{i,1}.tf(1) ~= 0
            velnaarea{i,1}.v=[];
                for k=1:length(velocidade{i}.total);
                    for l=1:length(tempoareas{i,1}.ti)
                        if t(k) >= tempoareas{i,1}.ti(l) &&  t(k) < tempoareas{i,1}.tf(l) %neste tempo estava na area
                            velnaarea{i,1}.v = [velnaarea{i,1}.v velocidade{i}.total(k)];
                        end
                    end
                end
            %totparado(1)=0;
            %nvezesparado = length(cont_parada_area{i}.ti);
            %    for k=1:nvezesparado
            %        for l=1:length(tempoareas{i,1}.ti)
            %            if parado{i}.ti(k) >= tempoareas{i,1}.ti(l) &&  parado{i}.ti(k) < tempoareas{i,1}.tf(l)
            %                totparado(1) = totparado(1) + parado{i}.tf(k) - parado{i}.ti(k);
            %            end
            %        end
            %    end
            % --- CÁLCULO ADAPTADO do tempo total parado (totparado) na primeira área ---

            totparado(1)=0; % Inicializa o tempo total parado na área 1 para o animal i
            area_atual_idx = 1; % Índice da área atual
        
            % Verifica se há paradas registradas para este animal (i) nesta área (area_atual_idx)
            % A contagem já considera apenas paradas com duração >= tmin
            if cont_parada_area(i, area_atual_idx) > 0
                % Acessa os tempos de início e fim das paradas específicas desta área
                % Verifica se os campos .ti e .tf existem na estrutura (boa prática)
                if isfield(coord_parada_area{i, area_atual_idx}, 'ti') && isfield(coord_parada_area{i, area_atual_idx}, 'tf')
                    tempos_inicio_parada_area = coord_parada_area{i, area_atual_idx}.ti;
                    tempos_fim_parada_area = coord_parada_area{i, area_atual_idx}.tf;

                    % Certifica-se de que os vetores têm o mesmo tamanho e não estão vazios
                    if ~isempty(tempos_inicio_parada_area) && (length(tempos_inicio_parada_area) == length(tempos_fim_parada_area))
                        diferencas_tempo = tempos_fim_parada_area - tempos_inicio_parada_area;
                        % Remove NaNs que podem surgir se uma parada não foi corretamente finalizada ou se vetores foram malformados
                        diferencas_tempo_validas = diferencas_tempo(~isnan(diferencas_tempo)); 
                        totparado(1) = sum(diferencas_tempo_validas); % Soma as durações de todas as paradas válidas na área
                    end
                end
            end
            % --- FIM DO CÁLCULO ADAPTADO de totparado(1) ---
            noval = [noval 1 sum(handles.e(ne).tempoareas{i,1}.tf - handles.e(ne).tempoareas{i,1}.ti), handles.e(ne).tempoareas{i,1}.ti(1) - handles.e(ne).t(1), mean(velnaarea{i,1}.v), max(velnaarea{i,1}.v), mean(velnaarea{i,1}.v*sum(tempoareas{i,1}.tf - tempoareas{i,1}.ti)), totparado(1), length(tempoareas{i,1}.ti)];
        else
            noval = [noval {0 0 '' 0 0 0 0 0}];
        end  
        
        s = [s;noval];        
        for j=2:nareas
            if handles.e(ne).tempoareas{i,j}.tf(1) ~= 0  %se o peixe entrou pelo menos uma vez na Ã¡rea
                velnaarea{i,j}.v=[];
                        for k=1:length(velocidade{i}.total);
                            for l=1:length(tempoareas{i,j}.ti)
                                if t(k) >= tempoareas{i,j}.ti(l) &&  t(k) < tempoareas{i,j}.tf(l) %neste tempo estava na area
                                    velnaarea{i,j}.v = [velnaarea{i,j}.v velocidade{i}.total(k)];
                                end
                            end
                        end
                %totparado(j)=0;
                %nvezesparado = length(parado{i}.ti);
                %        for k=1:nvezesparado
                %            for l=1:length(tempoareas{i,j}.ti)
                %                if parado{i}.ti(k) >= tempoareas{i,j}.ti(l) &&  parado{i}.ti(k) < tempoareas{i,j}.tf(l)
                %                    totparado(j) = totparado(j) + parado{i}.tf(k) - parado{i}.ti(k);
                %                end
                %            end
                %        end
                % --- CÁLCULO ADAPTADO do tempo total parado (totparado) na área j_area ---

                totparado(j)=0; % Inicializa o tempo total parado na área j_area para o animal i
                area_atual_idx = j;
            
                if cont_parada_area(i, area_atual_idx) > 0
                    if isfield(coord_parada_area{i, area_atual_idx}, 'ti') && isfield(coord_parada_area{i, area_atual_idx}, 'tf')
                        tempos_inicio_parada_area = coord_parada_area{i, area_atual_idx}.ti;
                        tempos_fim_parada_area = coord_parada_area{i, area_atual_idx}.tf;
                        if ~isempty(tempos_inicio_parada_area) && (length(tempos_inicio_parada_area) == length(tempos_fim_parada_area))
                            diferencas_tempo = tempos_fim_parada_area - tempos_inicio_parada_area;
                            diferencas_tempo_validas = diferencas_tempo(~isnan(diferencas_tempo));
                            totparado(j) = sum(diferencas_tempo_validas);
                        end
                    end
                end
                % --- FIM DO CÁLCULO ADAPTADO de totparado(j) ---
                if handles.e(1).distlineinfo
                    noval = {'', '', '', '', '','', j, sum(handles.e(ne).tempoareas{i,j}.tf - handles.e(ne).tempoareas{i,j}.ti), handles.e(ne).tempoareas{i,j}.ti(1) - handles.e(ne).t(1)};
                else
                    noval = {'', '', '', '', '', '', '', j, sum(handles.e(ne).tempoareas{i,j}.tf - handles.e(ne).tempoareas{i,j}.ti), handles.e(ne).tempoareas{i,j}.ti(1) - handles.e(ne).t(1), mean(velnaarea{i,j}.v), max(velnaarea{i,j}.v), mean(velnaarea{i,j}.v*sum(tempoareas{i,j}.tf - tempoareas{i,j}.ti)), totparado(j), length(tempoareas{i,j}.ti)};
                end
                
            else
                if handles.e(1).distlineinfo
                    noval = {'', '', '', '', '','', j, 0, '', 0, 0, 0, 0, 0};
                else
                     noval = {'', '', '', '','', '', '', j, 0, '', 0, 0, 0, 0, 0};
                end
            end
            
            

            s = [s;noval];   
        end
    end
    %if handles.e(1).behaviourinfo 
         %nc = max(handles.e(ne).comportamento.tipo); %numero de comportamentos
         %tempcomp = zeros(1,nc);
        %for i=1:length(handles.e(ne).comportamento.tipo)
         %  tempcomp(handles.e(ne).comportamento.tipo) =  tempcomp(handles.e(ne).comportamento.tipo(i)) + handles.e(ne).comportamento.tf(i) - handles.e(ne).comportamento.ti(i);
        %end
        %MatrizComportamento = ['Time spent in behaviour ' num2str(1) num2str(tempcomp(1))]; 
        %for i=2:nc
        %    disp(['Time spent in behaviour ' num2str(i) ' : ' num2str(tempcomp(i))])
        %    MatrizAux = {'Time spent in behaviour ' num2str(i) num2str(tempcomp(i))};
        %    MatrizComportamento = [MatrizComportamento MatrizAux];
        %end
        %sheet = 2*ne;
        %xlswrite(fullfile(PathName,FileName), MatrizComportamento, sheet);
        %fprintf('\n');
        %behaviour transitions matrix
        %btm = zeros(max(handles.e(ne).comportamento.tipo)) - eye(max(handles.e(ne).comportamento.tipo));
        %for i=1:length(handles.e(ne).comportamento.tipo)-1
        %    btm(handles.e(ne).comportamento.tipo(i),handles.e(ne).comportamento.tipo(i+1)) = btm(handles.e(ne).comportamento.tipo(i),handles.e(ne).comportamento.tipo(i+1)) + 1;
        %end
        %disp('Behaviour Transition Matrix')
        %disp(btm);
        %sheet = 2*ne + 1;
        %xlswrite(fullfile(PathName,FileName), btm, sheet);
    %end
    
    
    
    %disp([num2str(round(ne/n*100)) ' generating file...']);
     
    
    
    
    
    
end
disp('Saving Excel file of Single Resuts...')
% Salvar o arquivo atualizado
writecell(s, fullfile(PathName, FileName)); % Substitui xlswrite por writecell



% Adicionar os dados ao arquivo unificado do projeto
global project_xlsx_path;

% Verificar se `project_xlsx_path` foi inicializado
if isempty(project_xlsx_path)
    disp('Aviso: Caminho do projeto principal não definido. Dados não foram adicionados ao arquivo unificado do projeto.');
else
    if exist (project_xlsx_path, 'file') == 0
        create_excel_file(project_xlsx_path);
    end
    % Se `project_xlsx_path` estiver definido, adicione ao arquivo unificado
    append_to_excel_file(output_xlsx_path, project_xlsx_path);
    
end

disp('Excel file of Global Unified data saved!')

% Limpar s para evitar problemas em execuções futuras
s = [];
end


    
% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pausar;
if pausar == 0
    pausar = 1;
    set(handles.pause,'String','Resume');
    set(handles.abortar,'Enable','off');
    set(handles.rr,'Enable','on');
    set(handles.ff,'Enable','on');
    handles.definirapc = 12;
    set(handles.mensagem,'String','Click on the detected position to change it');
else
    pausar = 0;
    set(handles.pause,'String','Pause');
    set(handles.abortar,'Enable','on');
    set(handles.rr,'Enable','off');
    set(handles.ff,'Enable','off');
    set(handles.mensagem,'String','If the tracking process looses the animal, click on it to help its detection');
end
handles.avanco = 0;
guidata(hObject, handles);

end
% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.rastro,'String',num2str(round(get(handles.slider7,'Value'))));
global nulitimospontos;
nulitimospontos = round(get(handles.slider7,'Value'));
guidata(hObject, handles);

end
% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end

function rastro_Callback(hObject, eventdata, handles)
% hObject    handle to rastro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rastro as text
%        str2double(get(hObject,'String')) returns contents of rastro as a double
end

% --- Executes during object creation, after setting all properties.
function rastro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rastro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
figure();
fini = read(handles.video,handles.frameini);
imshow(fini);

end
% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
figure();
ffim = read(handles.video,handles.framefim);
imshow(ffim);

end
% --- Executes on button press in thresholdadaptativo.
function thresholdadaptativo_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdadaptativo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global threshadaptativo;
threshadaptativo = get(handles.thresholdadaptativo,'Value');


% Hint: get(hObject,'Value') returns toggle state of thresholdadaptativo

end
% --- Executes on button press in rr.
function rr_Callback(hObject, eventdata, handles)
% hObject    handle to rr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numframeatual;
procf = str2double(get(handles.procframe,'String'));
if numframeatual + procf*handles.avanco > handles.frameini + procf
    handles.avanco = handles.avanco - 1;
end
handles.framep = read(handles.video,numframeatual + procf*handles.avanco);
set(handles.figure1,'CurrentAxes',handles.axes4);
hold off
imhandle = imshow(handles.framep);
set(imhandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
global nulitimospontos;
global cont;
global px;
global py;
if(nulitimospontos ~= 0)
    plot(px(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),py(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),'o');
    plot(px(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),py(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco));
end
vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];
%plota os animais
for j=1:str2double(get(handles.npeixes,'String'))
    phandle = plot(px(j,cont+handles.avanco),py(j,cont+handles.avanco),'o','Color',vcores(mod(j,7)+1,:));
    set(phandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
end

set(handles.tamin,'String',num2str(floor((numframeatual + procf*handles.avanco)/(handles.frameRate*60))));
set(handles.taseg,'String',num2str(floor((numframeatual + procf*handles.avanco)/(handles.frameRate) - 60*floor((numframeatual + procf*handles.avanco)/(handles.frameRate*60)))));

guidata(hObject, handles);

end
% --- Executes on button press in ff.
function ff_Callback(hObject, eventdata, handles)
% hObject    handle to ff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numframeatual;
procf = str2double(get(handles.procframe,'String'));
if handles.avanco < 0
    handles.avanco = handles.avanco + 1;
end
handles.framep = read(handles.video,numframeatual + procf*handles.avanco);
set(handles.figure1,'CurrentAxes',handles.axes4);
hold off
imhandle = imshow(handles.framep);
set(imhandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
global nulitimospontos;
global cont;
global px;
global py;
if(nulitimospontos ~= 0)
    plot(px(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),py(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),'o');
    plot(px(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco),py(1,max(cont-nulitimospontos+handles.avanco,1):cont+handles.avanco));
end
    
vcores = [0 0 1; 1 0 0; 0 1 0; 1 1 1; 1 1 0; 1 0 1; 0 1 1];
%plota os animais
for j=1:str2double(get(handles.npeixes,'String'))
    phandle = plot(px(j,cont+handles.avanco),py(j,cont+handles.avanco),'o','Color',vcores(mod(j,7)+1,:));
    set(phandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
end

set(handles.tamin,'String',num2str(floor((numframeatual + procf*handles.avanco)/(handles.frameRate*60))));
set(handles.taseg,'String',num2str(floor((numframeatual + procf*handles.avanco)/(handles.frameRate) - 60*floor((numframeatual + procf*handles.avanco)/(handles.frameRate*60)))));


guidata(hObject, handles);

end
% --- Executes on slider movement.
function slidercamlent_Callback(hObject, eventdata, handles)
% hObject    handle to slidercamlent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.cameralenta,'String',num2str(get(handles.slidercamlent,'Value')));
guidata(hObject, handles);

end
% --- Executes during object creation, after setting all properties.
function slidercamlent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidercamlent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end

function cameralenta_Callback(hObject, eventdata, handles)
% hObject    handle to cameralenta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slidercamlent,'Value',str2double(get(handles.cameralenta,'String')));
guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.
function cameralenta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameralenta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


end
function tamin_Callback(hObject, eventdata, handles)
% hObject    handle to tamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tamin as text
%        str2double(get(hObject,'String')) returns contents of tamin as a double

end
% --- Executes during object creation, after setting all properties.
function tamin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


end
function taseg_Callback(hObject, eventdata, handles)
% hObject    handle to taseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of taseg as text
%        str2double(get(hObject,'String')) returns contents of taseg as a double

end
% --- Executes during object creation, after setting all properties.
function taseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to taseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in resvideo.
function resvideo_Callback(hObject, eventdata, handles)
% hObject    handle to resvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resvideo

end
% --- Executes on button press in splitexperiment.
function splitexperiment_Callback(hObject, eventdata, handles)
% hObject    handle to splitexperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of splitexperiment

end

function splittime_Callback(hObject, eventdata, handles)
% hObject    handle to splittime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of splittime as text
%        str2double(get(hObject,'String')) returns contents of splittime as a double

end
% --- Executes during object creation, after setting all properties.
function splittime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to splittime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --------------------------------------------------------------------
function selrepitems_Callback(hObject, eventdata, handles)
% hObject    handle to selrepitems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel9,'Visible','on');
set(handles.uipanel1,'Visible','off');
set(handles.uipanel2,'Visible','off');
set(handles.uipanel7,'Visible','off');
set(handles.uipanel10,'Visible','off');
set(handles.uipanel13,'Visible','off');
set(handles.uipanel21,'Visible','off');
%uistack(handles.uipanel9, 'top');
guidata(hObject, handles);
end
% --------------------------------------------------------------------
function viewrep_Callback(hObject, eventdata, handles)
% hObject    handle to viewrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.e(1).report = false;
handles.e(1).basicinfo = get(handles.basicinfo,'Value');
handles.e(1).animalplot = get(handles.animalplot,'Value');
handles.e(1).areainfo = get(handles.areainfo,'Value');
handles.e(1).behaviourinfo = get(handles.behaviourinfo,'Value');
handles.e(1).fouriertransf = get(handles.fouriertransf,'Value');
handles.e(1).distpointinfo = get(handles.distpointinfo,'Value');
handles.e(1).distlineinfo = get(handles.distlineinfo,'Value');
handles.e(1).animalplot3D = get(handles.animalplot3D,'Value');
handles.e(1).backgplot = get(handles.backgplot,'Value');
handles.e(1).angularvelocity = get(handles.angularvelocity,'Value');
handles.e(1).angularvelocitythreshold = get(handles.angvelthres,'Value');
handles.e(1).heat_map = get(handles.HeatMap,'Value');
handles.e(1).areasequence = get(handles.areasequence,'Value');
handles.e(1).groupInfo = false;
handles.e(1).groupInfoVsanimalOne = false;

handles.e(1).filename = handles.filenameSemExtensao;
guidata(hObject, handles);%salva o handles nessa porra.
e=handles.e;
rep;
 

end
% --------------------------------------------------------------------
function selvid_Callback(hObject, eventdata, handles)
% hObject    handle to selvid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel1,'Visible','on');
set(handles.uipanel2,'Visible','on');
set(handles.uipanel10,'Visible','on');
set(handles.uipanel7,'Visible','off');
set(handles.uipanel9,'Visible','off');
set(handles.uipanel13,'Visible','off');
set(handles.uipanel21,'Visible','off');

%uistack(handles.uipanel10, 'top');
guidata(hObject, handles);

end
% --------------------------------------------------------------------
function conf_Callback(hObject, eventdata, handles)
% hObject    handle to conf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel7,'Visible','on');
set(handles.uipanel1,'Visible','off');
set(handles.uipanel2,'Visible','off');
set(handles.uipanel9,'Visible','off');
set(handles.uipanel10,'Visible','off');
set(handles.uipanel13,'Visible','off');
set(handles.uipanel21,'Visible','off');

%uistack(handles.uipanel7, 'top');
guidata(hObject, handles);

end
% --- Executes on button press in trackmouse.
function trackmouse_Callback(hObject, eventdata, handles)
% hObject    handle to trackmouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trackmouse

end
% --- Executes on button press in basicinfo.
function basicinfo_Callback(hObject, eventdata, handles)
% hObject    handle to basicinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of basicinfo

end
% --- Executes on button press in behaviourinfo.
function behaviourinfo_Callback(hObject, eventdata, handles)
% hObject    handle to behaviourinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of behaviourinfo

end
% --- Executes on button press in areainfo.
function areainfo_Callback(hObject, eventdata, handles)
% hObject    handle to areainfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of areainfo

end
% --- Executes on button press in animalplot.
function animalplot_Callback(hObject, eventdata, handles)
% hObject    handle to animalplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of animalplot

end
% --- Executes on button press in fouriertransf.
function fouriertransf_Callback(hObject, eventdata, handles)
% hObject    handle to fouriertransf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fouriertransf

end
% --- Executes on button press in distpointinfo.
function distpointinfo_Callback(hObject, eventdata, handles)
% hObject    handle to distpointinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distpointinfo
if get(handles.distpointinfo,'Value');
    set(handles.distpointinfo,'Value',false);
    handles.definirapc = 14;
    handles.clickini = [0 0];
    set(handles.mensagem,'String','Click on the point of interest:');
    set(handles.mensagem,'Visible','on');
    set(handles.posicaomouse,'Visible','on');
    set(handles.posicaomouse2,'Visible','on');
    set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
    guidata(hObject, handles);
end

end
% --- Executes on button press in distlineinfo.
function distlineinfo_Callback(hObject, eventdata, handles)
% hObject    handle to distlineinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distlineinfo
if get(handles.distlineinfo,'Value');
    set(handles.distlineinfo,'Value',false);
    handles.definirapc = 15;
    handles.clickini = [0 0];
    set(handles.mensagem,'String','Click on the first point of the line:');
    set(handles.mensagem,'Visible','on');
    set(handles.posicaomouse,'Visible','on');
    set(handles.posicaomouse2,'Visible','on');
    set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
    guidata(hObject, handles);
end

end
% --- Executes on button press in animalplot3D.
function animalplot3D_Callback(hObject, eventdata, handles)
% hObject    handle to animalplot3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of animalplot3D

end
% --- Executes on button press in backgplot.
function backgplot_Callback(hObject, eventdata, handles)
% hObject    handle to backgplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of backgplot

end
% --- Executes on button press in areaprocaddvert.
function areaprocaddvert_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
% hObject    handle to areaprocaddvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.areaproc.x(handles.nvertice) = str2double(get(handles.apxi,'String'));
handles.areaproc.y(handles.nvertice) = str2double(get(handles.apyi,'String'));
handles.nvertice = handles.nvertice + 1;
handles.areaproc.x(handles.nvertice)=handles.areaproc.x(1);
handles.areaproc.y(handles.nvertice)=handles.areaproc.y(1);
handles.definirapc = 2; 
set(handles.areaprocfinish,'Enable','on');
set(handles.mensagem,'Visible','on');
set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
guidata(hObject, handles);

end
% --- Executes on button press in areaprocfinish.
function areaprocfinish_Callback(hObject, eventdata, handles)
% hObject    handle to areaprocfinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.areaproc.x(handles.nvertice)=handles.areaproc.x(1);
handles.areaproc.y(handles.nvertice)=handles.areaproc.y(1);
handles.definirapc = 0;
set(handles.mensagem,'Visible','off');
set(handles.figure1,'WindowButtonMotionFcn','');
set(handles.posicaomouse,'Visible','off');
set(handles.posicaomouse2,'Visible','off');
set(handles.areaprocaddvert,'Enable','off');
set(handles.areaprocfinish,'Enable','off');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
guidata(hObject, handles);

end
% --- Executes on button press in areaintaddvert.
function areaintaddvert_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to areaintaddvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.definirapc == 3;
    n = length(handles.areaint) + 1;
    handles.definirapc = 4;
else
    n = length(handles.areaint);
end
handles.areaint(n).x(handles.nvertice) = str2double(get(handles.aixi,'String'));
handles.areaint(n).y(handles.nvertice) = str2double(get(handles.aiyi,'String'));
handles.nvertice = handles.nvertice + 1;
handles.areaint(n).x(handles.nvertice) = handles.areaint(n).x(1);
handles.areaint(n).y(handles.nvertice) = handles.areaint(n).y(1);

set(handles.areaintfinish,'Enable','on');
set(handles.mensagem,'Visible','on');
set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
guidata(hObject, handles);

end
% --- Executes on button press in areaintfinish.
function areaintfinish_Callback(hObject, eventdata, handles)
% hObject    handle to areaintfinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = length(handles.areaint);
handles.areaint(n).x(handles.nvertice) = handles.areaint(n).x(1);
handles.areaint(n).y(handles.nvertice) = handles.areaint(n).y(1);
handles.definirapc = 0;
set(handles.mensagem,'Visible','off');
set(handles.areaintaddvert,'Enable','off');
set(handles.areaintfinish,'Enable','off');
set(handles.figure1,'WindowButtonMotionFcn','');
set(handles.posicaomouse,'Visible','off');
set(handles.posicaomouse2,'Visible','off');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
guidata(hObject, handles);

end
% --- Executes on button press in areaexcaddvert.
function areaexcaddvert_Callback(hObject, eventdata, handles)
% hObject    handle to areaexcaddvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.definirapc == 10;
    n = length(handles.areaexc) + 1;
    handles.definirapc = 11;
else
    n = length(handles.areaexc);
end
handles.areaexc(n).x(handles.nvertice) = str2double(get(handles.aexi,'String'));
handles.areaexc(n).y(handles.nvertice) = str2double(get(handles.aeyi,'String'));
handles.nvertice = handles.nvertice + 1;
handles.areaexc(n).x(handles.nvertice) = handles.areaexc(n).x(1);
handles.areaexc(n).y(handles.nvertice) = handles.areaexc(n).y(1);

set(handles.areaexcfinish,'Enable','on');
set(handles.mensagem,'Visible','on');
set(handles.mensagem,'String','Click on the next vertex (double click to finish):');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
guidata(hObject, handles);

end
% --- Executes on button press in areaexcfinish.
function areaexcfinish_Callback(hObject, eventdata, handles)
% hObject    handle to areaexcfinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = length(handles.areaexc);
handles.areaexc(n).x(handles.nvertice) = handles.areaexc(n).x(1);
handles.areaexc(n).y(handles.nvertice) = handles.areaexc(n).y(1);
handles.definirapc = 0;
set(handles.mensagem,'Visible','off');
set(handles.areaexcaddvert,'Enable','off');
set(handles.areaexcfinish,'Enable','off');
set(handles.figure1,'WindowButtonMotionFcn','');
set(handles.posicaomouse,'Visible','off');
set(handles.posicaomouse2,'Visible','off');
axes(handles.axes4)
hold off
fundohandle = imshow(handles.fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
hold on
desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
guidata(hObject, handles);

end
% --------------------------------------------------------------------
function splitres_Callback(hObject, eventdata, handles)
% hObject    handle to splitres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%verifica se o experimento ja Ã© splitado

ne = length(handles.e);
if ne~=1
   %junta antes tudo em um unico experimento g
   g.t = [];
   nanimais = length(handles.e(1).posicao);
   [trash, nareas] = size(handles.e(1).tempoareas);
   g.comportamento.tipo = [];
   g.comportamento.ti = [];
   g.comportamento.xi = [];
   g.comportamento.yi = [];
   g.comportamento.tf = [];
   g.comportamento.xf = [];
   g.comportamento.yf = [];
   for j=1:nanimais
        g.posicao{j}.x = [];
        g.posicao{j}.y = [];
        g.velocidade{j}.x=[];
        g.velocidade{j}.y=[];
        g.velocidade{j}.total=[];
        g.parado{j}.ti = [];
        g.parado{j}.xi = [];
        g.parado{j}.yi = [];
        g.parado{j}.tf = [];
        g.parado{j}.xf = [];
        g.parado{j}.yf = [];
        g.dormindo{j}.ti = [];
        g.dormindo{j}.xi = [];
        g.dormindo{j}.yi = [];
        g.dormindo{j}.tf = [];
        g.dormindo{j}.xf = [];
        g.dormindo{j}.yf = [];
        g.distperc = 0;
   end
   
   for i=1:ne
       if i~=ne
            g.t = [g.t handles.e(i).t(1:end-1)];
       else
           g.t = [g.t handles.e(i).t(1:end)];
       end
       g.distperc = g.distperc + handles.e(i).distperc;
       g.comportamento.tipo = [g.comportamento.tipo  handles.e(i).comportamento.tipo];
       g.comportamento.ti = [g.comportamento.ti  handles.e(i).comportamento.ti];
       g.comportamento.xi = [g.comportamento.xi  handles.e(i).comportamento.xi];
       g.comportamento.yi = [g.comportamento.yi  handles.e(i).comportamento.yi];
       g.comportamento.tf = [g.comportamento.tf  handles.e(i).comportamento.tf];
       g.comportamento.xf = [g.comportamento.xf  handles.e(i).comportamento.xf];
       g.comportamento.yf = [g.comportamento.yf  handles.e(i).comportamento.yf];
       for j=1:nanimais
           if i~=ne
                g.posicao{j}.x = [g.posicao{j}.x handles.e(i).posicao{j}.x(1:end-1)];
                g.posicao{j}.y = [g.posicao{j}.y handles.e(i).posicao{j}.y(1:end-1)];
           else
                g.posicao{j}.x = [g.posicao{j}.x handles.e(i).posicao{j}.x(1:end)];
                g.posicao{j}.y = [g.posicao{j}.y handles.e(i).posicao{j}.y(1:end)];
           end
            
            g.velocidade{j}.x = [g.velocidade{j}.x handles.e(i).velocidade{j}.x()];
            g.velocidade{j}.y = [g.velocidade{j}.y handles.e(i).velocidade{j}.y];
            g.velocidade{j}.total = [g.velocidade{j}.total handles.e(i).velocidade{j}.total];
            if i == 1
                g.parado{j}.ti = [g.parado{j}.ti handles.e(i).parado{j}.ti];
                g.parado{j}.xi = [g.parado{j}.xi handles.e(i).parado{j}.xi];
                g.parado{j}.yi = [g.parado{j}.yi handles.e(i).parado{j}.yi];
                g.parado{j}.tf = [g.parado{j}.tf handles.e(i).parado{j}.tf];
                g.parado{j}.xf = [g.parado{j}.xf handles.e(i).parado{j}.xf];
                g.parado{j}.yf = [g.parado{j}.yf handles.e(i).parado{j}.yf];
                g.dormindo{j}.ti = [g.dormindo{j}.ti handles.e(i).dormindo{j}.ti];
                g.dormindo{j}.xi = [g.dormindo{j}.xi handles.e(i).dormindo{j}.xi];
                g.dormindo{j}.yi = [g.dormindo{j}.yi handles.e(i).dormindo{j}.yi];
                g.dormindo{j}.tf = [g.dormindo{j}.tf handles.e(i).dormindo{j}.tf];
                g.dormindo{j}.xf = [g.dormindo{j}.xf handles.e(i).dormindo{j}.xf];
                g.dormindo{j}.yf = [g.dormindo{j}.yf handles.e(i).dormindo{j}.yf];
            else
                if handles.e(i).parado{j}.tf(1) ~= 0
                    if g.parado{j}.tf(1) == 0
                        g.parado{j}.ti = [];
                        g.parado{j}.xi = [];
                        g.parado{j}.yi = [];
                        g.parado{j}.tf = [];
                        g.parado{j}.xf = [];
                        g.parado{j}.yf = [];
                    end
                    g.parado{j}.ti = [g.parado{j}.ti handles.e(i).parado{j}.ti];
                    g.parado{j}.xi = [g.parado{j}.xi handles.e(i).parado{j}.xi];
                    g.parado{j}.yi = [g.parado{j}.yi handles.e(i).parado{j}.yi];
                    g.parado{j}.tf = [g.parado{j}.tf handles.e(i).parado{j}.tf];
                    g.parado{j}.xf = [g.parado{j}.xf handles.e(i).parado{j}.xf];
                    g.parado{j}.yf = [g.parado{j}.yf handles.e(i).parado{j}.yf];
                end
                if handles.e(i).dormindo{j}.tf ~= 0
                    if g.dormindo{j}.tf(1)==0
                        g.dormindo{j}.ti = [];
                        g.dormindo{j}.xi = [];
                        g.dormindo{j}.yi = [];
                        g.dormindo{j}.tf = [];
                        g.dormindo{j}.xf = [];
                        g.dormindo{j}.yf = []; 
                    end
                    g.dormindo{j}.ti = [g.dormindo{j}.ti handles.e(i).dormindo{j}.ti];
                    g.dormindo{j}.xi = [g.dormindo{j}.xi handles.e(i).dormindo{j}.xi];
                    g.dormindo{j}.yi = [g.dormindo{j}.yi handles.e(i).dormindo{j}.yi];
                    g.dormindo{j}.tf = [g.dormindo{j}.tf handles.e(i).dormindo{j}.tf];
                    g.dormindo{j}.xf = [g.dormindo{j}.xf handles.e(i).dormindo{j}.xf];
                    g.dormindo{j}.yf = [g.dormindo{j}.yf handles.e(i).dormindo{j}.yf];
                end
            end
            %percorre o vetor verificando se o peixe permaceu dentro de uma
            %area de um experimento pra outro. nesse caso, junta a entrada
            %na area em uma so
            for k=1:nareas
                if i == 1
                    g.tempoareas{j,k}.ti = handles.e(i).tempoareas{j,k}.ti;
                    g.tempoareas{j,k}.tf = handles.e(i).tempoareas{j,k}.tf;
                else
                    if handles.e(i).tempoareas{j,k}.tf(1)~= 0 %entrou alguma vez
                        if g.tempoareas{j,k}.tf(end) ~= handles.e(i).tempoareas{j,k}.ti(1)
                            if g.tempoareas{j,k}.tf(1)==0
                                g.tempoareas{j,k}.ti = [];
                                g.tempoareas{j,k}.tf = [];
                            end
                            g.tempoareas{j,k}.ti = [g.tempoareas{j,k}.ti handles.e(i).tempoareas{j,k}.ti];
                            g.tempoareas{j,k}.tf = [g.tempoareas{j,k}.tf handles.e(i).tempoareas{j,k}.tf];
                        else
                            if g.tempoareas{j,k}.tf(1)==0
                                g.tempoareas{j,k}.ti = [];
                                g.tempoareas{j,k}.tf = [];
                            end
                            g.tempoareas{j,k}.ti = [g.tempoareas{j,k}.ti handles.e(i).tempoareas{j,k}.ti(2:end)];
                            g.tempoareas{j,k}.tf = [g.tempoareas{j,k}.tf(1:end-1) handles.e(i).tempoareas{j,k}.tf];

                        end
                    end
                end
            end
            
        end   
   end
   g.areaproc = handles.e(1).areaproc;
   g.pxcm = handles.e(1).pxcm;
   g.figdimensions = handles.e(1).figdimensions;
   g.directory = handles.e(1).directory;
   g.filename = handles.e(1).filename;
   g.areaint = handles.e(1).areaint;
%    g.report = handles.e(1).report;
%    g.basicinfo = handles.e(1).basicinfo;
%    g.animalplot = handles.e(1).animalplot;
%    g.areainfo = handles.e(1).areainfo;
%    g.behaviourinfo = handles.e(1).behaviourinfo;
%    g.fouriertransf = handles.e(1).fouriertransf;
%    g.distpointinfo = handles.e(1).distpointinfo;
%    g.distlineinfo = handles.e(1).distlineinfo;
%    g.animalplot3D = handles.e(1).animalplot3D;
%    g.backgplot = handles.e(1).backgplot;
   
   
end
%perguntar de quantos em quantos segundos
%split = inputdlg('Split the experiment into several with how many seconds each:');

%salva em e
handles.e = g;
guidata(hObject, handles);

    

end
% --- Executes on button press in angularvelocity.
function angularvelocity_Callback(hObject, eventdata, handles)
% hObject    handle to angularvelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of angularvelocity

end
% --- Executes on slider movement.
function angvelthres_Callback(hObject, eventdata, handles)
% hObject    handle to angvelthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.vangvelthres,'String',num2str(floor(get(handles.angvelthres,'Value')*90)));
end

% --- Executes during object creation, after setting all properties.
function angvelthres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angvelthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


end
function vangvelthres_Callback(hObject, eventdata, handles)
% hObject    handle to vangvelthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vangvelthres as text
%        str2double(get(hObject,'String')) returns contents of vangvelthres as a double

end
% --- Executes during object creation, after setting all properties.
function vangvelthres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vangvelthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --------------------------------------------------------------------
function uipanel2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.showrate,'String',num2str(round(get(handles.slider11,'Value'))));
guidata(hObject, handles);

end
% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


end
function showrate_Callback(hObject, eventdata, handles)
% hObject    handle to showrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider11,'Value',str2double(get(handles.showrate,'String')));
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of showrate as text
%        str2double(get(hObject,'String')) returns contents of showrate as a double

end
% --- Executes during object creation, after setting all properties.
function showrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in HeatMap.
function HeatMap_Callback(hObject, eventdata, handles)
% hObject    handle to HeatMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HeatMap
end

% --- Executes on button press in pushbuttonLive_Tracking.
function pushbuttonLive_Tracking_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLive_Tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%------------------------checkbox-----------------------
% Create a figure window:

hardwareInfo = imaqhwinfo('winvideo');

fig = uifigure('Position',[100 100 229 276]);

bg = uibuttongroup('Parent',fig,...
    'Position',[56 77 123 85]);

for i=1:length(hardwareInfo.DeviceIDs)
    hi = imaqhwinfo('winvideo', [i]);
    rb1 = uiradiobutton(bg,'Position',[10 (60+(i*5)) 120 15]);
    rb1.Text = hi.DefaultFormat;
end

%-------------------------------------------------------
% Setando a flag do live tracking
handles.live = true;
handles.video = [];
handles.frameRate = 1;
%cria objeto de video
videoLive = videoinput('winvideo');
triggerconfig(videoLive, 'manual');
%Criando o fundo ao vivo e salvando na pasta do zebtrack
p = imread('processando.jpeg');
axes(handles.axes3);
imshow(p);
drawnow;
handles.waibarfundo.visivel('on');
[fundo, V] = criaFundoAoVivo(handles.waibarfundo);

%passando a referÃªncia do objeto videoinput para o handles
handles.videoLive = videoLive;
handles.filenameSemExtensao = 'live';
handles.directoryname = './live';
set(handles.run,'Enable','on');
set(handles.abortar,'Visible','on');

%track(visu, finitemp, ffimtemp, handles.directoryname, handles.video, pxcm, np, procf, handles.areaproc, handles.areaint, handles.areaexc, criavideores, mostradiff, thresh, filt, handles, fundodina, tipfilt, tipsubfundo, velmin, tempmin, tempminparado, subcor, camlent, trackmouse, liveTracking, trackindividuals, centroids, cov_matrices, actions);

handles.frameini=1;
handles.framefim=20;

%liga o fundo dinâmico por padrão
set(handles.fundodinamico,'Value',true);   %descomentar quando a criacao
%de fundo estiver criand o V certinho

set(handles.apclick,'Enable','off')
set(handles.aiclick,'Enable','off')
set(handles.btareaintlimpar,'Enable','off')
set(handles.aeclick,'Enable','off')
set(handles.btareaexclimpar,'Enable','off')
set(handles.calcpxcm,'Enable','off')

axes(handles.axes1);
cla reset
set(handles.axes1,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes2);
cla reset
set(handles.axes2,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes3);
cla reset
set(handles.axes3,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');
axes(handles.axes4);
cla reset
set(handles.axes4,'Color','w','XTick',[],'YTick',[],'XColor','w','YColor','w');

[l,c,~]=size(fundo);
handles.c = c;
handles.l = l;
handles.fundo = fundo;
handles.V = V;
axes(handles.axes3);
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes3_ButtonDownFcn);
axes(handles.axes4);
hold off
fundohandle = imshow(fundo);
set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
handles.waibarfundo.setvalue(0);
handles.waibarfundo.visivel('off');

%area de processamento na imagem toda
handles.areaproc.x(1) = 1;
handles.areaproc.y(1) = 1;
handles.areaproc.x(2) = handles.c;
handles.areaproc.y(2) = 1;
handles.areaproc.x(3) = handles.c;
handles.areaproc.y(3) = handles.l;
handles.areaproc.x(4) = 1;
handles.areaproc.y(4) = handles.l;
handles.areaproc.x(5) = 1;
handles.areaproc.y(5) = 1;

guidata(hObject, handles);

visualizar_Callback(hObject, eventdata, guidata(hObject))


handles=guidata(hObject);
guidata(hObject,handles);
guidata(hObject,handles);

end
% --- Executes on button press in pushbuttonTrack_Ind.
function pushbuttonTrack_Ind_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTrack_Ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%{
frameini = (str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')))*handles.frameRate + 1;
framefim = (str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')))*handles.frameRate;
%}

tempoini = (str2double(get(handles.tinimin,'String'))*60 + str2double(get(handles.tiniseg,'String')));
tempofini = (str2double(get(handles.tfimmin,'String'))*60 + str2double(get(handles.tfimseg,'String')));

nanimais = str2double(get(handles.npeixes,'String'));
tipsubfundo = get(handles.radiosfe,'Value');
thresh = round(get(handles.slider3,'Value'));
filt = get(handles.slider4,'Value');
tipfilt = get(handles.radiofk,'Value');
subcor = get(handles.subtracaocolorida,'Value');

mascara = calculamascara(handles.areaproc,handles.areaexc,double(rgb2gray(handles.fundo)));
minpix = 2;
maxpix = 0; %se o tamanho maximo for zero, fica sendo 50% da imagem
avi=0;
criavideores=0;
 value_threshold = 0.15;
 saturation_threshold = 0.5;
 how_many_replicates = 5;
cor = 3;
%disp(['frameini = ', int2str(frameini), '\nframefinal = ',int2str(framefim )]);

%converte pra tons de cinza e double pra trabalhar
if subcor 
           Imback = double(handles.fundo);
else
           Imback = double(rgb2gray(handles.fundo));
end      

[centroids, cov_matrices] = calcula_centroids_cov_rgb(handles.video, tempoini, tempofini ...
                                                       , Imback, handles.V, nanimais, mascara, minpix, maxpix, thresh, avi, criavideores, tipsubfundo ...
                                                       , subcor, cor ...
						       , value_threshold, saturation_threshold, how_many_replicates, handles); 

%{
load('C:\Users\mateu\Documents\zebtrack\ZebTrack\test_variables_and_results\variaveis_calculaMediaVarianciaHSV.mat','Vrm') %loading Vrm 
[centroids, cov_matrices] = calcula_centroids_cov_rgb(handles.video, tempoini, tempofini ...
                                                       , Imback, Vrm, nanimais, mascara, minpix, maxpix, thresh, avi, criavideores, tipsubfundo ...
                                                       , subcor, cor ...
						       , value_threshold, saturation_threshold, how_many_replicates, handles);                                                       
%}                                                       
                                                   
                                                   
handles.waibarfundo.visivel('off');
handles.waibarfundo.setvalue(0);
handles.centroids = centroids;
handles.cov_matrices = cov_matrices;
centroids; %mostrar cores achadas no console
%V_pos = handles.V;  % usado durante o save, abaixo. Remover depois
%save('V_pos_apagar_coisas_da_pasta_raiz','V_pos','mascara'); %remover depois
%ajeitar o codigo. do jeito que esta nao ira funcionar
%mostra_cores_dos_peixes(centoids, cov_matrices)
for ite=1:1:nanimais
    figure('Name',['Cor Associada ao Centroide ',int2str(ite)],'NumberTitle','off');
    image(reshape(uint8(centroids(ite,:)),[1,1,3]));
    %disp(['variancia{',int2str(ite),'} = ']);
    cov_matrices{ite};
end

guidata(hObject,handles);
end
% --- Executes on button press in checkboxTrack_Ind.
function checkboxTrack_Ind_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTrack_Ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of checkboxTrack_Ind

end
% --- Executes on button press in areasequence.
function areasequence_Callback(hObject, eventdata, handles)
% hObject    handle to areasequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of areasequence

end
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ind = get(handles.popupmenu2,'Value');
%str = get(handles.popupmenu2,'String');
%disp(str(ind));
set(handles.uipanel13,'Visible','on');
set(handles.uipanel9,'Visible','off');
set(handles.uipanel7,'Visible','off');
set(handles.uipanel10,'Visible','off');
set(handles.uipanel21,'Visible','off');
ls = instrhwinfo('serial');
temp_cellstr = ls.AvailableSerialPorts';
set(handles.serialports,'String',temp_cellstr);
guidata(hObject,handles);


end
function devicename_Callback(hObject, eventdata, handles)
% hObject    handle to devicename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of devicename as text
%        str2double(get(hObject,'String')) returns contents of devicename as a double

end
% --- Executes during object creation, after setting all properties.
function devicename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to devicename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in serialports.
function serialports_Callback(hObject, eventdata, handles)
% hObject    handle to serialports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serialports contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serialports
end

% --- Executes during object creation, after setting all properties.
function serialports_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel21,'Visible','on');
set(handles.uipanel13,'Visible','off');
set(handles.uipanel9,'Visible','off');
set(handles.uipanel7,'Visible','off');
set(handles.uipanel10,'Visible','off');
guidata(hObject,handles);

end
% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.nactions<10
    handles.nactions = handles.nactions + 1;
    n = length(handles.areaint);
    if n>0
        for i =1:n
            temp_cellstr{i} = num2str(i);
        end
         eval(['set(handles.popupmenu' num2str(3*handles.nactions+1) ',''String'',temp_cellstr);'])
        %fazer aparecer as caixas
        for i=3*handles.nactions:3*handles.nactions+2
           eval(['set(handles.popupmenu' num2str(i) ',''Visible'',''on'');']);
        end
    else
        warndlg('Create some areas of interest first!')
    end
end
guidata(hObject,handles);
end
% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.nactions>0
    for i=3*handles.nactions:3*handles.nactions+2
       eval(['set(handles.popupmenu' num2str(i) ',''Visible'',''off'');']);
    end
    handles.nactions = handles.nactions - 1;
end
guidata(hObject,handles);
end
% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
end

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
end

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8

end
% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9

end
% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10

end
% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11

end
% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12

end
% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13

end
% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14
end

% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15

end
% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16
end

% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17

end
% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18

end
% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19

end
% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu20.
function popupmenu20_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20

end
% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21
end

% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22

end
% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu23.
function popupmenu23_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu23 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu23
end

% --- Executes during object creation, after setting all properties.
function popupmenu23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu24.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu24 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu24

end
% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu25.
function popupmenu25_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu25 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu25

end
% --- Executes during object creation, after setting all properties.
function popupmenu25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu26.
function popupmenu26_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu26 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu26

end
% --- Executes during object creation, after setting all properties.
function popupmenu26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu27.
function popupmenu27_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu27 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu27

end
% --- Executes during object creation, after setting all properties.
function popupmenu27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu28.
function popupmenu28_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu28 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu28

end
% --- Executes during object creation, after setting all properties.
function popupmenu28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu29.
function popupmenu29_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu29 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu29

end
% --- Executes during object creation, after setting all properties.
function popupmenu29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu30.
function popupmenu30_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu30 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu30
end

% --- Executes during object creation, after setting all properties.
function popupmenu30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu31.
function popupmenu31_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu31 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu31

end
% --- Executes during object creation, after setting all properties.
function popupmenu31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu32.
function popupmenu32_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu32 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu32

end
% --- Executes during object creation, after setting all properties.
function popupmenu32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu33.
function popupmenu33_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu33 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu33
end

% --- Executes during object creation, after setting all properties.
function popupmenu33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on selection change in popupmenu34.
function popupmenu34_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu34 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu34
end

% --- Executes during object creation, after setting all properties.
function popupmenu34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double
end

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in btareagrid.
function btareagrid_Callback(hObject, eventdata, handles)
% hObject    handle to btareagrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.definirapc = 17;
handles.clickini = [0 0];
set(handles.mensagem,'String','Click on the starting vertex of the grid (left upper corner):');
set(handles.mensagem,'Visible','on');
set(handles.posicaomouse,'Visible','on');
set(handles.posicaomouse2,'Visible','on');
set(handles.figure1,'WindowButtonMotionFcn', @axes4_ButtonMotionFcn);
% Update handles structure
guidata(hObject, handles);
end

% --- Executes on button press in csvProcessButton.
function csvProcessButton_Callback(hObject, eventdata, handles)
    % Variable to indicate completion status
    handles.processingComplete1 = false;
    
    % Verificar se já existe um caminho para o arquivo CSV em handles
    if isfield(handles, 'csv_file_path') && ~isempty(handles.csv_file_path)
        % Usar o caminho fornecido pela CreateProjectButton_Callback
        fullpath = handles.csv_file_path;
    else
        % Abrir a janela de seleção de arquivo, caso não tenha sido fornecido
        [file, path] = uigetfile('*.csv', 'Select CSV file');
        if isequal(file, 0)
            disp('User selected Cancel');
            return; % Saída da função caso o usuário cancele a operação
        else
            fullpath = fullfile(path, file);
            % Armazenar o caminho do arquivo CSV em handles
            handles.csv_file_path = fullpath;
            guidata(hObject, handles);
        end
    end
    
    % Ler o arquivo CSV e processar as informações
    csvData = readtable(fullpath);
    
    % Extraia as coordenadas x e y do arquivo CSV
    x_coords = csvData{:, 1};
    y_coords = csvData{:, 2};
    
    % Inicializa a definição da área de processamento
    handles.definirapc = 1;
    handles.nvertice = 1;
    handles.areaproc.x = [];
    handles.areaproc.y = [];
    handles.clickini = [0 0];
    
    % Atualiza a área de processamento com as coordenadas
    handles = updateProcessingArea(handles, x_coords, y_coords);
          
    % Set the processing complete flag to true
    handles.processingComplete1 = true;
    
    % Atualiza a estrutura handles
    guidata(hObject, handles);
end




function handles = updateProcessingArea(handles, x_coords, y_coords)
    for i = 1:length(x_coords)
        handles.areaproc.x(handles.nvertice) = x_coords(i);
        handles.areaproc.y(handles.nvertice) = y_coords(i);
        handles.nvertice = handles.nvertice + 1;
    end
    
    % Simular o duplo clique no último ponto para fechar o polígono
    handles.areaproc.x(handles.nvertice) = handles.areaproc.x(1);
    handles.areaproc.y(handles.nvertice) = handles.areaproc.y(1);
    
    handles.definirapc = 0;  % Finalizar a definição da área de processamento
    
    % Adiciona os vértices à área de processamento e desenha as linhas
    axes(handles.axes4);
    hold off;
    fundohandle = imshow(handles.fundo);
    set(fundohandle, 'ButtonDownFcn', @axes4_ButtonDownFcn);
    hold on; 
    
    desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
    desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
    desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
end







% --- Executes on button press in csvInterestAreasButton.
function csvInterestAreasButton_Callback(hObject, eventdata, handles)
% hObject    handle to csvInterestAreasButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.processingComplete2 = false;
    % Abrir a janela de seleção de arquivo, se necessário
    if ~isfield(handles, 'csv_interest_areas_path') || isempty(handles.csv_interest_areas_path)
        [file, path] = uigetfile('*.csv', 'Select CSV file for Interest Areas');
        if isequal(file, 0)
            disp('User selected Cancel');
            return;
        else
            fullpath = fullfile(path, file);
        end
    else
        % Usar o caminho salvo no handles
        fullpath = handles.csv_interest_areas_path;
    end
    
    % Ler o arquivo CSV
    csvData = readtable(fullpath);
    
    % Inicializa a definição das áreas de interesse
    handles.definirapc = 3;
    
    % Processa cada linha do CSV
    for i = 1:height(csvData)
        % Extraia as coordenadas x e y do arquivo CSV
        x1 = csvData{i, 2};
        y1 = csvData{i, 3};
        x2 = csvData{i, 4};
        y2 = csvData{i, 5};
        
        % Define os quatro vértices do quadrado
        x_coords = [x1, x2, x2, x1, x1];
        y_coords = [y1, y1, y2, y2, y1];
        
        % Atualiza as áreas de interesse com as coordenadas
        handles = updateInterestAreas(handles, x_coords, y_coords);
    end
    
    % Setar a variável de conclusão de processamento para true
    handles.processingComplete2 = true;
    
    % Atualiza a estrutura handles
    guidata(hObject, handles);
end


function handles = updateInterestAreas(handles, x_coords, y_coords)
    % Adiciona os vértices às áreas de interesse
    n = length(handles.areaint) + 1;
    
    handles.areaint(n).x = x_coords;
    handles.areaint(n).y = y_coords;
    
    % Atualizar a área de interesse
    axes(handles.axes4);
    hold off;
    fundohandle = imshow(handles.fundo);
    set(fundohandle,'ButtonDownFcn', @axes4_ButtonDownFcn);
    hold on;
    
    % Redesenhar todas as áreas
    desenha_areas(handles.areaproc,@axes4_ButtonDownFcn,'g',-1);  
    desenha_areas(handles.areaexc,@axes4_ButtonDownFcn,'r',-1);
    desenha_areas(handles.areaint,@axes4_ButtonDownFcn,'b',1);
    
    % Atualiza a estrutura handles
    guidata(handles.axes4, handles);
end


function txtWidth_Callback(hObject, eventdata, handles)
% hObject    handle to txtWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtWidth as text
%        str2double(get(hObject,'String')) returns contents of txtWidth as a double

end
% --- Executes during object creation, after setting all properties.
function txtWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


end
function txtHeight_Callback(hObject, eventdata, handles)
% hObject    handle to txtHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtHeight as text
%        str2double(get(hObject,'String')) returns contents of txtHeight as a double

end
% --- Executes during object creation, after setting all properties.
function txtHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in btnSetPixelCm.
function btnSetPixelCm_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetPixelCm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Obter as medidas fornecidas pelo usuário

    global endsize;
    endsize = 0;
    width_cm = str2double(get(handles.txtWidth, 'String'));
    height_cm = str2double(get(handles.txtHeight, 'String'));

    % Verificar se as medidas são válidas
    if isnan(width_cm) || isnan(height_cm) || width_cm <= 0 || height_cm <= 0
        errordlg('Please enter valid positive numbers for width and height.');
        return;
    end

    % Verificar se a área de processamento está definida
    if isempty(handles.areaproc)
        errordlg('Please define the processing area first.');
        return;
    end

    % Calcular as maiores distâncias entre os pontos extremos da área de processamento
    x_coords = handles.areaproc.x;
    y_coords = handles.areaproc.y;
    max_width_pixels = max(x_coords) - min(x_coords);
    max_height_pixels = max(y_coords) - min(y_coords);

    % Calcular a relação pixel/cm
    pxcmx = max_width_pixels / width_cm;
    pxcmy = max_height_pixels / height_cm;

    % Atualizar as caixas de texto de pixel/cm
    set(handles.pxcmx, 'String', num2str(pxcmx));
    set(handles.pxcmy, 'String', num2str(pxcmy));

    % Desabilitar as caixas de texto de medidas
    set(handles.txtWidth, 'Enable', 'off');
    set(handles.txtHeight, 'Enable', 'off');

    
    endsize = 1;
    % Atualizar a estrutura handles
    guidata(hObject, handles);
end


% --- Executes on button press in CreatProjectButton.
function CreatProjectButton_Callback(hObject, eventdata, handles)
    % hObject    handle to CreatProjectButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global project_running;
    global project_xlsx_path;
    global project_name;
    global project_folder_path;
    global num_subfolders;
    
        % Toggle project_running status
        if isempty(project_running) || ~project_running
            % Project is not running; start it
            project_running = true;
            set(hObject, 'String', 'Terminar Projeto');
            
            % Ask the user to select the folder
            folder_name = uigetdir('', 'Escolha a pasta do projeto:');
            if folder_name == 0 % User pressed Cancel
                project_running = false;
                set(hObject, 'String', 'Criar Projeto');
                return;
            end
            
            % Store the folder path for future use
            project_folder_path = folder_name;
            
            % Create xlsx file in the chosen folder
            project_name = strcat(extractAfter(folder_name, max(strfind(folder_name, filesep))), '_Planilha_Unificada');
            xlsx_path = fullfile(folder_name, strcat(project_name, '.xlsx'));
            %create_excel_file(xlsx_path);
            project_xlsx_path = xlsx_path; % Salvar o caminho do arquivo do projeto para uso posterior
            
            % Verify the content of the folder
            folder_content = dir(project_folder_path);
            % Note: MATLAB lists folder content in alphabetical order (A-Z) by default.
            % The order includes '.' and '..' at the beginning, followed by the files and subfolders in alphabetical order.
    
            % Count the number of subfolders
            num_subfolders = sum([folder_content.isdir]) - 2; % Subtracting 2 to ignore '.' and '..'
            
            % Access the first subfolder in alphabetical order
            subfolder_names = {folder_content([folder_content.isdir]).name};
            subfolder_names = subfolder_names(~ismember(subfolder_names, {'.', '..'})); % Remove '.' and '..'
            first_subfolder_name = subfolder_names{1};
            first_subfolder_path = fullfile(project_folder_path, first_subfolder_name);
            
            % Search for the only .mp4 file in the first subfolder
            subfolder_content = dir(fullfile(first_subfolder_path, '*.mp4'));
            if numel(subfolder_content) == 1
                video_file_path = fullfile(first_subfolder_path, subfolder_content(1).name);
            else
                video_file_path = '';
            end
            
            % Store the paths in handles for future use
            handles.subfolder_path = first_subfolder_path;
            handles.video_file_path = video_file_path;
            handles.directoryname = first_subfolder_path; % Definir o caminho da subpasta onde o vídeo está localizado
            handles.filename = subfolder_content(1).name; % Nome do arquivo de vídeo encontrado
            guidata(hObject, handles); % Save the updated handles structure
            
            handles.processingComplete = false;
    
            % Call btbrowse_Callback to process the video
            btbrowse_Callback(hObject, eventdata, handles);
            
            % Wait until btbrowse processing is complete
            while ~handles.processingComplete
                pause(0.1); % Small delay to avoid CPU overload
                handles = guidata(hObject); % Update handles to check the latest status
            end
            
            % Proceed with the next steps after processing is complete
            disp('Video Processing completed. Proceeding to the next step...');
            
            % Search for the CSV file that starts with "1_" in the first subfolder
            csv_file_content = dir(fullfile(first_subfolder_path, '1_*.csv'));
            if numel(csv_file_content) == 1
                csv_file_path = fullfile(first_subfolder_path, csv_file_content(1).name);
                
                % Store the CSV path in handles for future use
                handles.csv_file_path = csv_file_path;
                guidata(hObject, handles); % Save the updated handles structure
                
                handles.processingComplete1 = false;
    
                % Call csvProcessButton_Callback to process the CSV data
                csvProcessButton_Callback(hObject, eventdata, handles);
                
                % Wait until csvProcessButton processing is complete
                while ~handles.processingComplete1
                    pause(0.1); % Small delay to avoid CPU overload
                    handles = guidata(hObject); % Update handles to check the latest status
                end
                
                % Proceed with further steps after CSV processing is complete
                disp('Processing Area defined by csv file. Proceeding to the next step...');
                
            else
                disp('No CSV file found starting with "1_" in the first subfolder.');
            end
                
            % Search for the CSV file that starts with "2_" in the first subfolder
            csv_interest_areas_content = dir(fullfile(first_subfolder_path, '2_*.csv'));
            if numel(csv_interest_areas_content) == 1
                csv_interest_areas_path = fullfile(first_subfolder_path, csv_interest_areas_content(1).name);
                    
                % Store the CSV path in handles for future use
                handles.csv_interest_areas_path = csv_interest_areas_path;
                guidata(hObject, handles); % Save the updated handles structure
                    
                handles.processingComplete2 = false;
                    
                % Call csvInterestAreasButton_Callback to process the Interest Areas CSV data
                csvInterestAreasButton_Callback(hObject, eventdata, handles);
                    
                % Wait until csvInterestAreasButton processing is complete
                while ~handles.processingComplete2
                    pause(0.1); % Small delay to avoid CPU overload
                    handles = guidata(hObject); % Update handles to check the latest status
                end
                    
                % Proceed with further steps after CSV interest areas processing is complete
                disp('Areas of Interest defined by csv file. Proceeding to the next step...');
            else
                disp('No CSV file found starting with "2_" in the first subfolder.');
            end
            
    
            % Chamar a janela de diálogo para obter as medidas do aquário
            openAquariumDimensionsDialog(handles);
            global endsize;
            endsize = 0;
            while endsize ~= 1
                    pause(0.1); % Small delay to avoid CPU overload
                    handles = guidata(hObject); % Update handles to check the latest status
            end
            % Proceed with further steps after CSV processing is complete
            disp('Size of Aquarium defined. Proceeding to the next step...');

            % Search for the CSV file that starts with "3_" in the first subfolder
            csv_position_data_content = dir(fullfile(first_subfolder_path, '3_*.csv'));
            if numel(csv_position_data_content) == 1
                csv_position_data_path = fullfile(first_subfolder_path, csv_position_data_content(1).name);
    
                % Store the CSV path in handles for future use
                handles.csv_position_data_path = csv_position_data_path;
                guidata(hObject, handles); % Save the updated handles structure
    
                handles.processingComplete3 = false;
    
                % Call csvPositionDataButton_Callback to process the Position Data CSV
                csvPositionDataButton_Callback(hObject, eventdata, handles);
    
                % Wait until csvPositionDataButton processing is complete
                while ~handles.processingComplete3
                    pause(0.1); % Small delay to avoid CPU overload
                    handles = guidata(hObject); % Update handles to check the latest status
                end
    
                % Proceed with further steps after CSV position data processing is complete
                disp('Tracking Data obtained in csv file. Proceeding to the next step...');
            else
                disp('No CSV file found starting with "3_" in the first subfolder.');
            end
            %global appendExcelEnd;
            %appendExcelEnd = 0;
            %while appendExcelEnd ~= 1
             %       pause(0.1); % Small delay to avoid CPU overload
              %      handles = guidata(hObject); % Update handles to check the latest status
            %end

            % Iterar sobre todas as subpastas restantes
            for idx = 2:length(subfolder_names)
                % Obter o caminho da subpasta atual
                current_subfolder_name = subfolder_names{idx};
                current_subfolder_path = fullfile(project_folder_path, current_subfolder_name);
    
                % Buscar o único arquivo mp4 na subpasta atual
                current_subfolder_content = dir(fullfile(current_subfolder_path, '*.mp4'));
                if numel(current_subfolder_content) == 1
                    current_video_file_path = fullfile(current_subfolder_path, current_subfolder_content(1).name);
        
                    % Atualizar os handles com as informações do vídeo atual
                    handles.subfolder_path = current_subfolder_path;
                    handles.video_file_path = current_video_file_path;
                    handles.directoryname = current_subfolder_path; % Definir o caminho da subpasta onde o vídeo está localizado
                    handles.filename = current_subfolder_content(1).name; % Nome do arquivo de vídeo encontrado
                    guidata(hObject, handles); % Atualizar a estrutura handles
        
                    handles.processingComplete = false;
                    btbrowse_Callback(hObject, eventdata, handles);
        
                    % Aguardar o processamento de btbrowse
                    while ~handles.processingComplete
                        pause(0.1); % Pequeno delay para evitar sobrecarga de CPU
                        handles = guidata(hObject); % Atualizar handles para verificar o status mais recente
                    end
        
                    % Confirmar que o processamento foi concluído e continuar
                    disp(['Video Processing completed in subfolder: ' current_subfolder_name '. Proceeding to the next step...']);
                            
                else
                    disp(['No .mp4 file found in subfolder: ' current_subfolder_name '. Skipping this folder.']);
                end

                % Buscar o arquivo CSV que começa com "1_" na subpasta atual
                csv_file_content = dir(fullfile(current_subfolder_path, '1_*.csv'));
                if numel(csv_file_content) == 1
                    csv_file_path = fullfile(current_subfolder_path, csv_file_content(1).name);

                    % Armazenar o caminho do CSV no handles para uso futuro
                    handles.csv_file_path = csv_file_path;
                    guidata(hObject, handles); % Salvar a estrutura handles atualizada

                    handles.processingComplete1 = false;

                    % Chamar csvProcessButton_Callback para processar os dados do CSV
                    csvProcessButton_Callback(hObject, eventdata, handles);

                    % Aguardar o processamento de csvProcessButton
                    while ~handles.processingComplete1
                        pause(0.1); % Pequeno delay para evitar sobrecarga de CPU
                        handles = guidata(hObject); % Atualizar handles para verificar o status mais recente
                    end

                    % Confirmar que o processamento foi concluído e continuar
                    disp(['Processing Area defined by csv file in subfolder: ' current_subfolder_name '. Proceeding to the next step...']);
                else
                    disp(['No CSV file found starting with "1_" in subfolder: ' current_subfolder_name '. Skipping this step.']);
                end

                % Buscar o arquivo CSV que começa com "3_" na subpasta atual
                csv_position_data_content = dir(fullfile(current_subfolder_path, '3_*.csv'));
                if numel(csv_position_data_content) == 1
                    csv_position_data_path = fullfile(current_subfolder_path, csv_position_data_content(1).name);
            
                    % Armazenar o caminho do CSV no handles para uso futuro
                    handles.csv_position_data_path = csv_position_data_path;
                    guidata(hObject, handles); % Salvar a estrutura handles atualizada
            
                    handles.processingComplete3 = false;
                    disp(['Tracking Data obtained in csv file in subfolder: ' current_subfolder_name '. Proceeding to the next step...']);
                    % Chamar csvPositionDataButton_Callback para processar os dados de Posição do CSV
                    csvPositionDataButton_Callback(hObject, eventdata, handles);
            
                    % Aguardar o processamento de csvPositionDataButton
                    while ~handles.processingComplete3
                        pause(0.1); % Pequeno delay para evitar sobrecarga de CPU
                        handles = guidata(hObject); % Atualizar handles para verificar o status mais recente
                    end
            
                    % Confirmar que o processamento foi concluído e continuar
                    disp(['Processing Data of ' current_subfolder_name ' ENDED. Initiating next animal...']);
                else
                    disp(['No CSV file found starting with "3_" in subfolder: ' current_subfolder_name '. Skipping this step.']);
                end

                %appendExcelEnd = 0;
                %while appendExcelEnd ~= 1
                %    pause(0.1); % Small delay to avoid CPU overload
                %    handles = guidata(hObject); % Update handles to check the latest status
                %end
                

            end
            disp('Fim de processamento de todas pastas do Projeto.')
            % Criação da janela de finalização do projeto
            fj = figure('Name', 'Fim dos Processamentos', 'NumberTitle', 'off', 'MenuBar', 'none', ...
                       'ToolBar', 'none', 'Position', [500, 500, 300, 150], 'WindowStyle', 'modal');

            % Texto para indicar o fim dos processamentos
            uicontrol('Parent', fj, 'Style', 'text', 'Position', [50, 80, 200, 40], ...
                      'String', 'Fim dos processamentos!', 'FontSize', 12, 'HorizontalAlignment', 'center');

            % Botão para terminar o projeto
            uicontrol('Parent', fj, 'Style', 'pushbutton', 'String', 'Terminar Projeto', ...
                      'Position', [100, 20, 100, 30], 'Callback', @(~, ~) finalizarProjeto(fj, hObject, handles));

            
        else
            % Project is running; end it
            project_running = false;
            set(hObject, 'String', 'Criar Projeto');
      end
end

% Função callback para o botão "Terminar Projeto"
function finalizarProjeto(fig_handle, hObject, handles)
    global project_running;
    project_running = false;

    % Encontrar o botão com a tag 'CreatProjectButton'
    botaoCriarProjeto = findobj(fig_handle, 'Tag', 'CreatProjectButton');

    % Alterar o texto do botão encontrado
    set(botaoCriarProjeto, 'String', 'Criar Projeto');
    
    % Fechar a janela modal
    close(fig_handle);
end

% Criação da função openAquariumDimensionsDialog
function openAquariumDimensionsDialog(handles)
    % Criar a janela de diálogo
    f = figure('Name', 'Medidas do Aquário', 'NumberTitle', 'off', 'MenuBar', 'none', ...
        'ToolBar', 'none', 'Position', [500, 500, 300, 200], 'WindowStyle', 'modal');

    % Texto para perguntar as medidas do aquário
    uicontrol('Parent', f, 'Style', 'text', 'Position', [50, 150, 200, 30], ...
        'String', 'Medidas do aquário:', 'FontSize', 12);

    % Rótulo para Largura
    uicontrol('Parent', f, 'Style', 'text', 'Position', [30, 100, 100, 20], ...
        'String', 'Largura (cm):', 'HorizontalAlignment', 'left');

    % Caixa de texto para Largura
    txtWidthInput = uicontrol('Parent', f, 'Style', 'edit', 'Position', [150, 100, 100, 20]);

    % Rótulo para Altura
    uicontrol('Parent', f, 'Style', 'text', 'Position', [30, 60, 100, 20], ...
        'String', 'Altura (cm):', 'HorizontalAlignment', 'left');

    % Caixa de texto para Altura
    txtHeightInput = uicontrol('Parent', f, 'Style', 'edit', 'Position', [150, 60, 100, 20]);

    % Botão OK
    btnOK = uicontrol('Parent', f, 'Style', 'pushbutton', 'String', 'OK', ...
        'Position', [100, 20, 100, 30], 'Callback', {@btnOK_Callback, handles, txtWidthInput, txtHeightInput, f});
end

% Callback do botão OK
function btnOK_Callback(~, ~, handles, txtWidthInput, txtHeightInput, f)
    % Recuperar os valores de largura e altura inseridos
    largura = str2double(get(txtWidthInput, 'String'));
    altura = str2double(get(txtHeightInput, 'String'));

    % Verificar se os valores são válidos
    if isnan(largura) || isnan(altura) || largura <= 0 || altura <= 0
        errordlg('Por favor, insira valores válidos para largura e altura.', 'Erro');
        return;
    end

    % Atualizar os elementos de interface gráfica da GUI principal
    set(handles.txtWidth, 'String', num2str(largura));
    set(handles.txtHeight, 'String', num2str(altura));
    
    % Chamar a função que precisa ser executada
    btnSetPixelCm_Callback(f, [], handles);

    % Fechar a janela de entrada de medidas
    close(f);
end

% This function creates the Excel file with the default structure
function create_excel_file(file_path)
    global tj;
    
    if isempty(tj)
        headers = {'Column1', 'Column2', 'Column3', 'Column4'};
        disp("Aviso: `t` está vazio. Usando cabeçalho padrão em create_excel_file.");
    else
        headers = tj; % Utilize os cabeçalhos armazenados em `t`
    end
    
    data = cell(1, numel(headers)); % Dados vazios para inicialização
    writecell([headers; data], file_path);
    %disp("Arquivo Excel criado com cabeçalhos:");
    %disp(headers); % Exibir cabeçalhos usados
end

function append_to_excel_file(source_xlsx, destination_xlsx)
    global appendExcelEnd;
    appendExcelEnd = 0;
    % Lê os dados do arquivo fonte
    raw = readcell(source_xlsx);

    % Lê os dados atuais do arquivo destino
    existing_raw = readcell(destination_xlsx);

    % Obter cabeçalhos dos dois arquivos
    source_headers = raw(1, :);
    if ~isempty(existing_raw)
        destination_headers = existing_raw(1, :);
        %disp("Cabeçalhos do arquivo de destino:");
        %disp(destination_headers);
    else
        destination_headers = source_headers;
        disp("Inicializando o arquivo de destino com os cabeçalhos do arquivo de origem.");
    end
    
    % Verificar compatibilidade dos cabeçalhos
    if ~isequal(source_headers, destination_headers)
        disp('Erro: Os cabeçalhos do arquivo de origem são incompatíveis com os do arquivo unificado do projeto.');
        disp("Cabeçalhos de origem:");
        disp(source_headers);
        disp("Cabeçalhos de destino:");
        disp(destination_headers);
        return;
    end

    % Adicionar os dados ao arquivo unificado
    if isempty(existing_raw)
        combined_data = raw; % Inclui cabeçalhos e dados
    else
        combined_data = [existing_raw; raw(2:end,:)]; % Acrescenta os novos dados
    end

    % Substituir elementos 'missing' por strings vazias
    missing_idx = cellfun(@(x) isa(x, 'missing'), combined_data);
    combined_data(missing_idx) = {''};


    % Grava o arquivo
    writecell(combined_data, destination_xlsx);
    disp('Data added to global unified Excel file!');
    appendExcelEnd =1;
end
