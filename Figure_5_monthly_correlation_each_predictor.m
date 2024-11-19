% script to generate Figure 5 in Heidemann et al. (2024)

% matrix/image plot that shows the correlation between NW/NE Australian
% rainfall and each included predictor, during each month between October and April (in one figure for NE and one figure for NW)



% monthly correlation coefficient between 1) rainfall timeseries over a chosen region in Australia 
% (coded for NE or NW Australia but easy to get other regions as well) 
% and 2) indices that are used as predictors in stepwise linear regression in this research  


% currently works for: 1920-2023; 1940-2023,1957-2023, 1975-2023

% -----------> choose time period and run accordingly! 1975-2023 for Figure
% 5

% also add indication of if a predictor is included in stepwise model or
% not 

% 1) calculate NW and NE Australian rainfall 
% get timeseries for each subperiod 

[rain_NW_1920,rain_NE_1920,~]=NA_rainfall_ts('1920-2023');
[rain_NW_1940,rain_NE_1940,~]=NA_rainfall_ts('1940-2023');
[rain_NW_1957,rain_NE_1957,~]=NA_rainfall_ts('1957-2023');
[rain_NW_1975,rain_NE_1975,~]=NA_rainfall_ts('1975-2023');


% 2) calculate timeseries (reshaped into months) for all possible input predictors


% get SST indices for predictors  --> works for all time periods
 [Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std]=get_SST_indices_func('1975-2023'); 



 % get feedbacks and other indices --> depending on the time periods output
 % varies, choose option here:

    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std]=get_non_oceanic_indices_func('1975-2023'); % from '1920-2023'

 
    [~,~,~,~,...
    ~,evap,TBO]=get_non_oceanic_indices_func('1975-2023'); % from '1940-2023'
 
   
    [~,~,~,~,...
    ~,~,~,AM_SAM]=get_non_oceanic_indices_func('1975-2023'); % from '1957-2023' 


    [MJO_456_std,MJO_567_std,MJO_81_std,MJO_inactive_std]=get_mjo_freq_func; % post 1975 only 




%% correlation for each month, per predictor --> this displays corerlation matrix 
% for all months of the wet season in one figure 


% loops throuh NE or NW Australian rainfall as variable to correlate all
% climate drivers/indices/predictors with 


% variables to correlate with rainfall (additional options possible) --> :
% CP, EP, Nino3.4 lag-1, Timor Sea, Arafura Seas, Coral Sea, DMI, IOBW,
% Ningaloo Nino, NW oceanic evaporation, Soil moisture lag-1, ET lag-1, 
% TBO, AM SAM, 
% MJO phases 8,1, MJO phases 4,5,6



R_matrix =  zeros(17,7);
P_matrix = zeros(17,7);

for region_idx = 1:2 

    if region_idx==1
        region = 'NW';
    else
        region_idx==2
        region = 'NE';
    end 

% loop through all months from October to April
for m_idx=1:7

  

if m_idx == 1
    month=10;
    

elseif m_idx == 2
    month=11;
    

elseif m_idx == 3
    month=12;
    

elseif m_idx== 4
    month=1;
    

elseif m_idx == 5
    month=2;
    

elseif m_idx == 6 
    month=3;
    

else
    m_idx == 7
    month=4;
    


end 

if strcmp('NE',region)
rain_1920_m=rain_NE_1920(month,2:end);
rain_1940_m=rain_NE_1940(month,2:end);
rain_1957_m=rain_NE_1957(month,2:end);
rain_1975_m=rain_NE_1975(month,2:end);

else
    strcmp('NW',region)

rain_1920_m=rain_NW_1920(month,2:end);
rain_1940_m=rain_NW_1940(month,2:end);
rain_1957_m=rain_NW_1957(month,2:end);
rain_1975_m=rain_NW_1975(month,2:end);


end 

CP_m = CP_std(month,2:end);
EP_m = EP_std(month,2:end);
Timor_m = Timor_std(month,2:end);
Arafura_m = Arafura_std(month,2:end);
Coral_m = Coral_std(month,2:end);
DMI_m = DMI_std(month,2:end);
IOBW_m = IOBW_std(month,2:end);
TPI_m = TPI_filt(month,2:end);
Ningaloo_m = Ningaloo_std(month,2:end);
NW_oceanic_evap_m = evap(month,2:end);
MJO_81_m = MJO_81_std(month,2:end);
MJO_456_m = MJO_456_std(month,2:end);

% lagged variables
 if month>=2;
        Nino34_lag_minus1_m = Nino34_std(month-1,2:end);
        if strcmp('NE',region)
        SM_lag_minus1_m=SM_NE_anom_std(month-1,2:end);
        ET_lag_minus1_m=etot_NE_anom_std(month-1,2:end);
        else
        strcmp('NW',region)
        SM_lag_minus1_m=SM_NW_anom_std(month-1,2:end);
        ET_lag_minus1_m=etot_NW_anom_std(month-1,2:end);
        end
else
        month=1;
        Nino34_lag_minus1_m=Nino34_std(12,1:end-1);
    
        if strcmp('NE',region)
        SM_lag_minus1_m=SM_NE_anom_std(12,1:end-1);
        ET_lag_minus1_m=etot_NE_anom_std(12,1:end-1);
        else
        strcmp('NW',region)
        SM_lag_minus1_m=SM_NW_anom_std(12,1:end-1);
        ET_lag_minus1_m=etot_NW_anom_std(12,1:end-1);
        end
    
end 



 if month==9 || month==10 || month==11 || month==12
    TBO_m = TBO(2:end);
 else
    TBO_m = TBO(1:end-1); 
 end 


 if month>=6
    SAM_m = AM_SAM(2:end); 
 else
        month<=5;
    SAM_m = AM_SAM(1:end-1);
 end 



% save all R values in matrix --> and record the order of predictors for
% the figure later! 
for i = 1:17
    
    if i == 1 
    monthly_predictor = CP_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==2
    monthly_predictor = EP_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==3
    monthly_predictor = Nino34_lag_minus1_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==4
    monthly_predictor = Timor_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==5
    monthly_predictor = Arafura_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
     elseif i==6
    monthly_predictor = Coral_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==7
    monthly_predictor = DMI_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
     elseif i==8
    monthly_predictor = IOBW_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==9
    monthly_predictor = TPI_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
     elseif i==10
    monthly_predictor = Ningaloo_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==11
    monthly_predictor = NW_oceanic_evap_m;
%     rain_m=rain_1940_m;
    rain_m=rain_1975_m;
     elseif i==12
    monthly_predictor = SM_lag_minus1_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
    elseif i==13
    monthly_predictor = ET_lag_minus1_m;
%     rain_m=rain_1920_m;
    rain_m=rain_1975_m;
     elseif i==14
    monthly_predictor = TBO_m;
%     rain_m=rain_1940_m;
    rain_m=rain_1975_m;
    elseif i==15
    monthly_predictor = SAM_m;
%     rain_m=rain_1957_m;
    rain_m=rain_1975_m;
     elseif i==16
    monthly_predictor = MJO_81_m;
    rain_m=rain_1975_m;
    else
        i==17
    monthly_predictor = MJO_456_m;
    rain_m=rain_1975_m;
    end 


    [R,pval]=corrcoef(rain_m,monthly_predictor);
    R_matrix(i,m_idx) = R(1,2);
    P_matrix(i,m_idx) = pval(1,2);

    monthly_predictor=[];

end 



end 

    if strcmp('NW',region)
        R_matrix_NW = R_matrix;
        P_matrix_NW = P_matrix;
    else
        strcmp('NE',region)
        R_matrix_NE = R_matrix;
        P_matrix_NE = P_matrix;
    end 

end 


%% 


figure('pos',[10 10 1200 600])


for i = 1:2


if i==1
    a  = subplot(2,2,i);
    imagesc(R_matrix_NW)
    title('R (NW Australian rainfall, predictor)'); 
    P_disp = P_matrix_NW;
else
    i==2
    b = subplot(2,2,i);
    imagesc(R_matrix_NE)
    title('R (NE Australian rainfall, predictor)'); 
    P_disp = P_matrix_NE;
end 

clim([-0.8 0.8])
colormap(flipud(brewermap(16,'RdBu')));


yticks(0:1:17)
ylim([0.5 17.5])
yticklabels({'','CP Index','EP Index','Nino 3.4 lag-1','Timor Sea','Arafura Seas','Coral Sea',...
    'DMI','IOBW','TPI lowpass filtered','Ningaloo Nino','NW oceanic evaporation','Soil moisture lag-1','ET lag-1',...
    'TBO','AM SAM','MJO phases 8,1','MJO phases 4,5,6'})


xticklabels({'Oct','Nov','Dec','Jan','Feb','Mar','Apr'})

% add significance (dots over panel)   
hold on 


for col = 1:7
    for row = 1:17

    if P_disp(row,col)<=0.05 % set p value for display of significance here 
    plot(col,row,'marker','.','MarkerSize',10,'Color','black')
    else
        continue 
    end 

    end 
end 

if i==1
    ylabel('Predictor','FontSize',12)
    
else
    i==2
    cb=colorbar

    cb.FontSize=12;
    cb.Label.FontSize=14;  
end 


xlabel('Month','FontSize',12)

% only for 1975-2022:
% now add manually which ones are included in the model in each month,
% based on process knowledge 

if i==1 % NW --> col - months, row - Index
    plot(1:3,1,'marker','o','MarkerSize',12,'Color','black') % 1= CP
    plot(5:6,1,'marker','o','MarkerSize',12,'Color','black')
    
    plot(1:3,2,'marker','o','MarkerSize',12,'Color','black') % EP
    plot(5:7,2,'marker','o','MarkerSize',12,'Color','black')

    plot(1:7,3,'marker','o','MarkerSize',12,'Color','black') % Nino 3.4 lag-1

    plot(1:2,4,'marker','o','MarkerSize',12,'Color','black') % Timor Sea
    plot(1:2,5,'marker','o','MarkerSize',12,'Color','black') % Arafura Sea
    plot(1:2,6,'marker','o','MarkerSize',12,'Color','black') % Coral Sea

    plot(1:2,7,'marker','o','MarkerSize',12,'Color','black') % DMI

    plot(3,8,'marker','o','MarkerSize',12,'Color','black') % IOBW
    plot(5:6,8,'marker','o','MarkerSize',12,'Color','black') % IOBW

    plot(1:7,9,'marker','o','MarkerSize',12,'Color','black') % TPI

    plot(3:5,10,'marker','o','MarkerSize',12,'Color','black') % Ningaloo

    plot(1:7,11,'marker','o','MarkerSize',12,'Color','black') % NW evap
   
    plot(1:4,12,'marker','o','MarkerSize',12,'Color','black') % Soil moisture lag-1
    plot(6:7,12,'marker','o','MarkerSize',12,'Color','black') % Soil moisture lag-1

    plot(1:4,13,'marker','o','MarkerSize',12,'Color','black') % ET lag-1
    plot(6:7,13,'marker','o','MarkerSize',12,'Color','black') % ET lag-1

    plot(3:5,14,'marker','o','MarkerSize',12,'Color','black') %TBO

    plot(4:5,15,'marker','o','MarkerSize',12,'Color','black') %AM SAM

    plot(1:7,16,'marker','o','MarkerSize',12,'Color','black') %MJO 8,1
    plot(1:7,17,'marker','o','MarkerSize',12,'Color','black') %MJO 4,5,6

else
    i==2 % NE
    plot(1:3,1,'marker','o','MarkerSize',12,'Color','black') % 1= CP
    plot(5:7,1,'marker','o','MarkerSize',12,'Color','black')
    
    plot(1:3,2,'marker','o','MarkerSize',12,'Color','black') % EP
    plot(5:7,2,'marker','o','MarkerSize',12,'Color','black')
    
    plot(1:7,3,'marker','o','MarkerSize',12,'Color','black') % Nino 3.4 lag-1
    
    plot(1:2,4,'marker','o','MarkerSize',12,'Color','black') % Timor Sea
    plot(1:2,5,'marker','o','MarkerSize',12,'Color','black') % Arafura Sea
   

    plot(1:3,6,'marker','o','MarkerSize',12,'Color','black')% Coral Sea
    plot(1:2,7,'marker','o','MarkerSize',12,'Color','black') % DMI

    plot(3,8,'marker','o','MarkerSize',12,'Color','black') % IOBW
    plot(5:6,8,'marker','o','MarkerSize',12,'Color','black') % IOBW

    plot(1:7,9,'marker','o','MarkerSize',12,'Color','black') % TPI

    plot(3:5,10,'marker','o','MarkerSize',12,'Color','black') % Ningaloo

    plot(1:7,11,'marker','o','MarkerSize',12,'Color','black') % NW evap
   
    plot(1:4,12,'marker','o','MarkerSize',12,'Color','black') % Soil moisture lag-1
    plot(6:7,12,'marker','o','MarkerSize',12,'Color','black') % Soil moisture lag-1

    plot(1:4,13,'marker','o','MarkerSize',12,'Color','black') % ET lag-1
    plot(6:7,13,'marker','o','MarkerSize',12,'Color','black') % ET lag-1

    plot(3:5,14,'marker','o','MarkerSize',12,'Color','black') %TBO

    plot(4:5,15,'marker','o','MarkerSize',12,'Color','black') %AM SAM

    plot(1:7,16,'marker','o','MarkerSize',12,'Color','black') %MJO 8,1
    plot(1:7,17,'marker','o','MarkerSize',12,'Color','black') %MJO 4,5,6


end

end 


% title for the whole figure 
sgtitle('Monthly correlation coefficient (Oct - Apr), 1975-2023','FontSize',16,'FontWeight','bold')

% set position and size of graphs 
set(a,'Position',[0.13 0.2 0.33 0.65]);
set(b,'Position',[0.59 0.2 0.33 0.65]);

% add a,b labels
annotation('textbox',[.12 .71 .1 .2],'String','(a)','FontSize',14,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.58 .71 .1 .2],'String','(b)','FontSize',14,'FontWeight','bold','EdgeColor','none')


% now add manually which ones are included in the model in each month 


% save figure 
% to make sure that contour lines are also saved in white (and not falsele
% in black)!! 
set(gcf,'InvertHardCopy','off');
set(gcf,'color','w');

% if strcmp('R_squared',display_option)
%     filename = ['R_squ_matrix_' region '_' predictor_choice]
% elseif strcmp('R',display_option)
%     filename = ['R_matrix_' region '_' predictor_choice]
% end 



print('R_monthly_summary_1975_2023_Oct_Apr_marked','-dtiff','-r300')

