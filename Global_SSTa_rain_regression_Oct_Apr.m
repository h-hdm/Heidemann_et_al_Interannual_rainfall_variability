% monthly regression of northern Australian rainfall and global SSTa
% save data for easier plotting in Figure_2_regression_maps_SSTa_MSLP.m

load ('AWAP_rainfall_1900_2023')

% set timeframe to analyse here
% timeperiod = '1920-1970';
% timeperiod = '1970-2023';
timeperiod = '1920-2023';

if strcmp('1920-2023',timeperiod)
    time_frame = 1:103;
elseif strcmp('1920-1970',timeperiod)
    time_frame = 1:50;
else
    strcmp('1970-2023',timeperiod)
    time_frame = 51:103;
end 

% change to explore different time periods 
% 1920 to 1970
%time_frame = 1:50;
%input_rainfall_1 = precip(:,:,:,21:70); 
%1970 to 2023
%time_frame = 1:53;
% input_rainfall_1 = precip(:,:,:,71:124); 
% 1920 to 2023
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


%% SST

load 'HadISST_1870_2023.mat'

[Lon,Lat] = meshgrid(glat,glon);

% 1920 to 1970 
% SST_climatology = squeeze(nanmean(SST_resized(:,:,:,51:100),4));
% SST_anom = SST_resized(:,:,:,51:100)- SST_climatology;

% SST_climatology = squeeze(nanmean(SST_resized(:,:,:,101:end),4));
% SST_anom = SST_resized(:,:,:,101:end)- SST_climatology;

% 1920 to 2023
SST_climatology = squeeze(nanmean(SST_resized(:,:,:,51:153),4));
SST_anom = SST_resized(:,:,:,51:153)- SST_climatology;


   clear SST_climatology
   clear sst
   clear SST_resized
   clear SST_anomaly_ts


    SST_anom_detr = zeros(size(SST_anom));
    for i_dx = 1:12
    SST_anom_detr(:,:,i_dx,:)=detrend3(squeeze(SST_anom(:,:,i_dx,:)));
    end

   
land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');


%% get area average for region

% option to do NE and NW, or all Northern Australia

idx_east = lon >= 135;
idx_east = find(idx_east ==1);

idx_west = lon < 135; 
idx_west = find(idx_west ==1);

idx = lat >= -20;
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


%% next: calculate regression coefficients for each month with monthly SSTa  
% need to standardise both input variables first --> rainfall is already
% standardised and SST will be standardised month by month in the following


% only October to April needed 

slope_matrix_SST_all = zeros(length(glon),length(glat),7);

month_P_all = zeros(length(glon),length(glat),7);

 
for m = 1:7
    
    if m==1
       
         
         input_SST = squeeze(SST_anom_detr(:,:,10,:));
        
         input_rain = rainfall_NA_anom_std(10,:);


        
    elseif m==2
       
        
        input_SST = squeeze(SST_anom_detr(:,:,11,:));
      
        input_rain = rainfall_NA_anom_std(11,:);
 
        
    elseif m==3
        
        
        input_SST = squeeze(SST_anom_detr(:,:,12,:));
        
        input_rain = rainfall_NA_anom_std(12,:);
        
    elseif m==4
      
        input_SST = squeeze(SST_anom_detr(:,:,1,:));
      
        input_rain = rainfall_NA_anom_std(1,:);

        
    elseif m==5
     
        
        input_SST = squeeze(SST_anom_detr(:,:,2,:));
        
        input_rain = rainfall_NA_anom_std(2,:);
        
   
    elseif m==6
       
        
        input_SST = squeeze(SST_anom_detr(:,:,3,:));
        
        input_rain = rainfall_NA_anom_std(3,:);
      
    else
        m==7
       
        
        input_SST = squeeze(SST_anom_detr(:,:,4,:));
       
        input_rain = rainfall_NA_anom_std(4,:);
        
        
    end 


% standardize

std_sst = std(input_SST,0,3);
mean_sst = mean(input_SST,3);
input_sst_std=(input_SST-mean_sst)./std_sst;
input_SST=input_sst_std;

slope_matrix_sst = zeros(length(glon),length(glat),1);



h = waitbar(0, 'Please wait...');
number_of_runs = length(glon);

for i = 1:length(glon)
    for j = 1:length(glat)
       
        if isnan(input_SST(i,j,:)) 
            continue 

        else 
            coef = polyfit(input_rain(:), (squeeze(input_SST(i,j,:)))', 1);
            slope_matrix_sst(i,j) = coef(1);
            


        end
       
    
    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_SST_all(:,:,m) = slope_matrix_sst;
   
% save p values for plotting 
 [month_R,month_P] = corr3(input_SST,input_rain);
 
month_P_all(:,:,m) = month_P; 


end

%% save in matrix for quicker plotting and figure editing 

save('Slope_NA_rain_SSTa.mat','month_P_all','slope_matrix_SST_all','lon','lat','Lon','Lat','-v7.3')

