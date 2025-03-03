% Calculate rainfall anomaly timeseries for NW and NE Australia from AGCD, excluding ocean grid
% points and already reshaped into months and years 
% detrend and standardise 

% Set period for climatology and anomaly 
function [rainfall_NW_anom_std,rainfall_NE_anom_std,yearly_T]=NA_rainfall_ts(time_period)

if ~exist('precip','var')

    load 'AWAP_rainfall_1900_2023.mat' 

end 

% Ensure time_period is a string (handle char input)
    if ischar(time_period)
        time_period = string(time_period); 
    end

% Split input string at '-' and convert to numbers
    year_parts = split(time_period, '-'); 
    start_year = str2double(year_parts(1));
    end_year = str2double(year_parts(2));

% Define the dataset's time range
    base_year = 1900; % The first year of the dataset
    end_dataset_year = 2023; % The last year of the dataset

    % Check for valid input years
    if isnan(start_year) || isnan(end_year) || ...
       start_year < base_year || end_year > end_dataset_year || start_year > end_year
        error('Invalid time period. Please enter a valid range within %d-%d.', base_year, end_dataset_year);
    end

% Compute index range based on start year
    start_idx = start_year - base_year + 1; % Convert year to index
    end_idx = end_year - base_year; % Ensure it aligns with dataset indexing

    % Extract the relevant portion of the precipitation dataset
    input_rainfall_1 = precip(:,:,:,start_idx:end_idx); 

    % Generate corresponding time vector
    t1 = datetime(start_year,1,15,0,0,0);
    t2 = datetime(end_year,12,15,0,0,0);
    yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';


% Mask out ocean grid points

[Lat,Lon] = meshgrid(lat,lon);
land = island(Lat, Lon);

rainfall_land = zeros(size(input_rainfall_1));
for i = 1 : 12 

    input_rainfall = squeeze(input_rainfall_1(:,:,i,:));
    land_3D= repmat(land,1,1,size(input_rainfall,3));
    input_rainfall(land_3D==0) = NaN;
    
    rainfall_land(:,:,i,:) = input_rainfall;

end 

% Calculate anomaly 
Rainfall_climatology = squeeze(nanmean(rainfall_land,4));

% Calculate anomaly for all data 
Rainfall_anomaly=rainfall_land- Rainfall_climatology;

% Indices for NW and NE Australia 
idx_east = lon >= 135;
idx_east = find(idx_east ==1);

idx_west = lon < 135; 
idx_west = find(idx_west ==1);

idx = lat >= -20;

% Find index for all latitude values bigger than or equal to -20 
lat_idx = find(idx==1);


for i = 1:2 

    if i==1;
    region= 'Northeast';
    else
        i==2;
    region= 'Northwest';
    end 

% Save NE and NW for option to plot correlations together in one plot later
if strcmp('Northeast',region)
    lon_idx = idx_east;
    rainfall_NE_anom = nanmean(Rainfall_anomaly(lon_idx,lat_idx,:,:),1);
    rainfall_NE_anom=squeeze(nanmean(rainfall_NE_anom,2));
    % Detrend
    rainfall_NE_detr = zeros(size(rainfall_NE_anom));
    for i_dx = 1:12
    rainfall_NE_detr(i_dx,:)=detrend(rainfall_NE_anom(i_dx,:));
    end
    % Standardize
    rainfall_NE_anom_std = zeros(size(rainfall_NE_detr));
    for i_dx = 1:12
    rainfall_NE_anom_std(i_dx,:)=(rainfall_NE_detr(i_dx,:)-mean(rainfall_NE_detr(i_dx,:)))/std(rainfall_NE_detr(i_dx,:));
    end

else
    strcmp('Northwest',region)
    lon_idx = idx_west;
    rainfall_NW_anom = nanmean(Rainfall_anomaly(lon_idx,lat_idx,:,:),1);
    rainfall_NW_anom=squeeze(nanmean(rainfall_NW_anom,2));
    % Detrend 
    rainfall_NW_detr = zeros(size(rainfall_NW_anom));
    for i_dx = 1:12
    rainfall_NW_detr(i_dx,:)=detrend(rainfall_NW_anom(i_dx,:));
    end
    % Standardize
    rainfall_NW_anom_std = zeros(size(rainfall_NW_detr));
    for i_dx = 1:12
    rainfall_NW_anom_std(i_dx,:)=(rainfall_NW_detr(i_dx,:)-mean(rainfall_NW_detr(i_dx,:)))/std(rainfall_NW_detr(i_dx,:));
    end


end


end 


end 

