% Funzione che permette di estrapolare i dati dal file .txt e che fornisce
% in uscita i quattro segnali filtrati e il vettore tempo
% I parametri di ingresso della funzione sono Fs: Frequenza di
% campionamento, Fc1: Frequenza di taglio inferiore, Fc2: Frequenza di
% taglio superiore
function [time, rec_fem_filt, vas_lat_filt, vas_med_O_filt, vas_med_V_filt] = getParameters(Fs, Fc1, Fc2)

% Apertura file di testo
fp_orig = fopen('Walking Example_ascii.txt');

% Lettura per righe
c = textscan(fp_orig,'%s','Delimiter','\n');

% Eliminazione delle prime due righe di testo
data_string = c{1}(3:length(c{1}),:);

% Chiusura file di testo
fclose(fp_orig);

j = 1;
while (j <= length(data_string))
    strn(j,1) = textscan(data_string{j}, '%f', 'Delimiter', ';');
    j = j+ 1;
end

data = cell2mat(strn')

time = data(1,:);
rec_fem = data(2,:);
vas_lat = data(3,:);
vas_med_O = data(4,:)
vas_med_V = data(5,:)

%%%---- Filtraggio segnale ---%%%

% Calcolo delle pulsazioni
wc1 = Fc1/(Fs/2);
wc2 = Fc2/(Fs/2);

% Dimensionamento filtro passa banda
[a b] = butter(10, [wc1 wc2], 'bandpass');

% Applicazione filtro ai segnali
rec_fem_filt = filter(a, b, rec_fem);
vas_lat_filt = filter(a, b, vas_lat);
vas_med_O_filt = filter (a, b, vas_med_O);
vas_med_V_filt = filter (a, b, vas_med_V);
end
