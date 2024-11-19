% northern Australian rainfall
% regressed onto soil moisutre (lag-1) to be plotted in Figure_4_regression_evap_sm.m 

% save regression output to be plotted! 

load ('AWAP_rainfall_1900_2023')

% set timeframe to analyse here
% timeperiod = '1920-1970';
%timeperiod = '1970-2023';
timeperiod = '1920-2023';

%time_frame = 1:103;
input_rainfall_1 = precip(:,:,:,21:123); 



length_years = size(input_rainfall_1,4);

[Lat,Lon] = meshgrid(lat,lon);

clear precip

% get region 

% mask out ocean grid points

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

%lon_idx = idx_east;

%lon_idx = idx_west;
%rainfall_NA_anom = nanmean(Rainfall_anomaly(lon_idx,lat_idx,:,:),1);
% use this for all north of 20S 
rainfall_NA_anom = nanmean(Rainfall_anomaly(:,lat_idx,:,:),1);
rainfall_NA_anom=squeeze(nanmean(rainfall_NA_anom,2));


% this is for detrended data
rainfall_NA_detr = zeros(size(rainfall_NA_anom));
for i_dx = 1:12
rainfall_NA_detr(i_dx,:)=detrend(rainfall_NA_anom(i_dx,:));
end

% standardize
rainfall_NA_anom_std = zeros(size(rainfall_NA_detr));
for i_dx = 1:12
rainfall_NA_anom_std(i_dx,:)=(rainfall_NA_detr(i_dx,:)-mean(rainfall_NA_detr(i_dx,:)))/std(rainfall_NA_detr(i_dx,:));
end



clear Rainfall_climatology
clear rainfall_land
clear input_rainfall
clear input_rainfall_1


%% import AWRA-L soil moisture

fid = 'AWRAL_sm_1920_2023.nc';
sm = ncread(fid,'__xarray_dataarray_variable__');
time=double(ncread(fid,'time'));
local_time = time+datenum(1900,1,1,0,0,0);
max_time = datestr(local_time(end))
lon = ncread(fid,'longitude');
lat = ncread(fid,'latitude');


input_sm =sm(:,:,1:1236);


sm_monthly = reshape(input_sm,[841 681 12 103]);

[Lat,Lon] = meshgrid(lat,lon);

% calculate anomaly 
sm_clim = squeeze(nanmean(sm_monthly,4));
sm_anom = sm_monthly - sm_clim; 

% detrend each moth separately

    sm_detr = zeros(size(sm_anom));
    for i_dx = 1:12
    sm_detr(:,:,i_dx,:)=detrend3(squeeze(sm_anom(:,:,i_dx,:)),'omitnan');
    end



clear sm_clim 


t1 = datetime(1920,1,15,0,0,0);
t2 = datetime(2023,1,15,0,0,0);
yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
   
   
ocean_file = 'ne_10m_ocean.shp'; 
O = shaperead(ocean_file,'UseGeoCoords',true);
oceanLat = extractfield(O,'Lat');
oceanLon = extractfield(O,'Lon');


%% next: calculate regression coefficients for each month 
% need to standardise both input variables first 


slope_matrix_sm_all = zeros(length(lon),length(lat),7);

month_P_all = zeros(length(lon),length(lat),7);


for m = 1:7
    
    if m==1
       
        
        input_sm = squeeze(sm_detr(:,:,9,2:end));
        
        input_rain = rainfall_NA_anom_std(10,2:end);


        
    elseif m==2
       
        
        input_sm = squeeze(sm_detr(:,:,10,2:end));
      
        input_rain = rainfall_NA_anom_std(11,2:end);
 
        
    elseif m==3
        
        
        input_sm = squeeze(sm_detr(:,:,11,2:end));
        
        input_rain = rainfall_NA_anom_std(12,2:end);
        
    elseif m==4
      
        input_sm = squeeze(sm_detr(:,:,12,1:end-1));
      
        input_rain = rainfall_NA_anom_std(1,2:end);

        
    elseif m==5
     
        
        input_sm = squeeze(sm_detr(:,:,1,2:end));
        
        input_rain = rainfall_NA_anom_std(2,2:end);
        
   
    elseif m==6
       
        
        input_sm = squeeze(sm_detr(:,:,2,2:end));
        
        input_rain = rainfall_NA_anom_std(3,2:end);
      
    else
        m==7
       
        
        input_sm = squeeze(sm_detr(:,:,3,2:end));
       
        input_rain = rainfall_NA_anom_std(4,2:end);
        
  
        
    end 


% standardize

std_sm = std(input_sm,0,3,"omitnan");
mean_sm = nanmean(input_sm,3);
input_sm_std=(input_sm-mean_sm)./std_sm;
input_sm=input_sm_std;

slope_matrix_sm = zeros(length(lon),length(lat),1);


h = waitbar(0, 'Please wait...');
number_of_runs = length(lon);

for i = 1:length(lon)
    for j = 1:length(lat)
       
        if isnan(input_sm(i,j,:)) 
            continue 

        else 
            coef = polyfit(input_rain(:), (squeeze(input_sm(i,j,:)))', 1);
            slope_matrix_sm(i,j) = coef(1);
            


        end
       
    
    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_sm_all(:,:,m) = slope_matrix_sm;
   
% save p values for plotting 
 [month_R,month_P] = corr3(input_sm,input_rain);
 
month_P_all(:,:,m) = month_P; 


end


%% save in matrix for quicker plotting and figure editing 

save('Slope_NA_rain_smlagminus1.mat','month_P_all','slope_matrix_sm_all','lon','lat','Lon','Lat','-v7.3')
