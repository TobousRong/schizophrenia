clc;clear;close all
Subj =textread('schz_task.txt','%s');
N_sub=length(Subj);N=100;Total=142;width=30;
% mypool=parpool('local',24,'IdleTimeout',240);
for sub=1:N_sub
    path=strcat('D:\desktop\m\',Subj(sub),'_dFC.mat');
    load(char(path));
    Clus_num={};Clus_size={};
 parfor t=1:Total-width         %%dClus
        [C_num,C_size] = Functional_HP(FC{t},N);
        Clus_num{t}=C_num;
        Clus_size{t}=C_size;   
  end
    filename =strcat(Subj(sub),'_dClus.mat');
    save(char(filename),'Clus_num','Clus_size')
end


% %     parfor t=1:Total-width
%         [C_num,C_size] = Functional_HP(FC,N);
%         Clus_num=C_num;
%         Clus_size=C_size;   
% %     end


% 
%  parfor t=1:Total-width         %%dClus
%         [C_num,C_size] = Functional_HP(FC{t},N);
%         Clus_num{t}=C_num;
%         Clus_size{t}=C_size;   
%   end