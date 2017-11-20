function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 19-Nov-2017 17:37:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

 Fs = 1000;   % Frequenza di campionamento segnale
 Fc1 = 5;     % Frequenza di taglio inferiore
 Fc2 = 400;   % Frequenza di taglio superiore 
 
% Inizializzazione slider
jSlider = javax.swing.JSlider;

% Richiamo alla funzione per ottenere parametri
[time, rec_fem, vas_lat, vas_med_O, vas_med_V] = getParameters(Fs, Fc1, Fc2);

[jhSlider, hContainer] = javacomponent(jSlider);

% Settaggio parametri di inizializzazione slider
set(hContainer,'units','pixel','position',[100,25,960,50]);
set(jSlider, 'Value',0, 'MajorTickSpacing',5,'MinorTickSpacing', 2.5 ,'PaintLabels',true, 'PaintTicks',true, 'minimum', 0, 'maximum', (length(time)/Fs) - 6);
% Settaggio posizione del plot
set(handles.axes1, 'units', 'pixel' , 'Position',[100 170 960 451])
 
% Estrazione dei primi cinque secondi dei tracciati con l'applicazione delle traslazioni massime
vas_med_O_x = vas_med_O(1:5001);
vas_lat_x = vas_lat(1:5001)+ 830;
vas_med_V_x = vas_med_V(1:5001)+1400;
rec_fem_x  = rec_fem(1:5001) + 1800;
 
% Calcolo offsets per una migliore rappresentazione delle tracce
offset_1 = max(vas_med_O_x) - min(vas_lat_x) + 50;
vas_lat_x = vas_lat_x - abs(offset_1);

offset_2 = max(vas_lat_x) - min(vas_med_V_x) + 50;
vas_med_V_x = vas_med_V_x - abs(offset_2);
 
offset_3 = max(vas_med_V_x) - min(rec_fem_x) + 50;
rec_fem_x = rec_fem_x - abs(offset_3);

% Visualizzazione dei primi cinque secondi dei tracciati
p = plot(time(1:5001), vas_med_O_x, time(1:5001), vas_lat_x , time(1:5001), vas_med_V_x, time(1:5001), rec_fem_x);

% Settaggio plot
grid
title('EMG filtered signals')
xlabel('Time [s]')
ylabel('Ampiezza segnale [uV]')
legend("VasMedO", "VasLat", "VasMedV", "RecFem", 'units', 'pixel' , 'position', 'Position',[760 200 200 200])

% Choose default command line output for GUI
handles.output.sliderv = hObject;
handles.output.time = time;
handles.output.rec_fem = rec_fem;
handles.output.vas_lat = vas_lat;
handles.output.vas_med_O  = vas_med_O;
handles.output.vas_med_V = vas_med_V;
handles.output.plot = p;
set(jSlider, 'StateChangedCallback',{@sliderValue, handles});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%set(hObject, 'PaintLabels',true, 'PaintTicks',true)

% CallBack di gestione cambiamento valore slider
function sliderValue(hObject, eventdata, handles)
slider_value = get(hObject,'Value')

% Frequenza di campionamento
Fs = 1000; 

% Calcolo range di campioni appartenenti alla finestra temporale
x_in = (slider_value * Fs) + 1;
x_end = (slider_value +5)*Fs;

% Recupero dati a traslazione massima dei segnali
time = handles.output.time
rec_fem = handles.output.rec_fem + 1800;
vas_lat = handles.output.vas_lat + 830;
vas_med_O = handles.output.vas_med_O ;
vas_med_V = handles.output.vas_med_V + 1400;

% Selezione dei campioni appartenenti alla finestra temporale
time = time(x_in:x_end);
rec_fem = rec_fem(x_in:x_end);
vas_lat = vas_lat(x_in:x_end);
vas_med_O = vas_med_O(x_in:x_end);
vas_med_V = vas_med_V(x_in:x_end);

% Calcolo offsets, y_min e y_max per ottimizzare la rappresentazione grafica del
% segnale
offset_1 = max(vas_med_O) - min(vas_lat) + 50;
vas_lat = vas_lat - abs(offset_1);

offset_2 = max(vas_lat) - min(vas_med_V) + 50;
vas_med_V = vas_med_V - abs(offset_2);

offset_3 = max(vas_med_V) - min(rec_fem) + 50;
rec_fem = rec_fem - abs(offset_3);

y_min = min(min(min(vas_med_O,vas_lat),min(vas_med_V,rec_fem)));
y_max = max(max(max(vas_med_O,vas_lat),max(vas_med_V,rec_fem)));

% Plot update
plot(handles.axes1,time, vas_med_O, time, vas_lat, time, vas_med_V, time, rec_fem);

title('EMG filtered signals')
xlabel('Time [s]')
ylabel('Ampiezza segnale [uV]')
legend("VasMedO", "VasLat", "VasMedV", "RecFem", 'units', 'pixel' , 'position', 'Position',[760 200 200 200])
grid

% Calcolo del limite di rappresentazione delle y
y_min = round(y_min-20);
y_max = round(y_max+20);
ylim([y_min y_max])
xlim([slider_value slider_value + 5])

