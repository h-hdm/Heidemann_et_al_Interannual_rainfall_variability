% Calculate all indices that relate e.g. to feedbacks and other
% required indices --> soil moisture, evapotranspiration, wind evaporation feedback, TBO, SAM

function [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,etot_NW_anom_std,varargout]=get_non_oceanic_indices_func(time_period)

% order of output arguments:
% year, soil moisture northeast, soil moisture northwest aus, ET northeast, ET
% northwest,
% varargin inputs can be (in this order): evap, TBO, AM SAM Index 

nout = max(nargout,1) ;

% Ensure time_period is a string (handle char input)
    if ischar(time_period)
        time_period = string(time_period); 
    end

% Split input string at '-' and convert to numbers

    year_parts = split(time_period, '-'); 
    start_year = str2double(year_parts(1));
    end_year = str2double(year_parts(2));

    t1 = datetime(start_year,1,15,0,0,0);
    t2 = datetime(end_year-1,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
    monthly_T = (t1:calendarDuration(0,1,0,0,0,0):t2)';

    

%%%%%%%%%%%%%%%%%%%%%%%%%% 1) soil moisture 
% read in datasets 

fid = 'AWRAL_NE_sm_1920_2023.nc';
fid_2 = 'AWRAL_NW_sm_1920_2023.nc';

NE_sm = ncread(fid,'__xarray_dataarray_variable__');
time=double(ncread(fid,'time'));
local_time = time+datenum(1900,1,1,0,0,0);
max_time = datestr(local_time(end));

NW_sm = ncread(fid_2,'__xarray_dataarray_variable__');
time=double(ncread(fid_2,'time'));
local_time = time+datenum(1900,1,1,0,0,0);
max_time = datestr(local_time(end));

years_available = 1920:2023;

disp(['Available years: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end

time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

% Extract required timeframe 
NE_sm =NE_sm (time_frame_1(1)*12-11:time_frame_1(end)*12);
NW_sm =NW_sm (time_frame_1(1)*12-11:time_frame_1(end)*12);


% Calculate anomaly 
 NE_sm = reshape(NE_sm,[12 length(yearly_T)]);
 NW_sm = reshape(NW_sm,[12 length(yearly_T)]);

% Calculate anomaly 
NE_clim = squeeze(nanmean(NE_sm,2));
NW_clim = squeeze(nanmean(NW_sm,2));

% Calculate anomaly
NE_anom=NE_sm- NE_clim;
Nw_anom=NW_sm- NW_clim;


% Month-by-month detrending 
NE_anom_detr = zeros(size(NE_anom));
NE_anom_detr(1,2:length(yearly_T))=detrend(NE_anom(1,2:length(yearly_T)));
for i_dx = 2:12
NE_anom_detr(i_dx,:)=detrend(NE_anom(i_dx,:));
end

NW_anom_detr = zeros(size(Nw_anom));
NW_anom_detr(1,2:length(yearly_T))=detrend(Nw_anom(1,2:length(yearly_T)));
for i_dx = 2:12
NW_anom_detr(i_dx,:)=detrend(Nw_anom(i_dx,:));
end


% standardize
SM_NE_anom_std = zeros(size(NE_anom_detr));
for i_dx = 1:12
SM_NE_anom_std(i_dx,:)=(NE_anom_detr(i_dx,:)-mean(NE_anom_detr(i_dx,:)))/std(NE_anom_detr(i_dx,:));
end

SM_NW_anom_std = zeros(size(NW_anom_detr));
for i_dx = 1:12
SM_NW_anom_std(i_dx,:)=(NW_anom_detr(i_dx,:)-mean(NW_anom_detr(i_dx,:)))/std(NW_anom_detr(i_dx,:));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%  2) evapotranspiration 


% read in datasets 

fid = 'AWRAL_NE_etot_1920_2023.nc';
fid_2 = 'AWRAL_NW_etot_1920_2023.nc';

NE_etot = ncread(fid,'etot');
time=double(ncread(fid,'time'));
local_time = time+datenum(1900,1,1,0,0,0);
max_time = datestr(local_time(end));

NW_etot = ncread(fid_2,'etot');
time=double(ncread(fid_2,'time'));
local_time = time+datenum(1900,1,1,0,0,0);
max_time = datestr(local_time(end));

% Extract required timeframe 
NE_etot =NE_etot (time_frame_1(1)*12-11:time_frame_1(end)*12);
NW_etot =NW_etot (time_frame_1(1)*12-11:time_frame_1(end)*12);


% Calculate anomaly 
 NE_etot = reshape(NE_etot,[12 length(yearly_T)]);
 NW_etot = reshape(NW_etot,[12 length(yearly_T)]);

% Calculate anomaly 
NE_clim = squeeze(nanmean(NE_etot,2));
NW_clim = squeeze(nanmean(NW_etot,2));

% calculate anomaly
NE_anom=NE_etot- NE_clim;
Nw_anom=NW_etot- NW_clim;


NE_anom_detr = zeros(size(NE_anom));
NE_anom_detr(1,2:length(yearly_T))=detrend(NE_anom(1,2:length(yearly_T)));
for i_dx = 2:12;
NE_anom_detr(i_dx,:)=detrend(NE_anom(i_dx,:));
end

NW_anom_detr = zeros(size(Nw_anom));
NW_anom_detr(1,2:length(yearly_T))=detrend(Nw_anom(1,2:length(yearly_T)));
for i_dx = 2:12;
NW_anom_detr(i_dx,:)=detrend(Nw_anom(i_dx,:));
end

% standardize
etot_NE_anom_std = zeros(size(NE_anom_detr));
for i_dx = 1:12;
etot_NE_anom_std(i_dx,:)=(NE_anom_detr(i_dx,:)-mean(NE_anom_detr(i_dx,:)))/std(NE_anom_detr(i_dx,:));
end

etot_NW_anom_std = zeros(size(NW_anom_detr));
for i_dx = 1:12
etot_NW_anom_std(i_dx,:)=(NW_anom_detr(i_dx,:)-mean(NW_anom_detr(i_dx,:)))/std(NW_anom_detr(i_dx,:));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%  3) ERA5 evaporation of ocean only --> assess wind-evaporation feedback  



% only execute if time period starts from 1940 as no data before then 
if strcmp('1940-2023',time_period) || strcmp('1957-2023',time_period) || strcmp('1975-2023',time_period) ;

load 'Evap_ERA5' lat lon evap 

latitude = lat;
longitude = lon; 
[Lat,Lon] = meshgrid(latitude,longitude);

years_available = 1940:2023;

disp(['Available years: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end

time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

input_evap = evap(:,:,time_frame_1(1)*12-11:time_frame_1(end)*12);  
input_evap = abs(input_evap);

evap_monthly = reshape(input_evap,[length(lon) length(lat) 12 length(time_frame_1)]);


% get rid of land grid points 
land = island(Lat,Lon);

evap_ocean = zeros(size(evap_monthly));

for i = 1 : 12 

input_evap1 = squeeze(evap_monthly(:,:,i,:));
land_3D= repmat(land,1,1,size(input_evap1,3));
input_evap1(land_3D) = NaN;

evap_ocean(:,:,i,:) = input_evap1;

end 


% Calculate climatology 
evap_climatology = squeeze(nanmean(evap_ocean,4));
evap_anomaly = evap_ocean-evap_climatology;


% Get region following Sharmila and Hendon: 
% 105-135E, 5-18S

% to improve: mask out all land grid points 

Evap_Index = nanmean(evap_anomaly(121:241,21:73,:,:),1);
Evap_Index = squeeze(nanmean(Evap_Index,2));


% 2) Detrend and standardise

    evap_detr = zeros(size(Evap_Index));
    for i_dx = 1:12
    evap_detr(i_dx,:)=detrend(squeeze(Evap_Index(i_dx,:)));
    end

    evap_std = zeros(size(evap_detr));
    for i_dx = 1:12
    evap_std(i_dx,:)=(evap_detr(i_dx,:)-mean(evap_detr(i_dx,:)))/std(evap_detr(i_dx,:));
    end

    
    varargout{1}=evap_std;
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%  4) Tropospheric Biennial oscillation TBO
% use the previous seasons (JJAS) Indian or Asian Monsoon Index


% Indian Monsoon Rainfall (in Meehl et al. 2003) JJAS 5-40N, 60-100E from
% ERA5 


fid = 'ERA5_precip_JJAS_Indian_monsoon.nc';

% tp monthly total precipitation
tp = ncread(fid,'tp');
nlat=double(ncread(fid,'latitude'));
nlon=double(ncread(fid,'longitude'));

mv=double(ncreadatt(fid,'/tp','missing_value'));
tp(find(tp<=mv))=NaN;
time_1=double(ncread(fid,'time'));
time_1 = time_1/24;
local_time_1 = time_1+datenum(1900,1,1,0,0,0);% time is in hours since 1900, so that needs to be converted 
max_time = datestr(local_time_1(end));


% convert metres to mm/day
tp = tp.*1000;

% Resize tp into years (to e.g. take averages over one particular month)
ERA5_tp_JJAS_Indian_Monsoon = reshape(tp,[length(nlon), length(nlat), 4, 83]);

% Get rainfall over JJAS
years_available = 1940:2023;

time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

ERA5_tp_IM = squeeze(nanmean(ERA5_tp_JJAS_Indian_Monsoon(:,:,:,time_frame_1),3));


% Calculate climatology 
ERA5_tp_IM_climatology = squeeze(nanmean(ERA5_tp_IM,3));

ERA5_tp_IM_anomaly = ERA5_tp_IM-ERA5_tp_IM_climatology;

% Average over area 
Indian_Monsoon_Index =squeeze(nanmean(ERA5_tp_IM_anomaly,1));
Indian_Monsoon_Index = nanmean(Indian_Monsoon_Index,1);

% Detrend and standardise
Indian_Monsoon_detrended = detrend(Indian_Monsoon_Index);

Indian_Monsoon_std=Indian_Monsoon_detrended-mean(Indian_Monsoon_detrended)/std(Indian_Monsoon_detrended);

% For step wise regression use previous seasons rainfall (preceding DJFM)
% and include in the regression for the season DJFM
    
    varargout{2}=Indian_Monsoon_std;
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%  5) SAM: SAM in April-May


else

end 


if strcmp('1957-2023',time_period) || strcmp('1975-2023',time_period) ;

load SAM_Index.mat

years_available = 1957:2023;
time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);
   
SAM_Index_AM = SAM_Index(4:5,time_frame_1);

SAM_Index_AM=nanmean(SAM_Index_AM,1);
SAM_Index_AM=SAM_Index_AM';

% Detrend and standardise 

SAM_Index_AM_detr=detrend(SAM_Index_AM);
SAM_Index_AM_std=(SAM_Index_AM_detr-mean(SAM_Index_AM_detr))/std(SAM_Index_AM_detr);


    varargout{3}=SAM_Index_AM_std'; % swap dimensions to be consistent with all other predictors 

 

else

end 




end 

