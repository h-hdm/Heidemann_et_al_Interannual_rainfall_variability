% Get SST Indices for Stepwise linear regression (detrended and
% standardised), using a specified time period 

function [Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,yearly_T]=get_SST_indices_func(time_period)

%
% Nino 3.4, CP ENSO Index, EP ENSO Index, DMI, Coral Sea, Timor Sea,
% Arafura Seas, IOBW, Tripole Index, Ningaloo Nino, C index, E index, time  

% Load HadISST SST data, calculate anomaly 
load 'HadISST_1870_2023.mat'
[Lon,Lat] = meshgrid(glat,glon);


% 1) Calculate anomaly and regrid data 
% Ensure time_period is a string (handle char input)
    if ischar(time_period)
        time_period = string(time_period); 
    end

% Split input string at '-' and convert to numbers

    year_parts = split(time_period, '-'); 
    start_year = str2double(year_parts(1));
    end_year = str2double(year_parts(2));

    years_available = 1870:2023;
    disp(['Available years: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end   

    time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);
   
    SST_climatology = squeeze(nanmean(SST_resized(:,:,:,time_frame_1), 4));
    SST_anom = SST_resized(:,:,:,time_frame_1) - SST_climatology;
    SST_anomaly_ts = reshape(SST_anom,[length(glon) length(glat) 12*length(time_frame_1)]);

    t1 = datetime(start_year,1,15,0,0,0);
    t2 = datetime(end_year-1,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
    monthly_T = (t1:calendarDuration(0,1,0,0,0,0):t2)';


% Regrid first, then calculate SST Indices
lon1 = [-179.5:0.5:179.5]';
lat1 = flipud([-89.5:0.5:89.5]');
[Lon1,Lat1] = meshgrid(lon1,lat1);

SSTa = flipud(rot90(SST_anomaly_ts));

% Grid of original coordinates, set up for interpolation in next step
[Glon, Glat] = meshgrid(glon,glat);

n = length(SSTa);

% The default is linear interpolation
XSSTa  = zeros(359,719,n);

for i = 1:n
    
   XSSTa(:,:,i) = interp2(Glon, Glat,SSTa(:,:,i),Lon1,Lat1); 
    
end

Anomaly_ts = XSSTa;


% 2) Calculate SST Indices, then detrend and standardise


% Nino 3.4
N34_lon = 20:120; % 120W to 170W
N34_lat = 170:190; % 5 N to 5 S
Index_lat = N34_lat;
Index_lon = N34_lon;
Nino34_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Nino34_Index = squeeze(nanmean(Nino34_Index));

Nino34_reshaped = reshape(Nino34_Index,[12 length(yearly_T)]);
Nino34_detr = zeros(size(Nino34_reshaped));
for i_dx = 1:12
Nino34_detr(i_dx,:)=detrend(Nino34_reshaped(i_dx,:));
end

% Standardize
Nino34_std = zeros(size(Nino34_detr));
for i_dx = 1:12
Nino34_std(i_dx,:)=(Nino34_detr(i_dx,:)-mean(Nino34_detr(i_dx,:)))/std(Nino34_detr(i_dx,:));
end


% Nino 4
N4_lon = 680:719; % 160E-150W
N4_lon(41:100) = 1:60;
N4_lat = 170:190; % 5 N to 5 S
Index_lat = N4_lat;
Index_lon = N4_lon;   
Nino4_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Nino4_Index = squeeze(nanmean(Nino4_Index));

Nino4_reshaped = reshape(Nino4_Index,[12 length(yearly_T)]);
Nino4_detr = zeros(size(Nino4_reshaped));
for i_dx = 1:12
Nino4_detr(i_dx,:)=detrend(Nino4_reshaped(i_dx,:));
end

% Standardize
Nino4_std = zeros(size(Nino4_detr));
for i_dx = 1:12
Nino4_std(i_dx,:)=(Nino4_detr(i_dx,:)-mean(Nino4_detr(i_dx,:)))/std(Nino4_detr(i_dx,:));
end

% Nino 3
N3_lon = 60:180; % 150W to 90W
N3_lat = 170:190; % 5 N to 5 S
Index_lat = N3_lat;
Index_lon = N3_lon;  
Nino3_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Nino3_Index = squeeze(nanmean(Nino3_Index));

Nino3_reshaped = reshape(Nino3_Index,[12 length(yearly_T)]);
Nino3_detr = zeros(size(Nino3_reshaped));
for i_dx = 1:12
Nino3_detr(i_dx,:)=detrend(Nino3_reshaped(i_dx,:));
end

% Standardize
Nino3_std = zeros(size(Nino3_detr));
for i_dx = 1:12
Nino3_std(i_dx,:)=(Nino3_detr(i_dx,:)-mean(Nino3_detr(i_dx,:)))/std(Nino3_detr(i_dx,:));
end

% CP ENSO
CP_Index = Nino4_Index-(0.4*Nino3_Index);

% Detrend each month separately
CP_reshaped = reshape(CP_Index,[12 length(yearly_T)]);
CP_detr = zeros(size(CP_reshaped));
for i_dx = 1:12
CP_detr(i_dx,:)=detrend(CP_reshaped(i_dx,:));
end

% Standardize
CP_std = zeros(size(CP_detr));
for i_dx = 1:12
CP_std(i_dx,:)=(CP_detr(i_dx,:)-mean(CP_detr(i_dx,:)))/std(CP_detr(i_dx,:));
end



% EP ENSO
EP_Index = Nino3_Index-(0.4*Nino4_Index);

% Detrend each month separately
EP_reshaped = reshape(EP_Index,[12 length(yearly_T)]);
EP_detr = zeros(size(EP_reshaped));
for i_dx = 1:12
EP_detr(i_dx,:)=detrend(EP_reshaped(i_dx,:));
end

% Standardize
EP_std = zeros(size(EP_detr));
for i_dx = 1:12
EP_std(i_dx,:)=(EP_detr(i_dx,:)-mean(EP_detr(i_dx,:)))/std(EP_detr(i_dx,:));
end


% Dipole Mode Index (IOD)
DMI_west_lon = 460:500;% 50-70E
DMI_west_lat = 160:200; % 10N to 10S
DMI_east_lon = 540:580; % 90-110 E
DMI_east_lat = 180:200; % 10S - 0 

DMI_west = squeeze(nanmean(Anomaly_ts(DMI_west_lat,DMI_west_lon,:),1));
DMI_west = squeeze(nanmean(DMI_west,1));

DMI_east = squeeze (nanmean(Anomaly_ts(DMI_east_lat,DMI_east_lon,:),1));
DMI_east = squeeze(nanmean(DMI_east,1));
    
DMI = DMI_west - DMI_east;

% Detrend each month separately
DMI_reshaped = reshape(DMI,[12 length(yearly_T)]);
DMI_detr = zeros(size(DMI_reshaped));
for i_dx = 1:12
DMI_detr(i_dx,:)=detrend(DMI_reshaped(i_dx,:));
end

   % Standardize
DMI_std = zeros(size(DMI_detr));
for i_dx = 1:12
DMI_std(i_dx,:)=(DMI_detr(i_dx,:)-mean(DMI_detr(i_dx,:)))/std(DMI_detr(i_dx,:));
end



% IPO Tripole Index (unfiltered)
TPI_1_lon = 1:80;
TPI_1_lon(81:150) = 650:719;
TPI_1_lat = 90:130; 

TPI_1 =  squeeze(nanmean(Anomaly_ts(TPI_1_lat,TPI_1_lon,:),1));
TPI_1 =  squeeze(nanmean(TPI_1,1));

% Look these coordinated up in lat1 and lon1
TPI_2_lon = 700:719;
TPI_2_lon(21:200) = 1:180 ;
TPI_2_lat = 160:200;

TPI_2 =  squeeze(nanmean(Anomaly_ts(TPI_2_lat,TPI_2_lon,:),1));
TPI_2 =  squeeze(nanmean(TPI_2,1));

TPI_3_lon = 660:719;
TPI_3_lon(61:100) = 1:40;
TPI_3_lat = 210:280;

TPI_3 =  squeeze(nanmean(Anomaly_ts(TPI_3_lat,TPI_3_lon,:),1));
TPI_3 =  squeeze(nanmean(TPI_3,1));

% Compute unfiltered TPI
TPI = TPI_2 - ((TPI_1+TPI_3)/2);

% Detrend each month separately
TPI_reshaped = reshape(TPI,[12 length(yearly_T)]);
TPI_detr = zeros(size(TPI_reshaped));
for i_dx = 1:12
TPI_detr(i_dx,:)=detrend(TPI_reshaped(i_dx,:));
end

% Standardize
TPI_std = zeros(size(TPI_detr));
for i_dx = 1:12
TPI_std(i_dx,:)=(TPI_detr(i_dx,:)-mean(TPI_detr(i_dx,:)))/std(TPI_detr(i_dx,:));
end

% Filter
TPI= reshape(TPI_std,[1 12*length(yearly_T)]);
TPI_filt = filt1('lp',TPI,'Tc',13*12,'order',6);
TPI_filt = reshape(TPI_filt,[12 length(yearly_T)]);


clear TPI_1
clear TPI_2
clear TPI_3

% Indian Ocean Basin-wide Index (IOBW)
lat_bound=130:235; % 25N-27.5S     75:106 15N-15S
 % 35.5E-120.5E
lon_bound = 431:601;

SSTa_equat_IO = Anomaly_ts(lat_bound,lon_bound,:);

% Detrend each month separately
IO_reshaped = reshape(SSTa_equat_IO ,[106 171 12 length(yearly_T)]);
IO_detr = zeros(size(IO_reshaped));
for i_dx = 1:12
IO_detr(:,:,i_dx,:)=detrend3(squeeze(IO_reshaped(:,:,i_dx,:)));
end

max_idx = length(yearly_T);
max_idx_2 = length(monthly_T);
SSTa_equat_IO_detr = reshape(IO_detr ,[106 171 12*max_idx]);

for i = 1:length(lat_bound)
    for j = 1:length(lon_bound)
        for k = 1:max_idx_2
            if SSTa_equat_IO_detr(i,j,k)>20 || SSTa_equat_IO_detr(i,j,k)<-20
                SSTa_equat_IO_detr(i,j,k)=NaN;
            end 
        end
    end
    

end

% Eof and Pc calculation 

[eofmap,pc,expv] = eof(SSTa_equat_IO_detr);

IOBW_Index = pc(1,:);

% standardize
IOBW_Index= reshape(IOBW_Index,[12 length(yearly_T)]);
IOBW_std = zeros(size(IOBW_Index));
for i_dx = 1:12
IOBW_std(i_dx,:)=(IOBW_Index(i_dx,:)-mean(IOBW_Index(i_dx,:)))/std(IOBW_Index(i_dx,:));
end

% Note that when the time period 1975 to 2023 is chosen, pcs have sign other
% way round! so need to change sign of PC to be consistent with PCs using
% other time periods 
if strcmp('1975-2023',time_period)
    IOBW_std = -(IOBW_std);
else
    
end 

   
% Coral Sea/NE of Australia 
Coral_lon = 650:690; % 145E to 165E
Coral_lat = 190:230; % 5 S to 25 S

Index_lat = Coral_lat;
Index_lon = Coral_lon;   
Coral_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Coral_Index = squeeze(nanmean(Coral_Index));

% detrend each month separately
Coral_reshaped = reshape(Coral_Index,[12 length(yearly_T)]);
Coral_detr = zeros(size(Coral_reshaped));
for i_dx = 1:12
Coral_detr(i_dx,:)=detrend(Coral_reshaped(i_dx,:));
end

% standardize
Coral_std = zeros(size(Coral_detr));
for i_dx = 1:12
Coral_std(i_dx,:)=(Coral_detr(i_dx,:)-mean(Coral_detr(i_dx,:)))/std(Coral_detr(i_dx,:));
end


% Arafura Sea - including Gulf of Carpentaria
Arafura_lon = 620:650; % 130E to 145E
Arafura_lat = 190:220; % 5 S to 20 S

Index_lat = Arafura_lat;
Index_lon = Arafura_lon;   
Arafura_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Arafura_Index = squeeze(nanmean(Arafura_Index));

% detrend each month separately
Arafura_reshaped = reshape(Arafura_Index,[12 length(yearly_T)]);
Arafura_detr = zeros(size(Arafura_reshaped));
for i_dx = 1:12
Arafura_detr(i_dx,:)=detrend(Arafura_reshaped(i_dx,:));
end

% standardize
Arafura_std = zeros(size(Arafura_detr));
for i_dx = 1:12
Arafura_std(i_dx,:)=(Arafura_detr(i_dx,:)-mean(Arafura_detr(i_dx,:)))/std(Arafura_detr(i_dx,:));
end

% Timor Sea
Timor_lon = 600:620; % 120E to 130E
Timor_lat = 190:210; % 5 S to 15 S

Index_lat = Timor_lat;
Index_lon = Timor_lon;   
Timor_Index = nanmean(Anomaly_ts(Index_lat,Index_lon,:));
Timor_Index = squeeze(nanmean(Timor_Index));

% detrend each month separately
Timor_reshaped = reshape(Timor_Index,[12 length(yearly_T)]);
Timor_detr = zeros(size(Timor_reshaped));
for i_dx = 1:12
Timor_detr(i_dx,:)=detrend(Timor_reshaped(i_dx,:));
end

% standardize
Timor_std = zeros(size(Timor_detr));
for i_dx = 1:12
Timor_std(i_dx,:)=(Timor_detr(i_dx,:)-mean(Timor_detr(i_dx,:)))/std(Timor_detr(i_dx,:));
end



% Ningaloo Nino Index - EOF of region 100E-120E, 14S-36S 
lat_bound=208:252; % 14S-36S     
lon_bound = 560:600; %100E-120E

SSTa_Ningaloo = Anomaly_ts(lat_bound,lon_bound,:);

% detrend each month separately

IO_reshaped = reshape(SSTa_Ningaloo ,[45 41 12 max_idx]);
IO_detr = zeros(size(IO_reshaped));
for i_dx = 1:12
IO_detr(:,:,i_dx,:)=detrend3(squeeze(IO_reshaped(:,:,i_dx,:)));
end

SSTa_Ningaloo_detr = reshape(IO_detr ,[45 41 12*max_idx]);


for i = 1:length(lat_bound)
    for j = 1:length(lon_bound)
        for k = 1:max_idx_2
            if SSTa_Ningaloo_detr(i,j,k)>20 || SSTa_Ningaloo_detr(i,j,k)<-20
                SSTa_Ningaloo_detr(i,j,k)=NaN;
            end 
        end
    end
    

end

% Eof and pc calculation (first two modes of variability and principal
% component timeseries

[eofmap,pc,expv] = eof(SSTa_Ningaloo_detr);

Ningaloo_Index = pc(1,:);

% standardize
Ningaloo_Index= reshape(Ningaloo_Index,[12 max_idx]);
Ningaloo_std = zeros(size(Ningaloo_Index));
for i_dx = 1:12
Ningaloo_std(i_dx,:)=(Ningaloo_Index(i_dx,:)-mean(Ningaloo_Index(i_dx,:)))/std(Ningaloo_Index(i_dx,:));
end



% E and C Indices by Takahashi - for comparison 

% Equatorial Pacific 10S to 10N
lat_bound=160:200; % 10N-10S     75:106 15N-15S
lon1_bound = 640:719; % 140E-180E
lon2_bound = 1:200; % 180W-80W
lon_bound = [lon1_bound lon2_bound];

% Variable with only equtorial Pacific SSTa (detrended)
SSTa_equat_pac = Anomaly_ts(lat_bound,lon_bound,:);

% Detrend each month separately
Equat_pac_reshaped = reshape(SSTa_equat_pac ,[41 280 12 length(yearly_T)]);
Eqat_pac_detr = zeros(size(Equat_pac_reshaped));
for i_dx = 1:12
Eqat_pac_detr(:,:,i_dx,:)=detrend3(squeeze(Equat_pac_reshaped(:,:,i_dx,:)));
end

max_idx = length(yearly_T);
max_idx_2 = length(monthly_T);
SSTa_equat_pac_detr = reshape(Eqat_pac_detr ,[41 280 12*max_idx]);

for i = 1:length(lat_bound)
    for j = 1:length(lon_bound)
        for k = 1:max_idx_2
            if SSTa_equat_pac_detr(i,j,k)>20 || SSTa_equat_pac_detr(i,j,k)<-20
                SSTa_equat_pac_detr(i,j,k)=NaN;
            end 
        end
    end
end

[eofmap,pc,expv] = eof(SSTa_equat_pac_detr,2);

% flip sign of second eof and pc so they make sense for calculations and
% plotting
pc(2,:)=-(pc(2,:));
eofmap(:,:,2)=-(eofmap(:,:,2));

pc1 = pc(1,:);
pc2 = pc(2,:);

% normalize the pcs
pc1_norm= (pc1-mean(pc1))/std(pc1);
pc2_norm= (pc2-mean(pc2))/std(pc2);


% then calculate the C and E indices
E_Index = (pc1_norm-pc2_norm)/(sqrt(2));
C_Index = (pc1_norm+pc2_norm)/(sqrt(2));

% standardize
E_Index= reshape(E_Index,[12 length(yearly_T)]);
E_std = zeros(size(E_Index));
for i_dx = 1:12
E_std(i_dx,:)=(E_Index(i_dx,:)-mean(E_Index(i_dx,:)))/std(E_Index(i_dx,:));
end

C_Index= reshape(C_Index,[12 length(yearly_T)]);
C_std = zeros(size(C_Index));
for i_dx = 1:12
C_std(i_dx,:)=(C_Index(i_dx,:)-mean(C_Index(i_dx,:)))/std(C_Index(i_dx,:));
end



end 
