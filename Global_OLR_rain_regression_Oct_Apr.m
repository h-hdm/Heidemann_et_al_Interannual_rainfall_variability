% norhtern Australian rainfall
% regressed onto OLR to be plotted in Figure_3_Regression_OLR_hgt.m 

% save regression output to be plotted! 

load ('AWAP_rainfall_1900_2023')

% set timeframe to analyse here
% timeperiod = '1920-1970';
%timeperiod = '1970-2023';
% timeperiod = '1940-2023';

%time_frame = 1:103;
input_rainfall_1 = precip(:,:,:,76:123); 



length_years = size(input_rainfall_1,4);

[Lat,Lon] = meshgrid(lat,lon);

clear precip

% get region 

% mask out ocean grid points

% land = landmask(Lat, Lon, 'Australia');
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


%% import olr ERA5


load ('OLR_NOAA.mat','lon','lat','olr','monthly_T')

input_olr = olr(:,:,8:583); 
olr_monthly = reshape(input_olr,[144 73 12 48]);

[Lat,Lon] = meshgrid(lat,lon);

% calculate anomaly 
olr_clim = squeeze(nanmean(olr_monthly,4));
olr_anom = olr_monthly - olr_clim; 

%  --> detrending OLR doesn't seem to make
% sense, try without

%     olr_detr = zeros(size(olr_anom));
%     for i_dx = 1:12
%     olr_detr(:,:,i_dx,:)=detrend3(squeeze(olr_anom(:,:,i_dx,:)),'omitnan');
%     end


clear olr
clear olr_clim 


t1 = datetime(1975,1,15,0,0,0);
t2 = datetime(2023,1,15,0,0,0);
yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
   
   
land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');


%% next: calculate regression coefficients for each month with monthly geopotential height anomaly and plot all in one figure 
% need to standardise both input variables first 
load ('OLR_NOAA.mat','lon','lat')

slope_matrix_olr_all = zeros(length(lon),length(lat),7);

month_P_all = zeros(length(lon),length(lat),7);

% 9 subplots 
for m = 1:7
    
    if m==1
       
        
        input_olr = squeeze(olr_anom(:,:,10,:));
        
        input_rain = rainfall_NA_anom_std(10,:);


        
    elseif m==2
       
        
        input_olr = squeeze(olr_anom(:,:,11,:));
      
        input_rain = rainfall_NA_anom_std(11,:);
 
        
    elseif m==3
        
        
        input_olr = squeeze(olr_anom(:,:,12,:));
        
        input_rain = rainfall_NA_anom_std(12,:);
        
    elseif m==4
      
        input_olr = squeeze(olr_anom(:,:,1,:));
      
        input_rain = rainfall_NA_anom_std(1,:);

        
    elseif m==5
     
        
        input_olr = squeeze(olr_anom(:,:,2,:));
        
        input_rain = rainfall_NA_anom_std(2,:);
        
   
    elseif m==6
       
        
        input_olr = squeeze(olr_anom(:,:,3,:));
        
        input_rain = rainfall_NA_anom_std(3,:);
      
    else
        m==7
       
        
        input_olr = squeeze(olr_anom(:,:,4,:));
       
        input_rain = rainfall_NA_anom_std(4,:);
        
  
        
    end 


% standardize

std_olr = std(input_olr,0,3,"omitnan");
mean_olr = nanmean(input_olr,3);
input_olr_std=(input_olr-mean_olr)./std_olr;
% input_olr=input_olr_std;

slope_matrix_olr = zeros(length(lon),length(lat),1);


h = waitbar(0, 'Please wait...');
number_of_runs = length(lon);

for i = 1:length(lon)
    for j = 1:length(lat)
       

            % find NaNs in OLR timeseries 
            olr_squeezed = squeeze(input_olr_std(i,j,:))';
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

            slope_matrix_olr(i,j) = coef(1);
            

    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_olr_all(:,:,m) = slope_matrix_olr;
  
% also get rid of NaNs for correlation and p values
olr_no_nans_all = input_olr_std(:,:,validrows_olr);
olr_no_nans_all = olr_no_nans_all(:,:,validrows_rain);

% save p values for plotting 
 [month_R,month_P] = corr3(olr_no_nans_all,rainfall_no_nans);
 
month_P_all(:,:,m) = month_P; 


end


%% save in matrix for quicker plotting and figure editing 

save('Slope_NA_rain_OLR_NOAA.mat','month_P_all','slope_matrix_olr_all','lon','lat','Lon','Lat','-v7.3')

