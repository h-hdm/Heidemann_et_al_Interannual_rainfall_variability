% Figure 6 in Heidemann et al. (2025)

% Correlation matrix with correlations between predictors used in stepwise linear
% regression analysis --> for each month of the wet season, from October to
% April 

% Time period shown is 1975-2023 

% Calculate timeseries (reshaped into months) for all possible predictors

time_period = '1975-2023';

% 1)) get SST indices for predictors  

 [Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std]=get_SST_indices_func(time_period); 

 % 2) get feedbacks and other non-SST based indices 

    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM]=get_non_oceanic_indices_func(time_period);
    
 
% 3) get MJO 

[MJO_456_std,MJO_567_std,MJO_81_std,MJO_inactive_std]=get_mjo_freq_func;
    num_predictors = 19;





%% Generate figure with one subplot for each month (October to April) 

figure('pos',[10 10 1000 700])


R_matrix =  zeros(19,19,7);
P_matrix = zeros(19,19,7);

for m_idx=1:7



if m_idx == 1
    month=10;
    a=subplot(3,3,m_idx);

elseif m_idx == 2 
    month=11;
    b=subplot(3,3,m_idx);

elseif m_idx == 3
    month=12;
    c=subplot(3,3,m_idx);

elseif m_idx== 4
    month=1;
    d=subplot(3,3,m_idx);

elseif m_idx == 5
    month=2;
    e=subplot(3,3,m_idx);

elseif m_idx == 6 
    month=3;
    f=subplot(3,3,m_idx);

else
    m_idx == 7
    month=4;
    g=subplot(3,3,m_idx);

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


% lagged variables
 if month>=2;
        Nino34_lag_minus1_m = Nino34_std(month-1,2:end);
        
        SM_lag_minus1_m_NE=SM_NE_anom_std(month-1,2:end);
        ET_lag_minus1_m_NE=etot_NE_anom_std(month-1,2:end);
        
        SM_lag_minus1_m_NW=SM_NW_anom_std(month-1,2:end);
        ET_lag_minus1_m_NW=etot_NW_anom_std(month-1,2:end);
        
else
        month=1;
        Nino34_lag_minus1_m=Nino34_std(12,1:end-1);
    
        SM_lag_minus1_m_NE=SM_NE_anom_std(12,1:end-1);
        ET_lag_minus1_m_NE=etot_NE_anom_std(12,1:end-1);
        
        SM_lag_minus1_m_NW=SM_NW_anom_std(12,1:end-1);
        ET_lag_minus1_m_NW=etot_NW_anom_std(12,1:end-1);
    
 end 




     NW_oceanic_evap_m = evap(month,2:end);
    
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



    MJO_81_m = MJO_81_std(month,2:end);
    MJO_456_m = MJO_456_std(month,2:end);





 % now loop through all predictors and correlate them with each other
for i = 1:num_predictors
    
    if i == 1 
    monthly_predictor_1 = CP_m;
    elseif i==2
    monthly_predictor_1 = EP_m;
    elseif i==3
    monthly_predictor_1 = Nino34_lag_minus1_m;
    elseif i==4
    monthly_predictor_1 = Timor_m;
    elseif i==5
    monthly_predictor_1 = Arafura_m;
     elseif i==6
    monthly_predictor_1 = Coral_m;
    elseif i==7
    monthly_predictor_1 = DMI_m;
     elseif i==8
    monthly_predictor_1 = IOBW_m;
    elseif i==9
    monthly_predictor_1 = TPI_m;
     elseif i==10
    monthly_predictor_1 = Ningaloo_m;
    elseif i==11
    monthly_predictor_1 = SM_lag_minus1_m_NE;
    elseif i==12
    monthly_predictor_1 = SM_lag_minus1_m_NW;
    elseif i==13
    monthly_predictor_1 = ET_lag_minus1_m_NE;
    elseif i==14
    monthly_predictor_1 = ET_lag_minus1_m_NW;
    elseif i==15
    monthly_predictor_1 = NW_oceanic_evap_m;
    elseif i==16
    monthly_predictor_1 = TBO_m;
    elseif i==17
    monthly_predictor_1 = SAM_m;
     elseif i==18
    monthly_predictor_1 = MJO_81_m;
    else
        i==19
    monthly_predictor_1 = MJO_456_m;
    end 


        for j = 1:num_predictors
    
        if j == 1 
        monthly_predictor_2 = CP_m;
        elseif j==2
        monthly_predictor_2 = EP_m;
        elseif j==3
        monthly_predictor_2 = Nino34_lag_minus1_m;
        elseif j==4
        monthly_predictor_2 = Timor_m;
        elseif j==5
        monthly_predictor_2 = Arafura_m;
         elseif j==6
        monthly_predictor_2 = Coral_m;
        elseif j==7
        monthly_predictor_2 = DMI_m;
         elseif j==8
        monthly_predictor_2 = IOBW_m;
        elseif j==9
        monthly_predictor_2 = TPI_m;
         elseif j==10
        monthly_predictor_2 = Ningaloo_m;
        elseif j==11
        monthly_predictor_2 = SM_lag_minus1_m_NE;
        elseif j==12
        monthly_predictor_2 = SM_lag_minus1_m_NW;
        elseif j==13
        monthly_predictor_2 = ET_lag_minus1_m_NE;
        elseif j==14
        monthly_predictor_2 = ET_lag_minus1_m_NW;
        elseif j==15
        monthly_predictor_2 = NW_oceanic_evap_m;
         elseif j==16
        monthly_predictor_2 = TBO_m;
        elseif j==17
        monthly_predictor_2 = SAM_m;
        elseif j==18
        monthly_predictor_2 = MJO_81_m;
        else
            j==19
        monthly_predictor_2 = MJO_456_m;
        end 


        [R,pval]=corrcoef(monthly_predictor_2,monthly_predictor_1);
        R_matrix(i,j,m_idx) = R(1,2);
        P_matrix(i,j,m_idx) = pval(1,2);



        end 



end 


% then plot 
if month == 1
    month_name = 'January';
elseif month == 2
    month_name = 'February';
elseif month == 3 
    month_name = 'March';
elseif month == 4
    month_name = 'April';
elseif month == 5 
    month_name = 'May';
elseif month == 6
    month_name = 'June';
elseif month == 7 
    month_name = 'July';
elseif month == 8
    month_name = 'August';
elseif month == 9
    month_name = 'September';
elseif month == 10
    month_name = 'October';
elseif month == 11
    month_name = 'November';
else
    month == 12
    month_name = 'December';

end 

% Delete one half of the matrix, as its just duplicated the same values
% also get rid of all 1s, that indicate one predictor correlated with
% itself 

for j = 1:num_predictors
    for i = 1+j-1:num_predictors

    R_matrix(j,i,m_idx) = NaN;
    P_matrix(j,i,m_idx) = NaN;

    end 
end 


hdl = imagesc(R_matrix(:,:,m_idx))
clim([-0.8 0.8])
colormap(flipud(brewermap(16,'RdBu')));

set(hdl, 'AlphaData', ~isnan(R_matrix(:,:,m_idx)))

num_predictors_plus05 = num_predictors+0.5;
yticks(0:1:num_predictors)
ylim([0.5 num_predictors_plus05])
xticks(0:1:num_predictors)
xlim([0.5 num_predictors_plus05])
ax=gca;


if m_idx == 1 || m_idx == 4 || m_idx == 7


yticklabels({'','CP Index','EP Index','Nino 3.4 lag-1','Timor Sea','Arafura Seas','Coral Sea',...
    'DMI','IOBW','TPI lowpass filtered','Ningaloo Nino','Soil moisture lag-1 NE',...
    'Soil moisture lag-1 NW','ET lag-1 NE','ET lag-1 NW',...
    'NW oceanic evaporation','TBO','AM SAM','MJO phases 8,1','MJO phases 4,5,6'})



ax.YAxis.FontSize = 7;
else
    yticklabels([]);
end 


if m_idx == 5 || m_idx == 6 || m_idx == 7


xticklabels({'','CP Index','EP Index','Nino 3.4 lag-1','Timor Sea','Arafura Seas','Coral Sea',...
    'DMI','IOBW','TPI lowpass filtered','Ningaloo Nino','Soil moisture lag-1 NE',...
    'Soil moisture lag-1 NW','ET lag-1 NE','ET lag-1 NW',...
    'NW oceanic evaporation','TBO','AM SAM','MJO phases 8,1','MJO phases 4,5,6'})


xtickangle(45)
ax.XAxis.FontSize = 7;
else
    xticklabels([]);

end 


title(month_name)

hold on 


for col = 1:num_predictors
    for row = 1:num_predictors

    if P_matrix(row,col,m_idx)<=0.05 
    plot(col,row,'marker','.','MarkerSize',9,'Color','black')
    else
        continue 
    end 

    end 
end



end



    cb=colorbar
    cb.Position = [0.88 0.29 0.017 0.45]; 
    cb.Label.String = 'r';  
    cb.FontSize=12;
    cb.Label.FontSize=12;  


sgtitle(['Monthly correlation coefficient (Oct - Apr), ' time_period],'FontSize',14,'FontWeight','bold')



%% adjust plot sizes

set(a,'Position',[0.17 0.67 0.2 0.23]);
set(b,'Position',[0.415 0.67 0.2 0.23]);
set(c,'Position',[0.66 0.67 0.2 0.23]);

set(d,'Position',[0.17 0.4 0.2 0.23]);
set(e,'Position',[0.415 0.4 0.2 0.23]);
set(f,'Position',[0.66 0.4 0.2 0.23]);

set(g,'Position',[0.17 0.13 0.2 0.23]);



%% add labels 

annotation('textbox',[.16 .735 .1 .2],'String','(a)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.405 .735 .1 .2],'String','(b)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.65 .735 .1 .2],'String','(c)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.16 .465 .1 .2],'String','(d)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.405 .465 .1 .2],'String','(e)','FontSize',10,'FontWeight','bold','EdgeColor','none')
annotation('textbox',[.65 .465 .1 .2],'String','(f)','FontSize',10,'FontWeight','bold','EdgeColor','none')

annotation('textbox',[.16 .195 .1 .2],'String','(g)','FontSize',10,'FontWeight','bold','EdgeColor','none')


%% save 
set(gcf,'InvertHardCopy','off');
set(gcf,'color','w');

fname_str = ['R_monthly_predictors_' time_period]
print(fname_str,'-dtiff','-r300')

