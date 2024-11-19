% northern Australian rainfall
% regressed onto Z200 geopotential height to be plotted in Figure_3_Regression_OLR_hgt.m 

% save regression output to be plotted! 

load ('AWAP_rainfall_1900_2023')

% set timeframe to analyse here
% timeperiod = '1920-1970';
%timeperiod = '1970-2023';
timeperiod = '1920-2015';

if strcmp('1920-2015',timeperiod)
    time_frame = 1:96;
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
input_rainfall_1 = precip(:,:,:,21:116); 



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


%% import ght Z200 

% choose pressure level - either 200 or 850hPa 
load ('20CRv3_hgt.mat','lon','lat','hgt_200_res','monthly_T')

lon1=lon;
lon1(361)=(lon1(360)-lon1(359))+lon1(360);
[Lon1,Lat1] = meshgrid(lat,lon1);

% calculate anomaly 
hgt = hgt_200_res;
hgt = hgt(:,:,:,85:180); 

hgt_clim = nanmean(hgt,4);
hgt_anom = hgt - hgt_clim; 


    hgt_detr = zeros(size(hgt_anom));
    for i_dx = 1:12
    hgt_detr(:,:,i_dx,:)=detrend3(squeeze(hgt_anom(:,:,i_dx,:)));
    end

clear hgt_200_res
clear hgt
clear hgt_clim 
clear hgt_ts

t1 = datetime(1920,1,15,0,0,0);
t2 = datetime(2015,1,15,0,0,0);
yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
   
   
land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');


%% next: calculate regression coefficients for each month with monthly geopotential height anomaly 
% need to standardise both input variables first 
load ('20CRv3_hgt.mat','lon','lat')

slope_matrix_hgt_all = zeros(length(lon),length(lat),7);

month_P_all = zeros(length(lon),length(lat),7);


for m = 1:7
    
    if m==1
       
        
        input_hgt = squeeze(hgt_detr(:,:,10,:));
        
        input_rain = rainfall_NA_anom_std(10,:);


        
    elseif m==2
       
        
        input_hgt = squeeze(hgt_detr(:,:,11,:));
      
        input_rain = rainfall_NA_anom_std(11,:);
 
        
    elseif m==3
        
        
        input_hgt = squeeze(hgt_detr(:,:,12,:));
        
        input_rain = rainfall_NA_anom_std(12,:);
        
    elseif m==4
      
        input_hgt = squeeze(hgt_detr(:,:,1,:));
      
        input_rain = rainfall_NA_anom_std(1,:);

        
    elseif m==5
     
        
        input_hgt = squeeze(hgt_detr(:,:,2,:));
        
        input_rain = rainfall_NA_anom_std(2,:);
        
   
    elseif m==6
       
        
        input_hgt = squeeze(hgt_detr(:,:,3,:));
        
        input_rain = rainfall_NA_anom_std(3,:);
      
    else
        m==7
       
        
        input_hgt = squeeze(hgt_detr(:,:,4,:));
       
        input_rain = rainfall_NA_anom_std(4,:);
        
  
        
    end 


% standardize

std_hgt = std(input_hgt,0,3);
mean_hgt = mean(input_hgt,3);
input_hgt_std=(input_hgt-mean_hgt)./std_hgt;
input_hgt=input_hgt_std;

slope_matrix_hgt = zeros(length(lon),length(lat),1);


h = waitbar(0, 'Please wait...');
number_of_runs = length(lon);

for i = 1:length(lon)
    for j = 1:length(lat)
       
        if isnan(input_hgt(i,j,:)) 
            continue 

        else 
            coef = polyfit(input_rain(:), (squeeze(input_hgt(i,j,:)))', 1);
            slope_matrix_hgt(i,j) = coef(1);
            


        end
       
    
    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_hgt_all(:,:,m) = slope_matrix_hgt;
   
% save p values for plotting 
 [month_R,month_P] = corr3(input_hgt,input_rain);
 
month_P_all(:,:,m) = month_P; 


end


%% save in matrix for quicker plotting and figure editing 

save('Slope_NA_rain_hgtz200.mat','month_P_all','slope_matrix_hgt_all','lon','lat','Lon','Lat','-v7.3')


