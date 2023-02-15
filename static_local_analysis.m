clc;clear;close all
Subj =textread('schz_task.txt','%s');
sys=xlsread('D:\desktop\thomas_roi\Thomas_roi100.xlsx','sheet1','d1:d100');
N_sub=length(Subj);N=100;Total=142;width=30;IN=[];IM=[];L=[];P=[];
D=load('task_corrected_individual_HF100.mat');
for sub=1:N_sub
    DataDir=strcat('D:\desktop\m\',Subj(sub),'_sFC.mat');
    load(char(DataDir));
    path=strcat('D:\desktop\m\',Subj(sub),'_sClus.mat');
    load(char(path));
    [Hin,Hse,HF] =Balance(FC,N,Clus_size,Clus_num);
    fc=FC;
    fc(fc<0)=0;
    fc=(fc+fc')/2;
    [FEC FE]=eig(fc);
    H1=(diag(HF)*flipud((FEC.^2)'));
    Hin=H1(1,:);
    Hse=sum(H1(2:N,:));
    IN=[IN;Hin/mean(Hin)*D.Hin(sub)];IM=[IM;Hse/mean(Hse)*D.Hse(sub)];
end
HIN1=mean(IN,2);
HSE1=mean(IM,2);
HB=(IN-IM);
R=[];S=[];T=[];
for s=1:7
    n=find(sys==s);
    IN1=mean(T(:,n)')';
    IM1=mean(IM(:,n)')';
    HB1=mean(((IN(:,n)-IM(:,n))),2);
    S=[S;IN1];
    R=[R;IM1];
end
[h p]=ttest2(HSE1(1:50),HSE1(51:100))
S=reshape(S,100,7);
R=reshape(R,100,7);
T=[S,R];
%%==============
permutation_num=10000;
change=(mean(IN(51:100,:))-mean(IN(1:50,:)))./mean(IN(1:50,:));
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

P=[];T=[];
for i=1:200
[h p]=ttest2(IN(1:50,i),IN(51:100,i));
P=[P,p];
Din=mean(IN(51:100,i)-IN(1:50,i));
T=[T,Din];
end
P=mafdr(P,'BHFDR',true);
T(P>=0.05)=0;
clear Clus_num Clus_size D FC FE FEC H1 HF Total width fc Hin Hse 
L=[];
for i=1:7
    n=find(sys==i);
    IN1=mean(IN(:,n)');
    IM1=mean(IM(:,n)');
    [h p]=ttest2(IN1(:,1:50),IN1(:,51:100));
    [h1 p1]=ttest2(IM1(:,1:50),IM1(:,51:100));
    P=[P;p,p1];
    N=mean(IN1(:,51:100)-IN1(:,1:50))/mean(IN1(:,1:50));
    N2=(mean(IM1(:,51:100))-mean(IM1(:,1:50)))/mean(IM1(:,1:50));
    L=[L;N,N2];
end

T=[];
for i=1:18
    for t=2
    c=corr(S(51:100,t),PH(1:50,i));
            T=[T;c];
end
end
T=reshape(T,18,7)'

for i=1:200
    [h p]=ttest2(IM(1:50,i),IM(51:100,i));
P=[P,p];
end
P=mafdr(P,'BHFDR',true);
P(P>0.05)=0;
P=P';
a=find(P==0);
