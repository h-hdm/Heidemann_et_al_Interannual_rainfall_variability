% monthly regression of northern Australian rainfall and global MSLP,
% and 850hpa or 200hPa uwnd or vwnd from 20CRv3

% save data for easier plotting in Figure_2_regression_maps_SSTa_MSLP.m


load ('AWAP_rainfall_1900_2023')

% only up to 2015 when the MSLP data end 
input_rainfall_1 = precip(:,:,:,21:116); 

length_years = size(input_rainfall_1,4);

[Lat,Lon] = meshgrid(lat,lon);

clear precip



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

%% get area average for region

% option to do NE and NW separately, or all-northern
% Australia 

idx_east = lon >= 135;
idx_east = find(idx_east ==1);

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

%% MSLP

load 20CRv3_MSLP_1836_2015.mat 
lon1=lon;
lon1(361)=(lon1(360)-lon1(359))+lon1(360);
[Lon1,Lat1] = meshgrid(lat,lon1);

% calculate anomaly 
mslp = twentyCRv3_mslp_res;
mslp = mslp(:,:,:,85:180); 

MSLP_clim = nanmean(mslp,4);
MSLP_anom = mslp - MSLP_clim; 


    MSLP_detr = zeros(size(MSLP_anom));
    for i_dx = 1:12
    MSLP_detr(:,:,i_dx,:)=detrend3(squeeze(MSLP_anom(:,:,i_dx,:)));
    end


t1 = datetime(1920,1,15,0,0,0);
t2 = datetime(2015,1,15,0,0,0);
yearly_T = (t1:calendarDuration(1,0,0,0,0,0):t2)';
    
time = yearly_T.Year;

clear twentyCRv3_mslp_res
clear twentyCRv3_mslp
clear MSLP_clim 
clear MSLP_ts


% uwnd
load 20CRv3_uwnd.mat
% calculate anomaly 
uwnd = uwnd_850_res;
uwnd = uwnd(:,:,:,85:180); 

uwnd_clim = nanmean(uwnd,4);
uwnd_anom = uwnd - uwnd_clim; 


    uwnd_detr = zeros(size(uwnd_anom));
    for i_dx = 1:12
    uwnd_detr(:,:,i_dx,:)=detrend3(squeeze(uwnd_anom(:,:,i_dx,:)));
    end

clear uwnd_850hPa 
clear uwnd_clim 
clear uwnd_200hPa  
clear uwnd_ts

% vwnd
load 20CRv3_vwnd.mat
% calculate anomaly 
vwnd = vwnd_850_res;
vwnd = vwnd(:,:,:,85:180); 

vwnd_clim = nanmean(vwnd,4);
vwnd_anom = vwnd - vwnd_clim; 



    vwnd_detr = zeros(size(vwnd_anom));
    for i_dx = 1:12
    vwnd_detr(:,:,i_dx,:)=detrend3(squeeze(vwnd_anom(:,:,i_dx,:)));
    end

clear vwnd_850hPa 
clear vwnd_clim 
clear vwnd_200hPa  
clear vwnd_ts


   
   
land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');




%% next: calculate regression coefficients for each month with monthly MSLP and zonal and meridional winds 
% need to standardise both input variables first 

slope_matrix_mslp_all = zeros(length(lon),length(lat),7);
slope_matrix_uwnd_all = zeros(length(lon),length(lat),7);
slope_matrix_vwnd_all = zeros(length(lon),length(lat),7);

month_P_all = zeros(length(lon),length(lat),7);
month_P_uwnd_all = zeros(length(lon),length(lat),7);
month_P_vwnd_all = zeros(length(lon),length(lat),7);



% Oct to Apr
for m = 1:7
    
    if m==1
       
        
        input_mslp = squeeze(MSLP_detr(:,:,10,:));
        input_uwnd = squeeze(uwnd_detr(:,:,10,:));
         input_vwnd = squeeze(vwnd_detr(:,:,10,:));
        input_rain = rainfall_NA_anom_std(10,:);

        
    elseif m==2
       
        
        input_mslp = squeeze(MSLP_detr(:,:,11,:));
        input_uwnd = squeeze(uwnd_detr(:,:,11,:));
         input_vwnd = squeeze(vwnd_detr(:,:,11,:));
        input_rain = rainfall_NA_anom_std(11,:);
 
        
    elseif m==3
        
        
        input_mslp = squeeze(MSLP_detr(:,:,12,:));
        input_uwnd = squeeze(uwnd_detr(:,:,12,:));
        input_vwnd = squeeze(vwnd_detr(:,:,12,:));
        input_rain = rainfall_NA_anom_std(12,:);
        
    elseif m==4
      
        input_mslp = squeeze(MSLP_detr(:,:,1,:));
        input_uwnd = squeeze(uwnd_detr(:,:,1,:));
        input_vwnd = squeeze(vwnd_detr(:,:,1,:));
        input_rain = rainfall_NA_anom_std(1,:);

        
    elseif m==5
     
        
        input_mslp = squeeze(MSLP_detr(:,:,2,:));
        input_uwnd = squeeze(uwnd_detr(:,:,2,:));
        input_vwnd = squeeze(vwnd_detr(:,:,2,:));
        input_rain = rainfall_NA_anom_std(2,:);
        
   
    elseif m==6
       
        
        input_mslp = squeeze(MSLP_detr(:,:,3,:));
        input_uwnd = squeeze(uwnd_detr(:,:,3,:));
        input_vwnd = squeeze(vwnd_detr(:,:,3,:));
        input_rain = rainfall_NA_anom_std(3,:);
      
    else
        m==7
       
        
        input_mslp = squeeze(MSLP_detr(:,:,4,:));
        input_uwnd = squeeze(uwnd_detr(:,:,4,:));
         input_vwnd = squeeze(vwnd_detr(:,:,4,:));
        input_rain = rainfall_NA_anom_std(4,:);
        
        
    end 

% standardize

std_mslp = std(input_mslp,0,3);
mean_mslp = mean(input_mslp,3);
input_mslp_std=(input_mslp-mean_mslp)./std_mslp;
input_mslp = [];
input_mslp=input_mslp_std;

slope_matrix_mslp = zeros(length(lon),length(lat),1);
slope_matrix_uwnd = zeros(length(lon),length(lat),1);
slope_matrix_vwnd = zeros(length(lon),length(lat),1);


h = waitbar(0, 'Please wait...');
number_of_runs = length(lon);

for i = 1:length(lon)
    for j = 1:length(lat)
       
        if isnan(input_mslp(i,j,:)) 
            continue 

        else 
            coef = polyfit(input_rain(:), (squeeze(input_mslp(i,j,:)))', 1);
            slope_matrix_mslp(i,j) = coef(1);
            coef1 = polyfit(input_rain(:), (squeeze(input_uwnd(i,j,:)))', 1);
            slope_matrix_uwnd(i,j) = coef1(1);
            coef2 = polyfit(input_rain(:), (squeeze(input_vwnd(i,j,:)))', 1);
            slope_matrix_vwnd(i,j) = coef2(1);


        end
       
    
    waitbar(i / number_of_runs, h, ['Number of the longitude cell: ' num2str(i)])
    end 
end
 
 % close the waitbar
close(h)

% save all regression coefficients for plotting
slope_matrix_mslp_all(:,:,m) = slope_matrix_mslp;
slope_matrix_uwnd_all(:,:,m) = slope_matrix_uwnd;
slope_matrix_vwnd_all(:,:,m) = slope_matrix_vwnd;
   
% save p values for plotting 
 [month_R,month_P] = corr3(input_mslp,input_rain);
 [month_R_uwnd,month_P_uwnd] = corr3(input_uwnd,input_rain);
 [month_R_vwnd,month_P_vwnd] = corr3(input_vwnd,input_rain);

month_P_all(:,:,m) = month_P; 
month_P_uwnd_all(:,:,m) = month_P_uwnd; 
month_P_vwnd_all(:,:,m) = month_P_vwnd;


end

%% save regression data for quicker plotting 

save('Slope_NA_rain_MSLP_wnd.mat','month_P_all','slope_matrix_mslp_all',...
    'month_P_uwnd_all','slope_matrix_uwnd_all', ...
    'month_P_vwnd_all','slope_matrix_vwnd_all', ...
    'lon','lat','Lon','Lat','-v7.3')


