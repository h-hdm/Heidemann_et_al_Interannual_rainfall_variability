% manual stepwise linear regression 

% uses previous knowledge about predictors to include in the model from
% built in matlab function stpwiselm or elsewhere

% need timeseries for response variable and the predictors --> add
% predictor variable time series in correct order as varargin

function [r2_total_adjusted,varargout] = manual_stepwiselm_func(response_variable,varargin)

%-------------------------
% r2_total_adjusted: The adjusted R2 value for the final model, which is an indicator 
% of the model's goodness-of-fit while accounting for the number of predictors.

% varargout: Optional output arguments returned by the stepwiselm function, which can 
% include various details of the stepwise regression process.


nout = max(nargout,1) - 1;


% next get predictors - to be calculated in another script first 


% 2) perform stepwise linear regression (with decision about which predictors
% to include and which order to be made previously)
% this is to get the amount of explained variance for each predictor that
% is included in the stepwise model in each month, to be able to assess
% contribution of each predictor to total explained variance and plot later
% 
for i = 1:length(varargin) % number of predictors 

% get R squared for first predictor 
    if i==1
    % polyfit returns coefficients for polynomial p(x) of degree n that is best
    % fit for data in y! polyfit(x,y,n)
    [p,S] = polyfit(varargin{i},response_variable,1);
%     [p,S] = polyfit(predictor_1,response_variable,1);
    [fitted_y,delta] = polyval(p,varargin{i},S);
    [R_1,pval_1] = corrcoef(response_variable,varargin{i});
    R_1 = R_1(1,2);
    pval_1 = pval_1(1,2);
    R_squ_1 = R_1.^2;
    P1_summary = [R_1 pval_1 R_squ_1]; % Corrcoef, p value and R squared 
    varargout{i} = P1_summary;
    
    % error term 
    residual_1 = response_variable-fitted_y;

    if length(varargin)==1
        r2_total_adjusted = R_squ_1;
    end 

% R squared for second predictor 
    elseif i==2 
%     [p,S] = polyfit(predictor_2,residual_1,1);
    [p,S] = polyfit(varargin{i},residual_1,1);
    [fitted_y,delta] = polyval(p,varargin{i},S);
    [R_2,pval_2] = corrcoef(residual_1,varargin{i});
    R_2 = R_2(1,2);
    pval_2 = pval_2(1,2);
    R_sq_2 = R_2.^2;
    P2_summary = [R_2 pval_2 R_sq_2]; % Corrcoef, p value and R squared 
    varargout{i} = P2_summary;

    % next residual 
    residual_2 = residual_1 - fitted_y; 
    
    % total r squared adjusted for number of predictors 
    r2_12 = R_squ_1+R_sq_2;
    
    n =length(residual_2); 
    k=2;
    r2_12_adjusted = 1-(((1-r2_12)*(n-1))/(n-k-1));

    if length(varargin)==2
    r2_total_adjusted = r2_12_adjusted;
    else

    end 
    

% R squared for third predictor 

    elseif i==3
    
    input_rainfall_resid = residual_2;
    input_predictor = varargin{i};
    % input_predictor = x1;
    
    [p,S] = polyfit(input_predictor,input_rainfall_resid, 1);
    [fitted_y,delta] = polyval(p,input_predictor,S);
    
    
    % p value and explained variance (r2)
    [R,pval_3] = corrcoef(input_rainfall_resid,input_predictor);
    R_3 = R(1,2);
    pval_3 = pval_3(1,2);
    r_squared_3 = R_3.^2;
    P3_summary = [R_3 pval_3 r_squared_3]; % Corrcoef, p value and R squared 
    varargout{i} = P3_summary;
    
    % residual 
    residual_3 = input_rainfall_resid - fitted_y; 
    r2_123 = R_squ_1+R_sq_2+r_squared_3;

    n =length(input_predictor); 
    k=3;
    r2_123_adjusted = 1-(((1-r2_123)*(n-1))/(n-k-1));

    if length(varargin)==3
    r2_total_adjusted = r2_123_adjusted;
    else

    end 


% R squared for 4th predictor 

    elseif i==4

        input_rainfall_resid = residual_3;
        input_predictor = varargin{i};
        % input_predictor = x2;
        
        [p,S] = polyfit(input_predictor,input_rainfall_resid, 1);
        [fitted_y,delta] = polyval(p,input_predictor,S);
        
        
        % p value and explained variance (r2)
        [R,pval_4] = corrcoef(input_rainfall_resid,input_predictor);
        R_4 = R(1,2);
        pval_4 = pval_4(1,2);
        r_squared_4 = R_4.^2;
        P4_summary = [R_4 pval_4 r_squared_4]; % Corrcoef, p value and R squared
        varargout{i} = P4_summary;

        % residual 
        residual_4 = input_rainfall_resid - fitted_y; 

        r2_1234 = R_squ_1+R_sq_2+r_squared_3+r_squared_4;

        n =length(input_predictor); 
        k=4;
        r2_1234_adjusted = 1-(((1-r2_1234)*(n-1))/(n-k-1));

        if length(varargin)==4
        r2_total_adjusted = r2_1234_adjusted;
        else
    
        end 


    elseif i==5
        input_rainfall_resid = residual_4;
        input_predictor = varargin{i};
        
        [p,S] = polyfit(input_predictor,input_rainfall_resid, 1);
        [fitted_y,delta] = polyval(p,input_predictor,S);
        
        
        % p value and explained variance (r2)
        [R,pval_5] = corrcoef(input_rainfall_resid,input_predictor);
        R_5 = R(1,2);
        pval_5 = pval_5(1,2);
        r_squared_5 = R_5.^2;
        P5_summary = [R_5 pval_5 r_squared_5]; % Corrcoef, p value and R squared
        varargout{i} = P5_summary;

        % residual 
        residual_5 = input_rainfall_resid - fitted_y; 

        r2_12345 = R_squ_1+R_sq_2+r_squared_3+r_squared_4+r_squared_5;

        n =length(input_predictor); 
        k=5;
        r2_12345_adjusted = 1-(((1-r2_12345)*(n-1))/(n-k-1));

        if length(varargin)==5
        r2_total_adjusted = r2_12345_adjusted;
        else
    
        end 

    elseif i==6

        input_rainfall_resid = residual_5;
        input_predictor = varargin{i};
        
        [p,S] = polyfit(input_predictor,input_rainfall_resid, 1);
        [fitted_y,delta] = polyval(p,input_predictor,S);
        
        
        % p value and explained variance (r2)
        [R,pval_6] = corrcoef(input_rainfall_resid,input_predictor);
        R_6 = R(1,2);
        pval_6 = pval_6(1,2);
        r_squared_6 = R_6.^2;
        P6_summary = [R_6 pval_6 r_squared_6]; % Corrcoef, p value and R squared
        varargout{i} = P6_summary;
        
        % residual 
        residual_6 = input_rainfall_resid - fitted_y; 

        r2_123456 = R_squ_1+R_sq_2+r_squared_3+r_squared_4+r_squared_5+r_squared_6;

        n =length(input_predictor); 
        k=6;
        r2_123456_adjusted = 1-(((1-r2_123456)*(n-1))/(n-k-1));

        if length(varargin)==6
        r2_total_adjusted = r2_123456_adjusted;
        else
    
        end 

    else
        i==7

        input_rainfall_resid = residual_6;
        input_predictor = varargin{i};
        
        [p,S] = polyfit(input_predictor,input_rainfall_resid, 1);
        [fitted_y,delta] = polyval(p,input_predictor,S);
        
        
        % p value and explained variance (r2)
        [R,pval_7] = corrcoef(input_rainfall_resid,input_predictor);
        R_7 = R(1,2);
        pval_7 = pval_7(1,2);
        r_squared_7 = R_7.^2;
        P7_summary = [R_7 pval_7 r_squared_7]; % Corrcoef, p value and R squared
        varargout{i} = P7_summary;

        % residual 
        residual_7 = input_rainfall_resid - fitted_y; 
        r2_1234567 = R_squ_1+R_sq_2+r_squared_3+r_squared_4+r_squared_5+r_squared_6+r_squared_7;

        n =length(input_predictor); 
        k=7;
        r2_1234567_adjusted = 1-(((1-r2_1234567)*(n-1))/(n-k-1));

        if length(varargin)==7
        r2_total_adjusted = r2_1234567_adjusted;
        else
    
        end 


    end 
    
end 


end 





