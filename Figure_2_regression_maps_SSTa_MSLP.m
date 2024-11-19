% plot figure 2 for paper: global maps with northern Australian rainfall
% regressed onto SSTa and MSLP/850hPa winds 

% data for SSTa regression generated and saved in :
% Global_SSTa_rain_regression_Oct_Apr.m --> Slope_NA_rain_SSTa.mat

% data for MSLP and low level winds generated and saved in: 
% Global_MSLP_wind_rain_regression_Oct_Apr.m --> 'Slope_NA_rain_MSLP_wnd.mat'

load 'Slope_NA_rain_SSTa.mat'


% plot 

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

input_plot = slope_matrix_SST_all(:,:,m);



h = worldmap('World');
setm(h,'Origin',[0 180 0]);
getm(h,'MapProjection');
setm(h,'MlabelParallel','south');
geoshow(Lon,Lat,input_plot,'Displaytype','texturemap');
colormap(h,flipud(brewermap(16,'RdBu')));
hold on 

% add significance as contour lines
sign_pval=month_P<=0.05;
sign_pval = double(sign_pval);
contourm(Lon,Lat,sign_pval,[1 1],'Color',[.56 .56 .56],'LineWidth',1);
hold on 
geoshow(landLat,landLon,'Color',rgb('black'))

caxis([-0.8 0.8])
title(title_str,'FontSize',14);
mlabel('off')
plabel('off')


 end


    cb = colorbar

    cb.Position = [0.9 0.6 0.017 0.34]; 

    % adjust label depending on the variable
    cb.Label.String = '\beta (NA rainfall, SSTa, 1920-2023)'; 

    cb.FontSize=12;
 
   
%% next plot MSLP and low level winds 850hPa 

load 'Slope_NA_rain_MSLP_wnd.mat'

% plot 
lon1=lon;
lon1(361)=(lon1(360)-lon1(359))+lon1(360);
[Lon1,Lat1] = meshgrid(lat,lon1);

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
month_P(361,:)=month_P(360,:); 

month_P_uwnd = month_P_uwnd_all(:,:,m);
month_P_uwnd(361,:)=month_P_uwnd(360,:);  

month_P_vwnd = month_P_vwnd_all(:,:,m);
month_P_vwnd(361,:)=month_P_vwnd(360,:);  

input_plot = slope_matrix_mslp_all(:,:,m);
input_plot(361,:)=input_plot(360,:);



bound_lon=[60 -70];
bound_lat=[-50 50];

h2 = worldmap('World');

setm(h2,'Origin',[0 180 0]);
getm(h2,'MapProjection');
setm(h2,'MlabelParallel','south');
geoshow(Lon1,Lat1,input_plot,'Displaytype','texturemap');
colormap(h2,flipud(brewermap(16,'PiYG')));
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

    hold on 

input_plot_uwnd = slope_matrix_uwnd_all(:,:,m);
input_plot_uwnd(361,:)=input_plot_uwnd(360,:);
input_plot_vwnd = slope_matrix_vwnd_all(:,:,m);
input_plot_vwnd(361,:)=input_plot_vwnd(360,:);
          
% plot only significant vectors 

    sign_pval_uwnd=month_P_uwnd<=0.05;
    sign_pva_uwnd = double(sign_pval_uwnd);
    sign_pval_vwnd=month_P_vwnd<=0.05;
    sign_pva_vwnd = double(sign_pval_vwnd);

      significance_matrix_u_v_wnd =or(sign_pva_uwnd,sign_pva_vwnd); 
      input_plot_uwnd_sign=zeros(size(significance_matrix_u_v_wnd,1),size(significance_matrix_u_v_wnd,2));
      input_plot_vwnd_sign=zeros(size(significance_matrix_u_v_wnd,1),size(significance_matrix_u_v_wnd,2));
      
  for i_lon = 1:size(significance_matrix_u_v_wnd,1);
      for j_lat = 1:size(significance_matrix_u_v_wnd,2);
        if significance_matrix_u_v_wnd(i_lon,j_lat)==1;
            input_plot_uwnd_sign(i_lon,j_lat) = input_plot_uwnd(i_lon,j_lat);
            input_plot_vwnd_sign(i_lon,j_lat) = input_plot_vwnd(i_lon,j_lat);
        else
            significance_matrix_u_v_wnd(i_lon,j_lat)=0;
            input_plot_uwnd_sign(i_lon,j_lat) = 0;
            input_plot_vwnd_sign(i_lon,j_lat) = 0;
            
        end 
      end
  end 
    

  hold on 

% set here what the northern boundary is 
n_boundary = 90;
n_bd=find(lat==n_boundary);
input_plot_vwnd_sign(:,n_bd:end)=0;
input_plot_uwnd_sign(:,n_bd:end)=0; 

  quivermc(Lon1,Lat1,input_plot_uwnd_sign,input_plot_vwnd_sign,'reftype','median','density',11,'Color',rgb('dark grey'))


 end

 cb2 = colorbar


    cb2.Position = [0.9 0.1 0.017 0.35]; %adjust!
    % adjust label depending on the variable! 
    cb2.Label.String = {'\beta (NA rainfall, MSLP, 850hPa wind anomalies,';'1920-2015)'}; 

    cb2.FontSize=12;


%% set size of plots 

% SSTa
set(a,'Position',[0.001 0.735 0.25 0.25]);
set(c,'Position',[0.22 0.735 0.25 0.25]);
set(d,'Position',[0.44 0.735 0.25 0.25]);
set(e,'Position',[0.66 0.735 0.25 0.25]);

set(f,'Position',[0.001 0.49 0.25 0.25]);
set(g,'Position',[0.22 0.49 0.25 0.25]);
set(h_1,'Position',[0.44 0.49 0.25 0.25]);

% MSLP
set(a2,'Position',[0.001 0.245 0.25 0.25]);
set(c2,'Position',[0.22 0.245 0.25 0.25]);
set(d2,'Position',[0.44 0.245 0.25 0.25]);
set(e2,'Position',[0.66 0.245 0.25 0.25]);

set(f2,'Position',[0.001 0.001 0.25 0.25]);
set(g2,'Position',[0.22 0.001 0.25 0.25]);
set(h_2,'Position',[0.44 0.001 0.25 0.25]);


%% add labels 

annotation('textbox',[.025 .79 .1 .2],'String','(a)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.25 .79 .1 .2],'String','(b)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.47 .79 .1 .2],'String','(c)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.69 .79 .1 .2],'String','(d)','FontSize',10,'FontWeight','bold','EdgeColor','none')

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


print('Fig_1_Regr_NA_rainfall_SSTa_MSLP','-dtiff','-r300')



