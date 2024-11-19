% Stepwise linear regression using build-in Matlab function, as well as
% manual calculation to have ability to manually influence the order of
% input predictors and extract the explained variance individually for each
% key predictor 

% this is to calculate timeseries of SST Indices, terrerstrial, atmospheric
% and feedback indices that influence rainfall, as well as a timeseries of
% northwestern and northeastern Australian rainfall

% use these as predictors and response variables in Stepwise linear
% regression next: 
% 1) run built-in Matlab function and find the key
% predictors and the order in which to add to the model 
% 2) run manual
% calculation of stepwise linear regression, adding the respective found
% predictors and finding the r squared value for each single predictor 
% (not possible to extract from built-in Matlab function), as
% well as the total explained variance by all predictors 
% numbers are then to be used as input for a stacked bar graph, that
% explains how the explained variance and the predictors vary throughout
% the months of the year 
% manual option gives ability to include proces knowledge about
% relationships between predictors, uncertainty about relationships etc. 

% first set time period to analyse 
time_period = '1959-2023'
% currently works for: 1920-2023; 1940-2023,1957-2023, 1975-2023
% currently setting up to also work for 1959-2023

% 1) calculate NW and NE Australian rainfall to be used as predictand/response
% variable in stepwise lineare regression 
[rain_NW,rain_NE,~]=NA_rainfall_ts(time_period);

% calculate timeseries (reshaped into months) for all possible predictors
% to be included in the stepwise linear model 

% 2) get SST indices for predictors  --> works for all time periods
 [Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std]=get_SST_indices_func(time_period);

 % 3) get feedbacks and other indices --> depending on the time periods output
 % varies
 if strcmp('1920-2023',time_period) ;
    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std]=get_non_oceanic_indices_func(time_period);

 elseif strcmp('1940-2023',time_period); 
    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO]=get_non_oceanic_indices_func(time_period); 

 elseif strcmp('1959-2023',time_period); 
    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM,MSE]=get_non_oceanic_indices_func(time_period); 


 else 
     strcmp('1957-2023',time_period) || strcmp('1975-2023',time_period);
    [yearly_T,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM]=get_non_oceanic_indices_func(time_period);

 end 


% 4) get MJO (only when analysing 1975 to 2023)
if strcmp('1975-2023',time_period) 
[MJO_456_std,MJO_567_std,MJO_81_std,MJO_inactive_std]=get_mjo_freq_func;
else

end 

%% set which month to analyse and run built-in function for stepwise linear 
% regression 

% choose month - all months possible 
month=4

% set region to analyse (response variable) --> works for NE or NW
% Australia
region = 'NE' % or 'NW' or 'NE'


idx_last = length(rain_NW);
% run stepwiselinearmodel built in  function first get predictors for
% required month of the year

      if strcmp('NW',region)
            response_variable=rain_NW(month,2:end);
        else
            strcmp('NE',region)
            response_variable=rain_NE(month,2:end);
       end 

    % first allocate all predictors that are the same regardless the time
    % period --> all SST Indices and all AWRA-L based indices (soil
    % moisture and evapotranspiration)

% get response variable and predictors for the correct month 
if strcmp('1920-2023',time_period)
    [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,...
    Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std);

elseif strcmp('1940-2023',time_period)
    [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,...
    Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO);

elseif strcmp('1957-2023',time_period) 
    [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,...
    Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM);

elseif strcmp('1959-2023',time_period) 
    [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM,MSE_NS]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,...
    Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM,MSE);    

else
    strcmp('1975-2023',time_period)
     [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM,MJO_81,MJO_456,MJO_inactive]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,...
    Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
    Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,evap,TBO,AM_SAM,MJO_81_std,MJO_456_std,MJO_inactive_std);
end


% now get input table with correct predictors for the chosen month and area
% to use for rainfall (northwest or northeast) chose the input predictors
% depending on the time period that is used

if strcmp('1920-2023',time_period)

[Input_table]=stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1);

elseif strcmp('1940-2023',time_period)

[Input_table]=stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m);

elseif strcmp('1957-2023',time_period)

[Input_table]=stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM);

elseif strcmp('1959-2023',time_period)

[Input_table]=stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM,MSE_NS);

else
    strcmp('1975-2023',time_period)

[Input_table]=stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM,MJO_81,MJO_456); % removed inactive MJO 

end

% run built-in matlab function for stepwise linear regression --> chose
% 'Verbose' 2 if more info needed about p values etc used when adding
% predictors to the model
stepwise_mdl = stepwiselm(Input_table,'Penter',0.1,'PRemove',0.11,'Verbose',2)
stepwise_regression_model = stepwise_mdl.Formula.LinearPredictor
R_squared_adjusted = stepwise_mdl.Rsquared.Adjusted



%% manual calculation of r squared for each predictor in stepwise linear model 

% use ~ instead of an output parameter I don't want to see, 
% insert predictors in correct order to be tested --> choose order either
% depending on output from stepwiselm, or try out other orders of
% predictors such as starting with remote indices, finish with internal
% feedback indices 

% input: name of predictors needed: list of possible predictors is: 
% CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
%     ET_lag_minus1,NW_oceanic_evap,TBO_m,SAM,MJO_81,MJO_456,MJO_inactive,
%     MSE_NS

% set output: summary for each predictor and their associated R,p and R2
% value as P1_summary, P2_summary, P3_summary,....
% P_x_summary = [R p-value R squared] --> for each predictor 
% number of P1_summary outputs needs to be same as number of input
% predictors 
[r2_total_adjusted,P1_summary,P2_summary] = manual_stepwiselm_func(response_variable,...
   CP,NW_oceanic_evap)
 



