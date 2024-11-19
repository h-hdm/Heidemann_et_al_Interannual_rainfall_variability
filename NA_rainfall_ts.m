% calculate rainfall anomaly timeseries for NW and NE Australia from AGCD, excluding ocean grid
% points and already reshaped into months and years 
% detrend and standardise 

% set period for climatology and anomaly 
function [rainfall_NW_anom_std,rainfall_NE_anom_std,yearly_T]=NA_rainfall_ts(time_period)

if ~exist('precip','var')

    load 'AWAP_rainfall_1900_2023.mat' 

end 


if strcmp('1920-2023',time_period) 
    input_rainfall_1 = precip(:,:,:,21:123); 
    t1 = datetime(1920,1,15,0,0,0);
    t2 = datetime(2022,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';

elseif strcmp('1940-2023',time_period) 
    input_rainfall_1 = precip(:,:,:,41:123); %
    t1 = datetime(1940,1,15,0,0,0);
    t2 = datetime(2022,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';

elseif strcmp('1957-2023',time_period)
    input_rainfall_1 = precip(:,:,:,58:123);
    t1 = datetime(1957,1,15,0,0,0);
    t2 = datetime(2022,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';

elseif strcmp('1959-2023',time_period)
    input_rainfall_1 = precip(:,:,:,60:123);
    t1 = datetime(1959,1,15,0,0,0);
    t2 = datetime(2022,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
    

else
    strcmp('1975-2023',time_period)
    input_rainfall_1 = precip(:,:,:,76:123);
    t1 = datetime(1975,1,15,0,0,0);
    t2 = datetime(2022,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';

end 



length_years = size(input_rainfall_1,4);

[Lat,Lon] = meshgrid(lat,lon);

% mask out ocean grid points

[Lat,Lon] = meshgrid(lat,lon);

land = island(Lat, Lon);

rainfall_land = zeros(size(input_rainfall_1));

for i = 1 : 12 

input_rainfall = squeeze(input_rainfall_1(:,:,i,:));
land_3D= repmat(land,1,1,size(input_rainfall,3));
input_rainfall(land_3D==0) = NaN;

rainfall_land(:,:,i,:) = input_rainfall;

end 

% calculate anomaly 
Rainfall_climatology = squeeze(nanmean(rainfall_land,4));

% calculate anomaly for all data 
Rainfall_anomaly=rainfall_land- Rainfall_climatology;

idx_east = lon >= 135;
idx_east = find(idx_east ==1);
% ipted assignment dimension mism
idx_west = lon < 135; 
idx_west = find(idx_west ==1);

idx = lat >= -20;
% find index for all latitude values bigger than or equal to -20 
lat_idx = find(idx==1);


for i = 1:2 

    if i==1;
    region= 'Northeast';
    else
        i==2;
    region= 'Northwest';
    end 

% save NE and NW for option to plot correlations together in one plot later
if strcmp('Northeast',region)
    lon_idx = idx_east;
    rainfall_NE_anom = nanmean(Rainfall_anomaly(lon_idx,lat_idx,:,:),1);
    rainfall_NE_anom=squeeze(nanmean(rainfall_NE_anom,2));
    % detrend
    rainfall_NE_detr = zeros(size(rainfall_NE_anom));
    for i_dx = 1:12
    rainfall_NE_detr(i_dx,:)=detrend(rainfall_NE_anom(i_dx,:));
    end
    % standardize
    rainfall_NE_anom_std = zeros(size(rainfall_NE_detr));
    for i_dx = 1:12
    rainfall_NE_anom_std(i_dx,:)=(rainfall_NE_detr(i_dx,:)-mean(rainfall_NE_detr(i_dx,:)))/std(rainfall_NE_detr(i_dx,:));
    end

else
    strcmp('Northwest',region)
    lon_idx = idx_west;
    rainfall_NW_anom = nanmean(Rainfall_anomaly(lon_idx,lat_idx,:,:),1);
    rainfall_NW_anom=squeeze(nanmean(rainfall_NW_anom,2));
    % detrend 
    rainfall_NW_detr = zeros(size(rainfall_NW_anom));
    for i_dx = 1:12
    rainfall_NW_detr(i_dx,:)=detrend(rainfall_NW_anom(i_dx,:));
    end
    % standardize
    rainfall_NW_anom_std = zeros(size(rainfall_NW_detr));
    for i_dx = 1:12
    rainfall_NW_anom_std(i_dx,:)=(rainfall_NW_detr(i_dx,:)-mean(rainfall_NW_detr(i_dx,:)))/std(rainfall_NW_detr(i_dx,:));
    end


end


end 


end 

