% plot figure 3 for paper: global maps with northern Australian rainfall
% regressed onto Z200 geopotential height and Outgoing longwave radiation 

% data for OLR regression generated and saved in :
% Global_OLR_rain_regression_Oct_Apr.m --> Slope_NA_rain_OLR_NOAA.mat

% data for hgt generated and saved in: 
% Global_hgt_z200_rain_regression_Oct_Apr.m --> 'Slope_NA_rain_hgtz200.mat'


load 'Slope_NA_rain_hgtz200.mat'


lon1=lon;
lon1(361)=(lon1(360)-lon1(359))+lon1(360);
[Lon1,Lat1] = meshgrid(lat,lon1);

land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');

figure('pos',[10 10 1300 1100])

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
month_P(361,:)=month_P(360,:); 


input_plot = slope_matrix_hgt_all(:,:,m);
input_plot(361,:)=input_plot(360,:);


h = worldmap('World');

setm(h,'Origin',[0 180 0]);
getm(h,'MapProjection');
setm(h,'MlabelParallel','south');
geoshow(Lon1,Lat1,input_plot,'Displaytype','texturemap');
colormap(h,flipud(brewermap(16,'RdBu')));
hold on 

% add significance as contour lines
sign_pval=month_P<=0.05;
sign_pval = double(sign_pval);
contourm(Lon1,Lat1,sign_pval,[1 1],'Color',[.56 .56 .56],'LineWidth',1);

hold on 
geoshow(landLat,landLon,'Color','k')

caxis([-0.8 0.8])
title(title_str,'FontSize',14);
mlabel('off')
plabel('off')

                
        
end 



    cb = colorbar


    cb.Position = [0.9 0.6 0.017 0.34]; %adjust!
    % adjust label depending on the variable! 
    cb.Label.String = '\beta (NA rainfall, \phi 200hPa anomaly, 1920-2015)'; 

    cb.FontSize=12;

    %% 

load 'Slope_NA_rain_OLR_NOAA.mat'
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


% insert plotting info here 
month_P = month_P_all(:,:,m);
 

input_plot = slope_matrix_olr_all(:,:,m);

h2 = worldmap('World');
setm(h2,'Origin',[0 180 0]);
getm(h2,'MapProjection');
setm(h2,'MlabelParallel','south');


geoshow(Lon,Lat,input_plot,'Displaytype','texturemap');
colormap(h2,flipud(brewermap(16,'BrBG')));
hold on 

% add significance as contour lines
sign_pval=month_P<=0.05;
sign_pval = double(sign_pval);
contourm(Lon,Lat,sign_pval,[1 1],'Color',rgb('dark grey'),'LineWidth',1);
hold on 
geoshow(landLat,landLon,'Color','k')

caxis([-0.8 0.8])
title(title_str,'FontSize',14);
mlabel('off')
plabel('off')



end 



    cb2 = colorbar


    cb2.Position = [0.9 0.1 0.017 0.35]; %adjust!
    cb2.Label.String = {'\beta (NA rainfall, OLR anomalies,';'1975-2023)'}; 

    cb2.FontSize=12;


    %% set size of plots 


% geopotential height 200hPa 

set(a,'Position',[0.001 0.735 0.25 0.25]);
set(c,'Position',[0.22 0.735 0.25 0.25]);
set(d,'Position',[0.44 0.735 0.25 0.25]);
set(e,'Position',[0.66 0.735 0.25 0.25]);

set(f,'Position',[0.001 0.49 0.25 0.25]);
set(g,'Position',[0.22 0.49 0.25 0.25]);
set(h_1,'Position',[0.44 0.49 0.25 0.25]);

% OLR
set(a2,'Position',[0.001 0.245 0.25 0.25]);
set(c2,'Position',[0.22 0.245 0.25 0.25]);
set(d2,'Position',[0.44 0.245 0.25 0.25]);
set(e2,'Position',[0.66 0.245 0.25 0.25]);

set(f2,'Position',[0.001 0.001 0.25 0.25]);
set(g2,'Position',[0.22 0.001 0.25 0.25]);
set(h_2,'Position',[0.44 0.001 0.25 0.25]);


%% add labels 

annotation('textbox',[.025 .8 .1 .2],'String','(a)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.25 .8 .1 .2],'String','(b)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.47 .8 .1 .2],'String','(c)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.69 .8 .1 .2],'String','(d)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .55 .1 .2],'String','(e)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.25 .55 .1 .2],'String','(f)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.47 .55 .1 .2],'String','(g)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .3 .1 .2],'String','(h)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.25 .3 .1 .2],'String','(i)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.47 .3 .1 .2],'String','(j)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.69 .3 .1 .2],'String','(k)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.025 .06 .1 .2],'String','(l)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.25 .06 .1 .2],'String','(m)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.47 .06 .1 .2],'String','(n)','FontSize',10,'FontWeight','bold','EdgeColor','none')


%% save figure 
% to make sure that contour lines are also saved in white (and not falsely
% in black)!! 

set(gcf,'InvertHardCopy','off');
set(gcf,'color','w');


print('Fig_3_Regr_NA_rainfall_ght_OLR_middarkgrey','-dtiff','-r300')


