clear all;
close all;
clc;


Fs = 1000;

% Apertura file di testo
fp_orig = fopen('Walking Example_ascii.txt');

% Lettura per righe
c = textscan(fp_orig,'%s','Delimiter','\n');


% Eliminazione delle prime due righe di testo
A = c{1}(3:length(c{1}),:);


j = 1;
while (j <= length(A))
  %strn{j} = regexprep(A{j},'[;]','') 
    strn(j,1) = textscan(A{j}, '%f', 'Delimiter', ';');
  j = j+ 1;
end

B = fscanf(fp_orig,'%s',[5 inf]); 
% il file ha 2 colonne
F = cell2mat(strn')
i = 1;
time = F(1,:);
rec_fem = F(2,:);
vas_lat = F(3,:);
vas_med_O = F(4,:)
vas_med_V = F(5,:)
% Ottengo parametri
% while(i <= length(A))
% 
% time(i,1) = str2double(A{i}(1:6));
% rec_fem(i,1) = str2double(A{i}(10:16));
% vas_lat(i,1)= str2double(A{i}(20:26));
% vas_med_O(i,1)= str2double(A{i}(30:36));
% vas_med_V(i,1)= str2double(A{i}(40:46));
% 
% i = i + 1;
% end

% Chiusura file
fclose(fp_orig);
 
% Eliminzione variabili inutili ai fini dell'elaborazione
clear i c fp_orig ans;

% Dimensionamento filtro passa banda
[a b] = butter(10, [0.01 0.8], 'bandpass')

% Filtraggio segnali
rec_fem_filtered = filter(a, b, rec_fem);
vas_lat_filtered = filter(a, b, vas_lat);
vas_med_O_filtered = filter (a, b, vas_med_O);
vas_med_V_filtered = filter (a, b, vas_med_V);


 max_(1) = max(vas_med_O_filtered);
 max_(2) = max(vas_lat_filtered)
 max_(3) = max(rec_fem_filtered);
 max_(4) = max(vas_med_V_filtered);
 
 min_(1) = min(vas_med_O_filtered);
 min_(2) = min(vas_lat_filtered)
 min_(3) = min(rec_fem_filtered);
 min_ (4) = min(vas_med_V_filtered);
 
 med_(1) = sum(vas_med_O_filtered)/length(vas_med_O_filtered);
 med_(2) = sum(vas_lat_filtered)/length(vas_med_O_filtered);
 med_(3) = sum(rec_fem_filtered)/length(vas_med_O_filtered);
 med_(4) = sum(vas_med_V_filtered)/length(vas_med_O_filtered);
figure

% I segnali sono stati tralsati in ampiezza per consentirne la
% visualizzazione simultanea senza sovrapposizioni
f = plot(time, rec_fem_filtered, 'b',time, vas_lat_filtered + 800, 'g', time, vas_med_O_filtered + 1600,'r', time, vas_med_V +2400)
%set(f,'position',[100 106 951 451])
title('EMG filtered signals')
xlabel('Time [s]')
ylabel('Ampiezza segnale [uV]')


% Creazione slider di scorrimento
jSlider = javax.swing.JSlider;
%javacomponent(jSlider,[100 36 951 21]);
[jhSlider, hContainer] = javacomponent(jSlider);
set(jSlider, 'Value',0, 'MajorTickSpacing',5,'MinorTickSpacing', 5 ,'PaintLabels',true, 'PaintTicks',true);
set(hContainer,'units','pixel','position',[100,100,951,50]);
  % jSlider.setStepSize(5);
