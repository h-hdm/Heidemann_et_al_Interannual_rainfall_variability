% make a schematic showing regions used for Indices 

% load some raindom lats and lons for plotting Australia and marking
% northwest and northeast Australia
load ('AWAP_rainfall_1900_2023','lat','lon')


NE_mask=NaN(886,691);
NE_mask(461:886,491:691)=1;

NW_mask=NaN(886,691);
NW_mask(1:460,491:691)=1;

%% Plot schematic of most important indices, mark northwest and northeast Australia 

    ocean_file = 'ne_10m_ocean.shp'; 
    O = shaperead(ocean_file,'UseGeoCoords',true);
    oceanLat = extractfield(O,'Lat');
    oceanLon = extractfield(O,'Lon');


land_file = 'ne_50m_land.shp';
L = shaperead(land_file,'UseGeoCoords',true);
landLat = extractfield(L,'Lat');
landLon = extractfield(L,'Lon');

figure('Renderer','painters','Position',[10 10 1000 500])
h = worldmap([-50 50],[30 -50]);

setm(h,'MapProjection','mercator');
setm(h,'Origin',[0 150 0]);
getm(h,'MapProjection');
setm(h,'MlabelParallel','south');


    hold on 
    geoimg = geoshow(Lat,Lon,NW_mask,'FaceColor','red') 

    alpha(geoimg,double(~isnan(NW_mask))) % Change transparency to matrix where if data==NaN --> transparency = 1, else 0.
    [oceanLat,oceanLon] = maptriml(oceanLat,oceanLon,[-44 -10],[112 154]);
    hold on 
    geoshow(oceanLat, oceanLon,'DisplayType','polygon','FaceColor','white');

    hold on 
    geoimg = geoshow(Lat,Lon,NE_mask,'FaceColor',[.55 0 0])

     alpha(geoimg,double(~isnan(NE_mask))) % Change transparency to matrix where if data==NaN --> transparency = 1, else 0.
    [oceanLat,oceanLon] = maptriml(oceanLat,oceanLon,[-44 -10],[112 154]);
    hold on 
    geoshow(oceanLat, oceanLon,'DisplayType','polygon','FaceColor','white');


    hold on 
    geoshow(landLat,landLon,'Color',rgb('grey'))


    mlabel('off')
    plabel('off')
    getm(gca,'FLineWidth')
    setm(gca,'FLineWidth',1)

    set(gcf,'InvertHardCopy','off');
    set(gcf,'color','w');


set(h,'Position',[0.001 0.0001 1 0.9]);


% now start adding boxes 
CP_color = [0 .75 1]; % CP Index
Coral_color = [0 .96 1]; % Coral Sea  
Arafura_color = [0 .77 .8];  % Arafura and Gulf 
IOBW_color = [.54 .17 .89]; % IOBW
NW_evap_color = [1 .84 0]; % NW evap 

%   add evap boxe
    lat_box = [-5;-18;-18;-18;-5;-5;];
    lon_box = [105;105;105;135;135;105;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',NW_evap_color);

    % SST boxes 
    lat_box = [-5;-25;-25;-25;-5;-5;];
    lon_box = [145;145;145;165;165;145;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',Coral_color);    

    lat_box = [-5;-20;-20;-20;-5;-5;];
    lon_box = [130;130;130;145;145;130;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',Arafura_color);

    lat_box = [5;-5;-5;-5;5;5;];
    lon_box = [-150;-150;-150;-90;-90;-150;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',CP_color);
    lat_box = [5;-5;-5;-5;5;5;];
    lon_box = [160;160;160;-150;-150;160;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',CP_color);

    lat_box = [25;-27;-27;-27;25;25;];
    lon_box = [35;35;35;120;120;35;];
    linem(lat_box, lon_box,'LineWidth',1.5,'Color',IOBW_color);
    
    % create custom legend 
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN,'or','Color',[IOBW_color]);
    set(h(1),'markerfacecolor',get(h(1),'color'));
    h(2) = plot(NaN,NaN,'or','Color',[NW_evap_color]);
    set(h(2),'markerfacecolor',get(h(2),'color'));
    h(3) = plot(NaN,NaN,'or','Color',[Arafura_color]);
    set(h(3),'markerfacecolor',get(h(3),'color'));
    h(4) = plot(NaN,NaN,'or','Color',[Coral_color]);
    set(h(4),'markerfacecolor',get(h(4),'color'));
    h(5) = plot(NaN,NaN,'or','Color',[CP_color]);
    set(h(5),'markerfacecolor',get(h(5),'color'));
    h(6) = plot(NaN,NaN,'or','Color','red');
    set(h(6),'markerfacecolor',get(h(6),'color'));
    h(7) = plot(NaN,NaN,'or','Color',[.55 0 0]);
    set(h(7),'markerfacecolor',get(h(7),'color'));

     lgd = legend(h,'1) IOBW','2) NW oceanic evaporation','3) Arafura Sea','4) Coral Sea','5) CP',...
        'Northwest Australia','Northeast Australia','FontSize',9,'Location',[0.7,0.16,0.15, 0.2])


     % add labels to boxes
    annotation('textbox',[.18 .4 .1 .2],'String','1)','FontSize',11,'EdgeColor','none')
    annotation('textbox',[.375 .23 .1 .2],'String','2)','FontSize',11,'EdgeColor','none')
    
    annotation('textbox',[.466 .23 .1 .2],'String','3)','FontSize',11,'EdgeColor','none')
    annotation('textbox',[.52 .23 .1 .2],'String','4)','FontSize',11,'EdgeColor','none')     
    
    annotation('textbox',[.53 .28 .1 .2],'String','5)','FontSize',11,'EdgeColor','none')


%%
  print('Fig_1_Index_schematic','-dtiff','-r300')
