% Figure 1 in Heidemann et al. (2025)

% Schematic showing regions used for indices 

% Load latitude and longitude data for Australia 
load('AWAP_rainfall_1900_2023', 'lat', 'lon');

% Define masks for Northwest and Northeast Australia
NE_mask = NaN(886, 691);
NE_mask(461:886, 491:691) = 1;

NW_mask = NaN(886, 691);
NW_mask(1:460, 491:691) = 1;

[Lat, Lon] = meshgrid(lat, lon);

%% Load shapefiles

ocean_file = 'ne_10m_ocean.shp'; 
O = shaperead(ocean_file, 'UseGeoCoords', true);
oceanLat = extractfield(O, 'Lat');
oceanLon = extractfield(O, 'Lon');

land_file = 'ne_50m_land.shp';
L = shaperead(land_file, 'UseGeoCoords', true);
landLat = extractfield(L, 'Lat');
landLon = extractfield(L, 'Lon');

%% Plot schematic

figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
h = worldmap([-50 50], [30 -50]);
setm(h, 'MapProjection', 'mercator', 'Origin', [0 150 0], 'MlabelParallel', 'south');

hold on;
geoimg = geoshow(Lat, Lon, NW_mask, 'FaceColor', 'red');
alpha(geoimg, double(~isnan(NW_mask)));
[oceanLat, oceanLon] = maptriml(oceanLat, oceanLon, [-44 -10], [112 154]);

hold on;
geoshow(oceanLat, oceanLon, 'DisplayType', 'polygon', 'FaceColor', 'white');
geoimg = geoshow(Lat, Lon, NE_mask, 'FaceColor', [.55 0 0]);
alpha(geoimg, double(~isnan(NE_mask)));
hold on 
geoshow(oceanLat, oceanLon,'DisplayType','polygon','FaceColor','white');

hold on;
geoshow(landLat, landLon, 'Color', rgb('grey'));

% Adjust map settings
mlabel('off');
plabel('off');
setm(gca, 'FLineWidth', 1);
set(gcf, 'InvertHardCopy', 'off', 'Color', 'w');
set(h, 'Position', [0.001 0.0001 1 0.9]);

%% Define colors for indices

CP_color = [0 .75 1];        % CP Index
Coral_color = [0 .96 1];     % Coral Sea  
Arafura_color = [0 .77 .8];  % Arafura and Gulf 
IOBW_color = [.54 .17 .89];  % IOBW
NW_evap_color = [1 .84 0];   % NW evaporation 

%% Add index boxes

define_box([-5 -18 -18 -18 -5 -5], [105 105 105 135 135 105], NW_evap_color);
define_box([-5 -25 -25 -25 -5 -5], [145 145 145 165 165 145], Coral_color);
define_box([-5 -20 -20 -20 -5 -5], [130 130 130 145 145 130], Arafura_color);
define_box([5 -5 -5 -5 5 5], [-150 -150 -150 -90 -90 -150], CP_color);
define_box([5 -5 -5 -5 5 5], [160 160 160 -150 -150 160], CP_color);
define_box([25 -27 -27 -27 25 25], [35 35 35 120 120 35], IOBW_color);

%% Create custom legend

legend_colors = {IOBW_color, NW_evap_color, Arafura_color, Coral_color, CP_color, 'red', [.55 0 0]};
legend_labels = {'1) IOBW', '2) NW oceanic evaporation', '3) Arafura Sea', '4) Coral Sea', '5) Niño 3 & 4', 'Northwest Australia', 'Northeast Australia'};
h = arrayfun(@(i) plot(NaN, NaN, 'o', 'Color', legend_colors{i}, 'MarkerFaceColor', legend_colors{i}), 1:length(legend_colors));
legend(h, legend_labels, 'FontSize', 9, 'Location', [0.7, 0.16, 0.15, 0.2]);

%% Add labels to boxes

add_annotation([.18 .4 .1 .2], '1)');
add_annotation([.375 .23 .1 .2], '2)');
add_annotation([.466 .23 .1 .2], '3)');
add_annotation([.52 .23 .1 .2], '4)');
add_annotation([.53 .28 .1 .2], '5)');

%% save figure 

  print('Fig_1_Index_schematic_upd','-dtiff','-r300')


%% Functions

function define_box(lat_box, lon_box, color)
    linem(lat_box, lon_box, 'LineWidth', 1.5, 'Color', color);
end

function add_annotation(position, text)
    annotation('textbox', position, 'String', text, 'FontSize', 11, 'EdgeColor', 'none');
end



