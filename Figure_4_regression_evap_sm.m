% Figure 4 in Heidemann et al. (2025)

% regression coefficient maps between 1) evaporation  and 2) soil moisture regressed and northern Australian rainfall


% data for evaporation regression generated and saved in :
% run Australian_evap_rain_regression_Oct_Apr.m --> Slope_NA_rain_evap.mat

% data for soil moisture generated and saved in: 
% run Australian_smlagminus1_rainfall_regression_Oct_Apr.m --> 'Slope_NA_rain_smlagminus1.mat'


% load data 
load 'Slope_NA_rain_evap.mat'


[Lon,Lat] = meshgrid(lat,lon);

land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');


figure('pos',[10 10 1100 1000])

for m = 1:7
    
    if m==1
        a=subplot(4,4,m)
        
        title_str = {'October'};
        
     
        
    elseif m==2
        c=subplot(4,4,m)
        
        title_str = {'November'};
        
       
 
        
    elseif m==3
        d=subplot(4,4,m)
        
        title_str = {'December'};
        
        
        
        
    elseif m==4
        e=subplot(4,4,m)
        
        title_str = {'January'};
        
       

        
    elseif m==5
        f=subplot(4,4,m)
        
        title_str = {'February'};
        
        
        
   
    elseif m==6
        g=subplot(4,4,m)
        
        title_str = {'March'};
        
        
    elseif m==7
        h_1=subplot(4,4,m)
        
        title_str = {'April'};
    end 


month_P = month_P_all(:,:,m);


input_plot = slope_matrix_evap_all(:,:,m);



h = worldmap([-45 0],[75 165]);

setm(h,'MapProjection','mercator');
getm(h,'MapProjection');

geoshow(Lon,Lat,input_plot,'Displaytype','texturemap');
colormap(h,(brewermap(16,'RdBu')));
hold on 

% add significance as contour lines
sign_pval=month_P<=0.05;
sign_pval = double(sign_pval);
contourm(Lon,Lat,sign_pval,[1 1],'Color',rgb('dark grey'),'LineWidth',1);

hold on 
geoshow(landLat,landLon,'Color','k')

caxis([-0.8 0.8])
title(title_str,'FontSize',13);
mlabel('off')
plabel('off')

        
        
        
end 



    cb = colorbar


    cb.Position = [0.9 0.58 0.017 0.34]; 
   
    cb.Label.String = '\beta (NA rainfall, evaporation anomaly, 1940-2023)'; 

    cb.FontSize=12;


%% add regression for lag-1 soil moisture 

ocean_file = 'ne_10m_ocean.shp'; 
O = shaperead(ocean_file,'UseGeoCoords',true);
oceanLat = extractfield(O,'Lat');
oceanLon = extractfield(O,'Lon');


load 'Slope_NA_rain_smlagminus1.mat'
[Lon,Lat] = meshgrid(lat,lon);


for m = 1:7
    
    if m==1
        a2=subplot(4,4,m+8)
        
        title_str = {'October'};
        
     
        
    elseif m==2
        c2=subplot(4,4,m+8)
        
        title_str = {'November'};
        
       
 
        
    elseif m==3
        d2=subplot(4,4,m+8)
        
        title_str = {'December'};
        
        
        
        
    elseif m==4
        e2=subplot(4,4,m+8)
        
        title_str = {'January'};
        
       

        
    elseif m==5
        f2=subplot(4,4,m+8)
        
        title_str = {'February'};
        
        
        
   
    elseif m==6
        g2=subplot(4,4,m+8)
        
        title_str = {'March'};
        
        
    elseif m==7
        h_2=subplot(4,4,m+8)
        
        title_str = {'April'};
        
        
        
    end 



month_P = month_P_all(:,:,m);
 

input_plot = slope_matrix_sm_all(:,:,m);


h2 = worldmap([-44 -10],[112 154]);
setm(h2,'MapProjection','mercator');
getm(h2,'MapProjection');

geoshow(Lon,Lat,input_plot,'Displaytype','texturemap');
colormap(h2,(brewermap(12,'PiYG')));
hold on 

% add significance as contour lines
sign_pval=month_P<=0.05;
sign_pval = double(sign_pval);
contourm(Lon,Lat,sign_pval,[1 1],'Color',rgb('dark grey'),'LineWidth',1);

hold on 

[oceanLat,oceanLon] = maptriml(oceanLat,oceanLon,[-44 -10],[112 154]);
geoshow(oceanLat, oceanLon,'DisplayType','polygon','FaceColor','white');
geoshow(oceanLat,oceanLon,'Color','k')

caxis([-0.6 0.6])
title(title_str,'FontSize',13);

mlabel('off')
plabel('off')



end 





    cb2 = colorbar


    cb2.Position = [0.9 0.1 0.017 0.35]; 
    cb2.Label.String = {'\beta (NA rainfall, soil moisture lag-1 anomalies,';'1920-2023)'}; 

    cb2.FontSize=12;




    %% set size of plots 


% geopotential height 200hPa 
set(a,'Position',[0.001 0.73 0.24 0.3]);
set(c,'Position',[0.22 0.73 0.24 0.3]);
set(d,'Position',[0.44 0.73 0.24 0.3]);
set(e,'Position',[0.66 0.73 0.24 0.3]);

set(f,'Position',[0.001 0.5 0.24 0.3]);
set(g,'Position',[0.22 0.5 0.24 0.3]);
set(h_1,'Position',[0.44 0.5 0.24 0.3]);

% OLR
set(a2,'Position',[0.001 0.28 0.25 0.25]);
set(c2,'Position',[0.22 0.28 0.25 0.25]);
set(d2,'Position',[0.44 0.28 0.25 0.25]);
set(e2,'Position',[0.66 0.28 0.25 0.25]);

set(f2,'Position',[0.001 0.02 0.25 0.25]);
set(g2,'Position',[0.22 0.02 0.25 0.25]);
set(h_2,'Position',[0.44 0.02 0.25 0.25]);


%% add labels 

annotation('textbox',[.025 .805 .1 .2],'String','(a)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.24 .805 .1 .2],'String','(b)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.46 .805 .1 .2],'String','(c)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.68 .805 .1 .2],'String','(d)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .575 .1 .2],'String','(e)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.24 .575 .1 .2],'String','(f)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.46 .575 .1 .2],'String','(g)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .36 .1 .2],'String','(h)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.24 .36 .1 .2],'String','(i)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.46 .36 .1 .2],'String','(j)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.68 .36 .1 .2],'String','(k)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .1 .1 .2],'String','(l)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.24 .1 .1 .2],'String','(m)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.46 .1 .1 .2],'String','(n)','FontSize',10,'FontWeight','bold','EdgeColor','none')



%% save figure 
% to make sure that contour lines are also saved in white (and not falsely
% in black) 

set(gcf,'InvertHardCopy','off');
set(gcf,'color','w');


print('Fig_4_Regr_NA_rainfall_sm_darkgrey','-dtiff','-r300')

