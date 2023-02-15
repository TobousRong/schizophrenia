clc;clear;close all
Subj =textread('schz_task.txt','%s');
N_sub=length(Subj);N=100;Total=152;width=30;
X=[];
for sub=1:50
    path=strcat('D:\desktop\frmri_data\100_task\',Subj(sub),'_task.mat');
    load(char(path));
    X=[X;task_BOLD];
end
con=corr(X);
IN=[];IM=[];
[Clus_num,Clus_size,FC] = Functional_HP(con,N);
[Hin,Hse,HF] =Balance(con,N,Clus_size,Clus_num);
IN=[IN;Hin];IM=[IM;Hse];

X=[];
for sub=51:100
    path=strcat('D:\desktop\frmri_data\100_task\',Subj(sub),'_task.mat');
    load(char(path));
    X=[X;task_BOLD];
end
bip=corr(X);
[Clus_num,Clus_size,FC] = Functional_HP(bip,N);
[Hin,Hse,HF] =Balance(bip,N,Clus_size,Clus_num);
IN=[IN;Hin];IM=[IM;Hse];
save('task_HF100.mat','IN','IM')


