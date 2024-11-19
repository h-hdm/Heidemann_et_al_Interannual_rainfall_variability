% get response variables and predictors for the correct months of the year 

function [response_variable,CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,C,E,SM_lag_minus1,...
    ET_lag_minus1,varargout]=choose_months_stepwise(region,month,time_period,rain_NW,rain_NE,Nino34_std,CP_std,EP_std,DMI_std,Coral_std,Timor_std,...
     Arafura_std,IOBW_std,TPI_filt,Ningaloo_std,C_std,E_std,SM_NE_anom_std,SM_NW_anom_std,etot_NE_anom_std,...
    etot_NW_anom_std,varargin)

% to tidy up my script
% needs to first run: 
% 1) NA_rainfall_ts
% 2) get_SST_indices_func
% 3) get_non_oceanic_indices_func
% 4) get_mjo_freq_func
% to generate input required here! 


% get months for all required predictors 

      if strcmp('NW',region)
            response_variable=rain_NW(month,2:end);
        else
            strcmp('NE',region)
            response_variable=rain_NE(month,2:end);
       end 

    % first allocate all predictors that are the same regardless the time
    % period --> all SST Indices and all AWRA-L based indices (soil
    % moisture and evapotranspiration)


if strcmp('1920-2023',time_period) || strcmp('1940-2023',time_period) || strcmp('1957-2023',time_period) || strcmp('1959-2023',time_period) || strcmp('1975-2023',time_period);

    CP=CP_std(month,2:end); % CP Index
    EP=EP_std(month,2:end); % EP Index
    DMI=DMI_std(month,2:end); % DMI or just DMI western or eastern box (DMI_east_std DMI_west_std)
    Coral=Coral_std(month,2:end); % Coral Sea 
    Timor=Timor_std(month,2:end); % Timor Sea 
    Arafura=Arafura_std(month,2:end); % Arafura and Gulf 
    C=C_std(month,2:end); % CP Index
    E=E_std(month,2:end); % EP Index
    
    IOBW=IOBW_std(month,2:end); % IOBW
    
    if month>=2;
        Nino34_lag_minus1=Nino34_std(month-1,2:end); % 1-month lagged SST Index for January use here 12, 1:102 and in all other cases 2:103
        
        if strcmp('NE',region)
        SM_lag_minus1=SM_NE_anom_std(month-1,2:end);
        ET_lag_minus1=etot_NE_anom_std(month-1,2:end);
        else
        strcmp('NW',region)
        SM_lag_minus1=SM_NW_anom_std(month-1,2:end);
        ET_lag_minus1=etot_NW_anom_std(month-1,2:end);
        end
    
    else
        month=1;
        Nino34_lag_minus1=Nino34_std(12,1:end-1);
    
        if strcmp('NE',region)
        SM_lag_minus1=SM_NE_anom_std(12,1:end-1);
        ET_lag_minus1=etot_NE_anom_std(12,1:end-1);
        else
        strcmp('NW',region)
        SM_lag_minus1=SM_NW_anom_std(12,1:end-1);
        ET_lag_minus1=etot_NW_anom_std(12,1:end-1);
        end
    
    end 
    
    TPI=TPI_filt(month,2:end); % 13-year lowpass filtered TPI
    Ningaloo = Ningaloo_std(month,2:end); % Ningaloo Nino Index
else

end 

if strcmp('1940-2023',time_period) || strcmp('1957-2023',time_period) || strcmp('1959-2023',time_period) || strcmp('1975-2023',time_period);
    % from 1940 add all ERA5 based indices
    evap = varargin{1};
    varargout{1} = evap(month,2:end); % Evaporation in oceans NW of Australia evap
    
    if month==12 
        TBO = varargin{2};
        varargout{2} = TBO(2:end); % input needed: TBO
    else
        month==1 || month==2 || month==3; 
        TBO = varargin{2};
        varargout{2} = TBO(1:end-1); % input needed: TBO
    end 
else

end 
    

if strcmp('1957-2023',time_period) || strcmp('1959-2023',time_period) || strcmp('1975-2023',time_period); %--> oceanic evaporation, TBO and 
    % SAM included
    if month>=6 
        AM_SAM = varargin{3};
        varargout{3} = AM_SAM(2:end); 
    else
        month==1 || month==2 || month==3 || month == 4 
        AM_SAM = varargin{3};
        varargout{3} = AM_SAM(1:end-1); 
    end 
    
else

end 


if strcmp('1959-2023',time_period) 

    % do this if looking at MSE gradient during the same month as the
    % rainfall index 
%     MSE = varargin{4};
%     varargout{4}=MSE(month,2:end); % MSE gradient (same month) index 

%     % use below if needing MSE gradient lag-1 month 
    if month>=2;
        MSE = varargin{4};
        varargout{4}=MSE(month-1,2:end); % 1-month lagged MSE gradient Index for January use here 12, 1:102 and in all other cases 2:103
        
        
    else
        month=1;
        MSE = varargin{4};
        varargout{4}=MSE(12,1:end-1);
    
       
    end 


else

end 

if strcmp('1975-2023',time_period) ;
    % MJO included
    MJO_81_std=varargin{4};
    varargout{4} = MJO_81_std(month,2:end); 
    MJO_456_std=varargin{5};
    varargout{5} = MJO_456_std(month,2:end);  
    MJO_inactive_std=varargin{6};
    varargout{6} = MJO_inactive_std(month,2:end); 
else

end 





















end 