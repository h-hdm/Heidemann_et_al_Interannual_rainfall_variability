% gernerate input table for stepwise linear model (built in matlab
% function) 

function [Input_table] = stepwiselm_table_func(time_period,month,region,response_variable,...
    CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,...
    ET_lag_minus1,varargin)

% the predictor variables vary depending on the time period that is chosen

% for 1920 to 2023 need 
% CP,EP,Coral,Timor,Arafura,DMI,IOBW,TPI,Ningaloo,Nino34_lag_minus1,SM_lag_minus1,ET_lag_minus1,
% for 1940 to 2023 need additionally
% NW_oceanic_evap,TBO_m
% for 1957 to 2023 need additionally
% SAM
% for 1975 to 2023 need additionally
% MJO_81,MJO_456,MJO_inactive

% create Table with all input predictors and the response variable
% (which varies depending on the month and time period used 

if strcmp('1920-2023',time_period)

% for 1920 to 2023

if month >=5 && month <=8
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "Northern Australian rainfall"];

elseif month >=9 && month <=11
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "Northern Australian rainfall"];

elseif month==4
% no DMI for this season 
Input_table = table(CP',EP',Coral',Timor',Arafura',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',Ningaloo',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "Ningaloo Nino Index","Northern Australian rainfall"];

elseif month==3
    
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',TBO_m',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "TBO","Northern Australian rainfall"];
elseif month==2 % needed to remove Coral Sea just for Feb because it had a negative correlation
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',TPI',Ningaloo',TBO_m',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","TPI lowpass",...
       "Ningaloo Nino Index","TBO","Northern Australian rainfall"];

elseif month==1
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',Ningaloo',TBO_m',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
      "Ningaloo Nino Index","TBO","Northern Australian rainfall"];
  
else
    month=12;
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',Ningaloo',TBO_m',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "Ningaloo Nino Index","TBO","Northern Australian rainfall"]; 
end 


% for 1940 to 2023
elseif strcmp('1940-2023',time_period)

if month >=5 && month <=8
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "Northern Australian rainfall"];

elseif month >=9 && month <=11
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","Northern Australian rainfall"];

elseif month==4
% no DMI for this season 
Input_table = table(CP',EP',Coral',Timor',Arafura',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',Ningaloo',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "Ningaloo Nino Index","Northern Australian rainfall"];
elseif month==3
    
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Northern Australian rainfall"];
elseif month==2 % needed to remove Coral Sea just for Feb because it had a negative correlation
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","Northern Australian rainfall"];
elseif month==1
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","Northern Australian rainfall"];
  
else
    month=12;
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","Northern Australian rainfall"]; 
end 

% for 1957 to 2023 
elseif strcmp('1957-2023',time_period)

% use this to include all predictors 
if month >=5 && month <=11
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","Northern Australian rainfall"];
elseif month==4
% no DMI for this season 
Input_table = table(CP',EP',Coral',Timor',Arafura',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","Ningaloo Nino Index","Northern Australian rainfall"];
elseif month==3
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Northern Australian rainfall"];
elseif month==2 % needed to remove Coral Sea just for Feb because it had a negative correlation
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{3}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","AM SAM","Northern Australian rainfall"];
elseif month==1
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{3}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","AM SAM","Northern Australian rainfall"];
  
else
    month=12;
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{3}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","AM SAM","Northern Australian rainfall"]; 
end 


elseif strcmp('1959-2023',time_period)

if month >=6 && month <=9
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];

elseif month == 10 % remove soil moisture and ET only when calculating NE 

    if strcmp('NW',region)    
    Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
       "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];
    % below only for NE
    else
        strcmp('NE',region)
    Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
       "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];
    end 

elseif month ==11
Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];

elseif month==12;
    % no northern Australian SSTs and DMI for this season, no SAM due to wrong sign of correlations  

    if strcmp('NW',region)
    Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
     "NW oceanic evaporation","Ningaloo Nino Index","TBO","MSE NS","Northern Australian rainfall"]; 
    else % include Coral Sea just for NE
        strcmp('NE',region)
    Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
     "NW oceanic evaporation","Ningaloo Nino Index","TBO","MSE NS","Northern Australian rainfall"]; 

    end 

elseif month==1
    % no northern Australian SSTs and DMI for this season 
%   Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',varargin{5}',response_variable');
%     Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
%        "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","AM SAM","MJO phase 4,5,6","Northern Australian rainfall"];
    Input_table = table(Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',response_variable');
    Input_table.Properties.VariableNames=["Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","MSE NS","AM SAM","Northern Australian rainfall"];


elseif month==2 % needed to remove Coral Sea just for Feb because it had a negative correlation
    % no northern Australian SSTs and DMI for this season 
    % remove soil moisture as correlations vary between positive and
    % negative in Feb (and remove ET as well)
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","MSE NS","AM SAM","Northern Australian rainfall"];

elseif month==3
    % removed Ningaloo from March due to inconsistent relationship through,
    % removed TBO due to also inconsistent relatinship
    % time 
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];
%    Input_table = table(CP',EP',Coral',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{5}',response_variable');
%     Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
%        "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];   

elseif month==4 
% no DMI for this season % remove Coral Sea and Timor Sea and Arafura
% use this for northwest:
    if strcmp('NW',region)
    Input_table = table(EP',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["EP_Index",...
       "Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];
    else
                strcmp('NE',region)
    % use this for northeast:
    Input_table = table(CP',EP',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index",...
       "Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];
    end 

else
    month =5
% no DMI and Nino 3.4 lag-1 for this season
% NE: remove EP and MJO 4,5,6
Input_table = table(CP',Coral',Timor',Arafura',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MSE NS","Northern Australian rainfall"];

end 

% for 1975 to 2023
else
    strcmp('1975-2023',time_period)


if month >=6 && month <=8
 Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];

elseif month ==9 % remove MJO phases 4,5,6 due to inconsistent relationship in September 
Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MJO phase 8,1","Northern Australian rainfall"];

elseif month == 10 % remove soil moisture and ET only when calculating NE 

    if strcmp('NW',region)    
    Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
       "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];
    % below only for NE
    else
        strcmp('NE',region)
    Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
       "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];
    end 

elseif month ==11
Input_table = table(CP',EP',Coral',Timor',Arafura',DMI',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","DMI","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];

elseif month ==5
% no DMI and Nino 3.4 lag-1 for this season
% NE: remove EP and MJO 4,5,6
Input_table = table(CP',Coral',Timor',Arafura',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',response_variable');
Input_table.Properties.VariableNames=["CP_Index","Coral Sea",...
   "Timor Sea","Arafura and Gulf","Soil moisture lag-1","ET lag-1","TPI lowpass",...
   "NW oceanic evaporation","MJO phase 8,1","Northern Australian rainfall"];

elseif month==4 
% no DMI for this season % remove Coral Sea and Timor Sea and Arafura
% use this for northwest:
    if strcmp('NW',region)
    Input_table = table(EP',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["EP_Index",...
       "Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];
    else
                strcmp('NE',region)
    % use this for northeast:
    Input_table = table(CP',EP',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index",...
       "Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];
    end 

elseif month==3
    % removed Ningaloo from March due to inconsistent relationship through time,
    % removed TBO due to also inconsistent relatinship
    % time 
    % no northern Australian SSTs and DMI for this season 
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];
%    Input_table = table(CP',EP',Coral',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{5}',response_variable');
%     Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
%        "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"];   
elseif month==2 % needed to remove Coral Sea just for Feb because it had a negative correlation
    % no northern Australian SSTs and DMI for this season 
    % remove soil moisture as correlations vary between positive and
    % negative in Feb (and remove ET as well)
  Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","AM SAM","MJO phase 4,5,6","Northern Australian rainfall"];

elseif month==1
    % no northern Australian SSTs and DMI for this season 
%   Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',varargin{5}',response_variable');
%     Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
%        "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","AM SAM","MJO phase 4,5,6","Northern Australian rainfall"];
    Input_table = table(Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{3}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
       "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","AM SAM","MJO phase 4,5,6","Northern Australian rainfall"];
  
else
    month=12;
    % no northern Australian SSTs and DMI for this season, no SAM due to wrong sign of correlations not supporting proposed physical mechanism  

    if strcmp('NW',region)
    Input_table = table(CP',EP',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
     "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"]; 
    else % include Coral Sea just for NE
        strcmp('NE',region)
    Input_table = table(CP',EP',Coral',IOBW',Nino34_lag_minus1',SM_lag_minus1',ET_lag_minus1',TPI',varargin{1}',Ningaloo',varargin{2}',varargin{4}',varargin{5}',response_variable');
    Input_table.Properties.VariableNames=["CP_Index","EP_Index","Coral Sea","IOBW","Nino34 lag-1","Soil moisture lag-1","ET lag-1","TPI lowpass",...
     "NW oceanic evaporation","Ningaloo Nino Index","TBO","MJO phase 8,1","MJO phase 4,5,6","Northern Australian rainfall"]; 

    end 

end 


end 





end 