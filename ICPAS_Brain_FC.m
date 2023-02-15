clc;clear;close all
%% Static analysis: This function calculates the calibrated Hin, Hse and HB from fMRI time series 
Subj =textread('schz_task.txt','%s');
N_sub=length(Subj);N=100;Total=142;width=30;
Long_fmri=[];
%mypool=parpool('local',24,'IdleTimeout',240);
for sub=1:N_sub
    path=strcat('D:\desktop\frmri_data\100_task\',Subj(sub),'_task.mat');
    load(char(path));
    FC=corr(task_BOLD);
  FC={};
     parfor t=1:Total-width
            subdata=task_BOLD(t:t+width,:);
%           [FC,n] = FDR_FC(Data,N,0.05); 
            FC{t}=corr(subdata);
     end
     filename =strcat(Subj(sub),'_dFC.mat');
     save(char(filename),'FC')
end