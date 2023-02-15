clc;clear;close all
% Subj =textread('schz_task.txt','%s');
% N_sub=length(Subj);N=100;Total=208;width=30;T=[];
Subj =textread('schz.txt','%s');
N_sub=length(Subj);N=200;Total=152;width=30;T=[];
sys=xlsread('D:\desktop\Thomas_roi100.xlsx','sheet1','d1:d100');
S=load('taskswitch_corrected_individual_HF100.mat');
for sub=1:N_sub
    DataDir=strcat('D:\desktop\m\',Subj(sub),'_dFC.mat');
    load(char(DataDir));
    path=strcat('D:\desktop\m\',Subj(sub),'_dClus.mat');
    load(char(path));
    filename =strcat('D:\desktop\m\',Subj(sub),'_resting_corrected_dHF.mat');
    H=load(char(filename));
    IN=[];IM=[];
    parfor t=1:Total-width;
        [Hin,Hse,HF] =Balance(FC{t},N,Clus_size{t},Clus_num{t});
        fc=FC{t};
        fc(fc<0)=0;
        fc=(fc+fc')/2;
        [FEC FE]=eig(fc);
        H1=(diag(HF)*flipud((FEC.^2)'));
        Hin=H1(1,:);
        Hse=sum(H1(2:N,:));
        IN=[IN;Hin/mean(Hin)*H.Hin(t)];IM=[IM;Hse/mean(Hse)*H.Hse(t)];  %%correct
    end
%         n=find(sys==1);
%         IN=mean(T(:,n)');
%         IM=mean(T(:,n)');
        Z=[];
        for u=1:N
            [HB_std,Fre,W_fle,In,Se,In_time,Se_time] = Flexible(IN(:,u)-IM(:,u),2);
            Z=[Z,std(IM(:,u))]; %[Z,std(IM(:,u))]
        end
        Z(find(isnan(Z)))=0;
        T=[T;Z];      
end
T=mean(T,2);
T=T';
    for s=1:7
        n=find(sys==s);
        IN2=mean(T(:,n)')';
%         IM=mean(T(:,n)');
    end

P=[];
for m=1:N
[h p]=ttest2(T(1:50,m),T(51:100,m));
P=[P,p];
end
P=mafdr(P,'BHFDR',true);


permutation_num=10000;
change=(mean(T(51:100,:))-mean(T(1:50,:)))./mean(T(1:50,:));
sub_num=1:7;
diff_permutation=zeros(7,7);
diff_true=zeros(7,7);
P=zeros(7,7);

for i=sub_num
    %%% calculate difference between subsystem;
    subsys=[];
    for j=sub_num
        m=find(sys==j);
        df1=mean(change(m));
        subsys=[subsys,df1];
    end
    diff_true(i,:)=abs(subsys(i))-abs(subsys(:,:));
    %%%permutation test
    results=[];
    for k=1:permutation_num
        rng(k);
        rand_index=randperm(size(change,2));
        new_data=change(rand_index);
        sub_change=[];
        for s=sub_num
            n=find(sys==s);
            df=mean(new_data(n));
            sub_change=[sub_change,df];
        end
        diff_permutation=abs(sub_change(i))-abs(sub_change(:,:));
        results=[results;diff_permutation];
    end
    for l=sub_num
        P(i,l)=length(find(results(:,l)>=diff_true(i,l)))/length(results);
    end
end

D=[];
for s=1:200
    x=[ones(50,1),T(51:100,s)];
    for i=1:2
        %         c=corr(T(50:98,s),Total_score(51:100,i));
        y=Total_score(1:50,i);
        [b,bint,r,rint,stats]=regress(y,x,0.05);
        D=[D,stats(3)];
    end
end
Y=reshape(D,2,200)';
Y(Y>=0.05)=0;
a1=Y(:,1)';
a2=Y(:,2)';

xlswrite('C:\Users\user\Desktop\local_results.xlsx',T,'a2:a101');
for i=8:14
    %     n=find(sys==i);
    %     Fin=std(IN(:,n)');
    %     Fse=std(IM(:,n)');
    %     [h p]=ttest2(Fin(:,1:50),Fin(:,51:100));
    %     [h1 p1]=ttest2(Fse(:,1:50),Fse(:,51:100));
    %     P=[P;p,p1];
    N=abs(mean(radar(1:50,i)-radar(51:100,i))/mean(radar(1:50,i)));
    [h p]=ttest2(radar(1:50,i),radar(51:100,i));
    %     M=abs(mean(radar(:,1:50)-radar(:,51:100))/mean(radar(:,1:50)));
    L=[L;N,p];
end