% get MJO metrics - needed for Figures 5,6 and 7

% MJO phases 4,5,6 used in Heidemann et al. (2025) to represent convectively active phases
% MJO phases 8,1 used in Heidemann et al. (2025) to represent convectively suppressed phases 

% works for 4 MJO combinatios: MJO inactive, MJO phases 8,1 and
% MJO phases 4,5,6 or 5,6,7

function [MJO_456_std,MJO_567_std,MJO_81_std,MJO_inactive_std]=get_mjo_freq_func

% MJO: number of active MJO days per month (and inactive) saved 
fid = 'MJO_freq_1975_2023_upd.nc';

ncdisp(fid)

MJO_phase4 = ncread(fid,'MJO_phase4');
MJO_phase5 = ncread(fid,'MJO_phase5');
MJO_phase6 = ncread(fid,'MJO_phase6');
MJO_phase7 = ncread(fid,'MJO_phase7');
MJO_phase8 = ncread(fid,'MJO_phase8');
MJO_phase1 = ncread(fid,'MJO_phase1');
MJO_phase2 = ncread(fid,'MJO_phase2');
MJO_phase3 = ncread(fid,'MJO_phase3');
MJO_phases_inactive = ncread(fid,'MJO_phases_inactive');



% Total number of days in phases 4,5,6 or 5,6,7 --> convectively active MJO options
MJO_567 = MJO_phase5+MJO_phase6+MJO_phase7;
MJO_456 = MJO_phase4+MJO_phase5+MJO_phase6;



% suppressed MJO phases options:
MJO_81 = MJO_phase8+MJO_phase1;
MJO_781 = MJO_phase7+MJO_phase8+MJO_phase1;
MJO_78 = MJO_phase7+MJO_phase8;



% detrend
    MJO_456_detr = zeros(size(MJO_456));
    for i_dx = 1:12
    MJO_456_detr(i_dx,:)=detrend(squeeze(MJO_456(i_dx,:)));
    end

    MJO_567_detr = zeros(size(MJO_567));
    for i_dx = 1:12
    MJO_567_detr(i_dx,:)=detrend(squeeze(MJO_567(i_dx,:)));
    end


    % standardise
    MJO_456_std = zeros(size(MJO_456_detr));
    for i_dx = 1:12
    MJO_456_std(i_dx,:)=(MJO_456_detr(i_dx,:)-mean(MJO_456_detr(i_dx,:)))/std(MJO_456_detr(i_dx,:));
    end

    MJO_567_std = zeros(size(MJO_567_detr));
    for i_dx = 1:12
    MJO_567_std(i_dx,:)=(MJO_567_detr(i_dx,:)-mean(MJO_567_detr(i_dx,:)))/std(MJO_567_detr(i_dx,:));
    end


 % combinations of two MJO phases below:
    MJO_81 = MJO_phase8+MJO_phase1;
    MJO_67 = MJO_phase6+MJO_phase7;
    MJO_45 = MJO_phase4+MJO_phase5;
    MJO_23 = MJO_phase2+MJO_phase3;
    
    MJO_81_std = zeros(size(MJO_81));
    MJO_67_std = zeros(size(MJO_67));
    MJO_45_std = zeros(size(MJO_45));
    MJO_23_std = zeros(size(MJO_23));
    MJO_inactive_std = zeros(size(MJO_phases_inactive));


% detrend and standardise

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_45(i_dx,:)));
        MJO_45_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_23(i_dx,:)));
        MJO_23_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_67(i_dx,:)));
        MJO_67_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_81(i_dx,:)));
        MJO_81_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phases_inactive(i_dx,:)));
        MJO_inactive_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end

% also detrend and standardise single phases  

MJO_1_std = zeros(size(MJO_phase1));
MJO_2_std = zeros(size(MJO_phase2));
MJO_3_std = zeros(size(MJO_phase3));
MJO_4_std = zeros(size(MJO_phase4));
MJO_5_std = zeros(size(MJO_phase5));
MJO_6_std = zeros(size(MJO_phase6));
MJO_7_std = zeros(size(MJO_phase7));
MJO_8_std = zeros(size(MJO_phase8));

    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase1(i_dx,:)));
        MJO_1_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase2(i_dx,:)));
        MJO_2_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase3(i_dx,:)));
        MJO_3_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase4(i_dx,:)));
        MJO_4_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase5(i_dx,:)));
        MJO_5_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase6(i_dx,:)));
        MJO_6_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase7(i_dx,:)));
        MJO_7_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end
    for i_dx = 1:12
        MJO_detr=detrend(squeeze(MJO_phase8(i_dx,:)));
        MJO_8_std(i_dx,:)=(MJO_detr-mean(MJO_detr))/std(MJO_detr);
    end


end 
