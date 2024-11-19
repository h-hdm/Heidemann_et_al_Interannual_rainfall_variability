% northern Australian rainfall
% regressed onto evaporation to be plotted in Figure_4_regression_evap_sm.m 

% save regression output to be plotted! 

load ('AWAP_rainfall_1900_2023')

% set timeframe to analyse here
% timeperiod = '1920-1970';
%timeperiod = '1970-2023';
timeperiod = '1940-2023';

%time_frame = 1:103;
input_rainfall_1 = precip(:,:,:,41:123); 



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


%% import evap ERA5

load ('Evap_ERA5.mat','lon','lat','evap')

input_evap = evap(:,:,1:996); 
input_evap = abs(input_evap);

evap_monthly = reshape(input_evap,[361 181 12 83]);

[Lat,Lon] = meshgrid(lat,lon);

% calculate anomaly 
evap_clim = squeeze(nanmean(evap_monthly,4));
evap_anom = evap_monthly - evap_clim; 

% detrend each moth separately

    evap_detr = zeros(size(evap_anom));
    for i_dx = 1:12
    evap_detr(:,:,i_dx,:)=detrend3(squeeze(evap_anom(:,:,i_dx,:)));
    end


clear evap
clear evap_clim 


t1 = datetime(1940,1,15,0,0,0);
t2 = datetime(2023,1,15,0,0,0);
yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
   
   
land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');


%% next: calculate regression coefficients for each month 
% need to standardise both input variables first 
load ('Evap_ERA5.mat','lon','lat')

slope_matrix_evap_all = zeros(length(lon),length(lat),7);

month_P_all = zeros(length(lon),length(lat),7);


for m = 1:7
    
    if m==1
       
        
        input_evap = squeeze(evap_detr(:,:,10,:));
        
        input_rain = rainfall_NA_anom_std(10,:);


        
    elseif m==2
       
        
        input_evap = squeeze(evap_detr(:,:,11,:));
      
        input_rain = rainfall_NA_anom_std(11,:);
 
        
    elseif m==3
        
        
        input_evap = squeeze(evap_detr(:,:,12,:));
        
        input_rain = rainfall_NA_anom_std(12,:);
        
    elseif m==4
      
        input_evap = squeeze(evap_detr(:,:,1,:));
      
        input_rain = rainfall_NA_anom_std(1,:);

        
    elseif m==5
     
        
        input_evap = squeeze(evap_detr(:,:,2,:));
        
        input_rain = rainfall_NA_anom_std(2,:);
        
   
    elseif m==6
       
        
        input_evap = squeeze(evap_detr(:,:,3,:));
        
        input_rain = rainfall_NA_anom_std(3,:);
      
    else
        m==7
       
        
        input_evap = squeeze(evap_detr(:,:,4,:));
       
        input_rain = rainfall_NA_anom_std(4,:);
        
  
        
    end 


% standardize

std_evap = std(input_evap,0,3);
mean_evap = mean(input_evap,3);
input_evap_std=(input_evap-mean_evap)./std_evap;
input_evap=input_evap_std;

slope_matrix_evap = zeros(length(lon),length(lat),1);


h = waitbar(0, 'Please wait...');
number_of_runs = length(lon);

for i = 1:length(lon)
    for j = 1:length(lat)
       
        if isnan(input_evap(i,j,:)) 
            continue 

        else 
            coef = polyfit(input_rain(:), (squeeze(input_evap(i,j,:)))', 1);
            slope_matrix_evap(i,j) = coef(1);
            


        end
       
    
    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_evap_all(:,:,m) = slope_matrix_evap;
   
% save p values for plotting 
 [month_R,month_P] = corr3(input_evap,input_rain);
 
month_P_all(:,:,m) = month_P; 


end


%% save in matrix for quicker plotting and figure editing 

save('Slope_NA_rain_evap.mat','month_P_all','slope_matrix_evap_all','lon','lat','Lon','Lat','-v7.3')

