%% Monthly Regression of Northern Australian Rainfall and Climate Variables
% This script calculates regression coefficients for different climate variables (e.g., SST, MSLP, winds, evaporation) against rainfall anomalies.
% saves output as .mat file for quicker plotting 

% 1) set time frame to analyse 

start_year = 1975;
end_year = 2023;

% 2) choose variable and data set to process below:

large_scale_variable = 'SST'
% large_scale_variable = 'MSLP'
% large_scale_variable ='850hPa uwnd'
% large_scale_variable ='850hPa vwnd'
% large_scale_variable ='200hPa hgt'
% large_scale_variable ='evaporation'
% large_scale_variable ='soil moisture lag-1'
% large_scale_variable ='OLR'



%% load rainfall data and calculate detrended and standardized timeseries
% for northern Australia 

load('AWAP_rainfall_1900_2023');


years_available = 1900:2023;
disp(['Available years rainfall: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);


if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
    error('Invalid year range. Please select within available data.');
end


if end_year == 2023
    time_frame_2 = find(years_available >= start_year & years_available <= end_year-1);
else
    time_frame_2 = find(years_available >= start_year & years_available <= end_year);
end 


input_rainfall_1 = precip(:,:,:,time_frame_2); 
clear precip


% Get land region mask
[Lat, Lon] = meshgrid(lat, lon);
land = island(Lat, Lon);
rainfall_land = NaN(size(input_rainfall_1));

for i = 1:12 
    input_rainfall = squeeze(input_rainfall_1(:,:,i,:));
    land_3D = repmat(land, 1, 1, size(input_rainfall, 3));
    input_rainfall(land_3D == 0) = NaN;
    rainfall_land(:,:,i,:) = input_rainfall;
end 

% Calculate anomalies
Rainfall_climatology = squeeze(nanmean(rainfall_land, 4));
Rainfall_anomaly = rainfall_land - Rainfall_climatology;
clear Rainfall_climatology rainfall_land input_rainfall input_rainfall_1


% Calculate regional rainfall anomaly index --> northern Australia
idx = lat >= -20;
lat_idx = find(idx);
rainfall_NA_anom = squeeze(nanmean(nanmean(Rainfall_anomaly(:,lat_idx,:,:), 1), 2));

% detrend month by month
rainfall_NA_detr = zeros(size(rainfall_NA_anom));
for i_dx = 1:12
rainfall_NA_detr(i_dx,:)=detrend(rainfall_NA_anom(i_dx,:));
end   

% standardize
rainfall_NA_anom_std = zeros(size(rainfall_NA_detr));
for i_dx = 1:12
rainfall_NA_anom_std(i_dx,:)=(rainfall_NA_detr(i_dx,:)-mean(rainfall_NA_detr(i_dx,:)))/std(rainfall_NA_detr(i_dx,:));
end

clear Rainfall_anomaly rainfall_NA_anom rainfall_NA_detr

%% Load and process climate variable (e.g., SST, MSLP, etc.)
if strcmp('SST',large_scale_variable)

    load 'HadISST_1870_2023.mat'
    [Lon, Lat] = meshgrid(glat, glon);
    lon = glon;
    lat = glat;
    
    years_available = 1870:2023;
    disp(['Available years SST: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);
    
    SST_climatology = squeeze(nanmean(SST_resized(:,:,:,time_frame_1), 4));
    SST_anom = SST_resized(:,:,:,time_frame_1) - SST_climatology;
    clear SST_climatology SST_resized
    
    % Detrend climate variable
    SST_anom_detr = zeros(size(SST_anom));
    for i_dx = 1:12
        SST_anom_detr(:,:,i_dx,:)=detrend3(squeeze(SST_anom(:,:,i_dx,:)));
    end
    
    % set name  of field to use for regression
    var_anom_detr = SST_anom_detr;


elseif strcmp('MSLP',large_scale_variable)


    load 20CRv3_MSLP_1836_2015.mat 
    lon1=lon;
    lon1(361)=(lon1(360)-lon1(359))+lon1(360);
    [Lon1,Lat1] = meshgrid(lat,lon1);
    
    years_available = 1836:2015;
    disp(['Available years MSLP: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year);

    % calculate anomaly 
    mslp = twentyCRv3_mslp_res;
    mslp = mslp(:,:,:,time_frame_1); 
    
    MSLP_clim = nanmean(mslp,4);
    MSLP_anom = mslp - MSLP_clim; 

    % Detrend climate variable
    MSLP_detr = zeros(size(MSLP_anom));
    for i_dx = 1:12
    MSLP_detr(:,:,i_dx,:)=detrend3(squeeze(MSLP_anom(:,:,i_dx,:)));
    end

    clear twentyCRv3_mslp_res twentyCRv3_mslp MSLP_clim MSLP_ts

    % set name  of field to use for regression
    var_anom_detr = MSLP_detr;


elseif strcmp('850hPa uwnd',large_scale_variable)

    load 20CRv3_uwnd.mat

    years_available = 1836:2015;
    disp(['Available years uwnd: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year);
    % calculate anomaly 
    uwnd = uwnd_850_res;
    uwnd = uwnd(:,:,:,time_frame_1); 
    
    uwnd_clim = nanmean(uwnd,4);
    uwnd_anom = uwnd - uwnd_clim; 


    uwnd_detr = zeros(size(uwnd_anom));
    for i_dx = 1:12
    uwnd_detr(:,:,i_dx,:)=detrend3(squeeze(uwnd_anom(:,:,i_dx,:)));
    end

    clear uwnd_850hPa uwnd_clim uwnd_200hPa uwnd_ts

    % set name  of field to use for regression
    var_anom_detr = uwnd_detr;


elseif strcmp('850hPa vwnd',large_scale_variable)

    load 20CRv3_vwnd.mat

    years_available = 1836:2015;
    disp(['Available years vwnd: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year);
    % calculate anomaly 
    vwnd = vwnd_850_res;
    vwnd = vwnd(:,:,:,time_frame_1); 
    
    vwnd_clim = nanmean(vwnd,4);
    vwnd_anom = vwnd - vwnd_clim; 

    vwnd_detr = zeros(size(vwnd_anom));
    for i_dx = 1:12
    vwnd_detr(:,:,i_dx,:)=detrend3(squeeze(vwnd_anom(:,:,i_dx,:)));
    end

    clear vwnd_850hPa vwnd_clim vwnd_200hPa vwnd_ts

    % set name  of field to use for regression
    var_anom_detr = vwnd_detr;

elseif strcmp('200hPa hgt',large_scale_variable)

    load ('20CRv3_hgt.mat','lon','lat','hgt_200_res','monthly_T')

    lon1=lon;
    lon1(361)=(lon1(360)-lon1(359))+lon1(360);
    [Lon1,Lat1] = meshgrid(lat,lon1);
        
    years_available = 1836:2015;
    disp(['Available years hgt: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year);

    % calculate anomaly 
    hgt = hgt_200_res;
    hgt = hgt(:,:,:,time_frame_1); 
    
    hgt_clim = nanmean(hgt,4);
    hgt_anom = hgt - hgt_clim; 

    hgt_detr = zeros(size(hgt_anom));
    for i_dx = 1:12
    hgt_detr(:,:,i_dx,:)=detrend3(squeeze(hgt_anom(:,:,i_dx,:)));
    end

    clear hgt_200_res hgt hgt_clim hgt_ts

    % set name  of field to use for regression
    var_anom_detr = hgt_detr;

elseif strcmp('evaporation',large_scale_variable)

    load ('Evap_ERA5.mat','lon','lat','evap')

    years_available = 1940:2023;
    disp(['Available years evaporation: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

    % reshape into months years to match with shape of other variables 
    input_evap = evap(:,:,time_frame_1(1)*12-11:time_frame_1(end)*12);  
    input_evap = abs(input_evap);

    evap_monthly = reshape(input_evap,[length(lon) length(lat) 12 length(time_frame_1)]);

    [Lat,Lon] = meshgrid(lat,lon);
    
    % calculate anomaly 
    evap_clim = squeeze(nanmean(evap_monthly,4));
    evap_anom = evap_monthly - evap_clim; 
    

    evap_detr = zeros(size(evap_anom));
    for i_dx = 1:12
    evap_detr(:,:,i_dx,:)=detrend3(squeeze(evap_anom(:,:,i_dx,:)));
    end


    % set name  of field to use for regression
    var_anom_detr = evap_detr;


elseif strcmp('soil moisture lag-1',large_scale_variable)

    fid = 'AWRAL_sm_1920_2023.nc';
    sm = ncread(fid,'__xarray_dataarray_variable__');
  
    lon = ncread(fid,'longitude');
    lat = ncread(fid,'latitude');

    years_available = 1920:2023;
    disp(['Available years soil moisture: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

    % reshape into months years to match with shape of other variables 
    input_sm = sm(:,:,time_frame_1(1)*12-11:time_frame_1(end)*12);  
    
    sm_monthly = reshape(input_sm,[length(lon) length(lat) 12 length(time_frame_1)]);

    [Lat,Lon] = meshgrid(lat,lon);
    
    % calculate anomaly 
    sm_clim = squeeze(nanmean(sm_monthly,4));
    sm_anom = sm_monthly - sm_clim; 
    

    sm_detr = zeros(size(sm_anom));
    for i_dx = 1:12
    sm_detr(:,:,i_dx,:)=detrend3(squeeze(sm_anom(:,:,i_dx,:)),'omitnan');
    end


    % set name  of field to use for regression
    var_anom_detr = sm_detr;

else
    strcmp('OLR',large_scale_variable)

    load ('OLR_NOAA.mat','lon','lat','olr','monthly_T')


    years_available = 1975:2023;
    disp(['Available years OLR: ', num2str(years_available(1)), ' to ', num2str(years_available(end))]);
    
    if start_year < years_available(1) || end_year > years_available(end) || start_year >= end_year
        error('Invalid year range. Please select within available data.');
    end
    
    time_frame_1 = find(years_available >= start_year & years_available <= end_year-1);

    % reshape into months years to match with shape of other variables 
    input_olr = olr(:,:,time_frame_1(1)*12-11:time_frame_1(end)*12);  
    olr_monthly = reshape(input_evap,[length(lon) length(lat) 12 length(time_frame_1)]);

    [Lat,Lon] = meshgrid(lat,lon);
    
    % calculate anomaly 
    olr_clim = squeeze(nanmean(olr_monthly,4));
    olr_anom = olr_monthly - olr_clim; 

    clear olr olr_clim 
   


    % set name  of field to use for regression
    var_anom = olr_anom;


end 


%% Regression Calculation for Climate Variables month by month during wet season October to April
months = [10, 11, 12, 1, 2, 3, 4]; % October to April
num_months = length(months);
slope_matrix_all = zeros(length(lon), length(lat), num_months);
month_P_all = zeros(length(lon), length(lat), num_months);

if strcmp('soil moisture lag-1',large_scale_variable)

    % lag-1 regression
    for m = 1:num_months
        month_idx = months(m);
    
        if month_idx>1
        input_field = squeeze(var_anom_detr(:,:,month_idx-1,2:end));
        else
            month_idx<=1
        input_field = squeeze(var_anom_detr(:,:,12,1:end-1));
        end 
    
        input_rain = rainfall_NA_anom_std(month_idx, 2:end);
        
        % Standardize climate variable
        std_field = std(input_field, 0, 3,'omitnan');
        mean_field = mean(input_field, 3);
        input_field = (input_field - mean_field) ./ std_field;
        
        % Regression calculation
        slope_matrix = NaN(length(lon), length(lat));
        for i = 1:length(lon)
            for j = 1:length(lat)
                if ~isnan(input_field(i, j, :))
                    coef = polyfit(input_rain(:), (squeeze(input_field(i, j, :)))', 1);
                    slope_matrix(i, j) = coef(1);
                end
            end
            
        end
        
        slope_matrix_all(:,:,m) = slope_matrix;
        [month_R, month_P] = corr3(input_field, input_rain);
        month_P_all(:,:,m) = month_P;
    
       
    end

elseif strcmp('OLR',large_scale_variable)

    for m = 1:num_months
        month_idx = months(m);
    
        input_field = squeeze(var_anom(:,:,month_idx,:));
        input_rain = rainfall_NA_anom_std(month_idx, :);
        
        % Standardize climate variable
        std_field = std(input_field, 0, 3,'omitnan');
        mean_field = mean(input_field, 3);
        input_field = (input_field - mean_field) ./ std_field;
        
        % Regression calculation
        slope_matrix = NaN(length(lon), length(lat));
        for i = 1:length(lon)
            for j = 1:length(lat)
                % find NaNs in OLR timeseries 
                olr_squeezed = squeeze(input_field(i,j,:))';
                validrows_olr = ~any(isnan(olr_squeezed), 1);
    
                % filter out NaNs in both timeseries
                % first get rid of potential NaNs in OLR, then in rainfall
                rainfall_no_nans = input_rain(validrows_olr);
                olr_no_nans = olr_squeezed(validrows_olr);
    
    
                % find NaNs in rainfall timeseries
                validrows_rain = ~any(isnan(rainfall_no_nans), 1);
                rainfall_no_nans = rainfall_no_nans(validrows_rain);
                olr_no_nans = olr_no_nans(validrows_rain);
    
                coef = polyfit(rainfall_no_nans, olr_no_nans, 1);
    
                slope_matrix(i,j) = coef(1);


            end
            
        end
        
        slope_matrix_all(:,:,m) = slope_matrix;
        

        % also get rid of NaNs for correlation and p values
        olr_no_nans_all = input_olr_std(:,:,validrows_olr);
        olr_no_nans_all = olr_no_nans_all(:,:,validrows_rain);
        
        % save p values for plotting 
         [month_R,month_P] = corr3(olr_no_nans_all,rainfall_no_nans);
         
        month_P_all(:,:,m) = month_P; 

    
    end


else 

% 'normal' regression

    for m = 1:num_months
        month_idx = months(m);
    
        input_field = squeeze(var_anom_detr(:,:,month_idx,:));
        input_rain = rainfall_NA_anom_std(month_idx, :);
        
        % Standardize climate variable
        std_field = std(input_field, 0, 3,'omitnan');
        mean_field = mean(input_field, 3);
        input_field = (input_field - mean_field) ./ std_field;
        
        % Regression calculation
        slope_matrix = NaN(length(lon), length(lat));
        for i = 1:length(lon)
            for j = 1:length(lat)
                if ~isnan(input_field(i, j, :))
                    coef = polyfit(input_rain(:), (squeeze(input_field(i, j, :)))', 1);
                    slope_matrix(i, j) = coef(1);
                end
            end
            
        end
        
        slope_matrix_all(:,:,m) = slope_matrix;
        [month_R, month_P] = corr3(input_field, input_rain);
        month_P_all(:,:,m) = month_P;
    
    end


end 

%% set matrix name according to analysed variable for saving and plotting

if strcmp('SST',large_scale_variable)

    slope_matrix_SST_all = slope_matrix_all;

elseif strcmp('MSLP',large_scale_variable)
    
    slope_matrix_mslp_all = slope_matrix_all;

elseif strcmp('850hPa uwnd',large_scale_variable)

    slope_matrix_uwnd_all = slope_matrix_all;
    month_P_uwnd_all = month_P_all;

elseif strcmp('850hPa vwnd',large_scale_variable)

    slope_matrix_vwnd_all = slope_matrix_all;
    month_P_vwnd_all = month_P_all;

elseif strcmp('200hPa hgt',large_scale_variable)
    
    slope_matrix_hgt_all = slope_matrix_all;

elseif strcmp('evaporation',large_scale_variable)

    slope_matrix_evap_all = slope_matrix_all;

elseif strcmp('soil moisture lag-1',large_scale_variable)

    slope_matrix_sm_all = slope_matrix_all;  

else 
    strcmp('OLR',large_scale_variable)

    slope_matrix_olr_all = slope_matrix_all; 

end 



%% Save results for plotting - modify output file name based on variable

if strcmp('SST',large_scale_variable)

    save('Slope_NA_rain_SSTa.mat', 'month_P_all', 'slope_matrix_all', 'Lon', 'Lat', '-v7.3');

elseif strcmp('MSLP',large_scale_variable) || strcmp('850hPa uwnd',large_scale_variable) || strcmp('850hPa vwnd',large_scale_variable)
    % run all three variables, then save 

    save('Slope_NA_rain_MSLP_wnd.mat','month_P_all','slope_matrix_mslp_all',...
    'month_P_uwnd_all','slope_matrix_uwnd_all', ...
    'month_P_vwnd_all','slope_matrix_vwnd_all', ...
    'lon','lat','Lon','Lat','-v7.3')

elseif strcmp('200hPa hgt',large_scale_variable)

    save('Slope_NA_rain_hgtz200.mat','month_P_all','slope_matrix_hgt_all','lon','lat','Lon','Lat','-v7.3')

elseif strcmp('evaporation',large_scale_variable)

    save('Slope_NA_rain_evap.mat','month_P_all','slope_matrix_evap_all','lon','lat','Lon','Lat','-v7.3')


elseif strcmp('soil moisture lag-1',large_scale_variable)

    save('Slope_NA_rain_smlagminus1.mat','month_P_all','slope_matrix_sm_all','lon','lat','Lon','Lat','-v7.3')

else 
    strcmp('OLR',large_scale_variable)

    save('Slope_NA_rain_OLR_NOAA.mat','month_P_all','slope_matrix_olr_all','lon','lat','Lon','Lat','-v7.3')


end 
