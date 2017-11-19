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
 Fc2 = 400;   % Frequenza di taglio inferiore
 jSlider = javax.swing.JSlider;

[time, rec_fem, vas_lat, vas_med_O, vas_med_V] = getParameters(Fs, Fc1, Fc2);
[jhSlider, hContainer] = javacomponent(jSlider);
 
 set(hContainer,'units','pixel','position',[100,25,960,50]);
 set(jSlider, 'Value',5, 'MajorTickSpacing',5,'MinorTickSpacing', 0 ,'PaintLabels',true, 'PaintTicks',true, 'minimum', 5, 'maximum', (length(time)/Fs) - 6);

 set(handles.axes1, 'units', 'pixel' , 'Position',[100 170 960 451])


% Visualizzazione dei primi cinque secondi delle tracce
p = plot(time(1:5000), vas_med_O(1:5000), time(1:5000), vas_lat(1:5000) + 50, time(1:5000), vas_med_V(1:5000) + 90, time(1:5000), rec_fem(1:5000) + 130);
w = get(handles.axes1,'Position');
v = get(jSlider ,'Value');
z = get(jhSlider ,'Value');
%set(p,'Parent', handles.axes1)
%plot(handles.axes1,time(1:5000), rec_fem_filtered(1:5000),time(1:5000), vas_lat_filtered(1:5000)+40 , time(1:5000), vas_med_O_filtered(1:5000)+80, time(1:5000), vas_med_V_filtered(1:5000)+110)
%plot(app.UIAxes, rec_fem_filtered,'r' ,time, prova, 'g')
grid
title('EMG filtered signals')
xlabel('Time [s]')
ylabel('Ampiezza segnale [uV]')
legend("VasMedO", "VasLat", "VasMedV", "RecFem", 'units', 'pixel' , 'position', 'Position',[760 200 200 200])
%ylim([-600 2000])



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

% CallBASck di gestione cambiamento valore slider
function sliderValue(hObject, eventdata, handles)
slider_value = get(hObject,'Value')
Fs = 1000;
x_in = slider_value * Fs;
x_end = (slider_value +5)*Fs;
% recupero dati a traslazione massima dei segnali
time = handles.output.time
rec_fem = handles.output.rec_fem + 1800;
vas_lat = handles.output.vas_lat + 830;
vas_med_O = handles.output.vas_med_O ;
vas_med_V = handles.output.vas_med_V + 1400;

time = time(x_in:x_end);
rec_fem = rec_fem(x_in:x_end);
vas_lat = vas_lat(x_in:x_end);
vas_med_O = vas_med_O(x_in:x_end);
vas_med_V = vas_med_V(x_in:x_end);
%y_min = min(min(min(vas_med_O(x_in:x_end),vas_lat(x_in:x_end)),min(vas_med_V(x_in:x_end),rec_fem(x_in:x_end))));
%y_max = max(max(max(vas_med_O(x_in:x_end),vas_lat(x_in:x_end)),max(vas_med_V(x_in:x_end),rec_fem(x_in:x_end))));


offset_1 = max(vas_med_O) - min(vas_lat) + 100;
vas_lat = vas_lat - abs(offset_1);

offset_2 = max(vas_lat) - min(vas_med_V) + 100;
vas_med_V = vas_med_V - abs(offset_2);

offset_3 = max(vas_med_V) - min(rec_fem) + 100;
rec_fem = rec_fem - abs(offset_3);

y_min = min(min(min(vas_med_O,vas_lat),min(vas_med_V,rec_fem)));
y_max = max(max(max(vas_med_O,vas_lat),max(vas_med_V,rec_fem)));

p = handles.output.plot;
%x = time(x_in:x_end,1);
%p = plot(time(1:5000),vas_med_O (1:5000),time(1:5000), vas_lat(1:5000)+40 , time(1:5000), vas_med_V(1:5000)+80, time(1:5000),rec_fem (1:5000)+110)

%y = rec_fem_filtered(k*1000:k*1000,1);
%p = plot(time(1:k*1000), rec_fem_filtered(1:k*1000),time(1:k*1000), vas_lat_filtered(1:k*1000) , time(1:k*1000), vas_med_O_filtered(1:k*1000), time(1:k*1000), vas_med_V_filtered(1:k*1000))
%plot(handles.axes1,time(x_in:x_end), vas_med_O(x_in:x_end), time(x_in:x_end), vas_lat(x_in:x_end) + 830, time(x_in:x_end), vas_med_V(x_in:x_end) + 1400, time(x_in:x_end), rec_fem(x_in:x_end) + 1800);
%plot(handles.axes1,time(x_in:x_end), vas_med_O(x_in:x_end), time(x_in:x_end), vas_lat(x_in:x_end), time(x_in:x_end), vas_med_V(x_in:x_end), time(x_in:x_end), rec_fem(x_in:x_end));
plot(handles.axes1,time, vas_med_O, time, vas_lat, time, vas_med_V, time, rec_fem);

title('EMG filtered signals')
xlabel('Time [s]')
ylabel('Ampiezza segnale [uV]')
legend("VasMedO", "VasLat", "VasMedV", "RecFem", 'units', 'pixel' , 'position', 'Position',[760 200 200 200])
grid
%plot(handles.axes1, x,rec_fem_y , x,vas_lat_y + 40,x,vas_med_O_y + 80 ,x, vas_med_V_y + 110)
%ylim([-1000 1000])
y_min = round(y_min-50);
y_max = round(y_max+50);
ylim([y_min y_max])
xlim([slider_value slider_value + 5])
%set(p,'XData',time(1:k*1000),'YData',rec_fem_filtered(1:k*1000))
%refreshdata(p, 'caller');
%guidata(hObject, handles);
