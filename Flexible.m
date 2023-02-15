function [HB_std,Fre,W_fle,In,Se,In_time,Se_time] = Flexible(HB,TR)
%%============================standard variance
HB_std=std(HB);
%%============================strength
In=mean(HB(find(HB>0)));
Se=mean(HB(find(HB<0)));
%%============================time
In_time=length(find(HB>=0))/122;
Se_time=length(find(HB<0))/122;
%%================================weighted flexibility
Q=[0];
W_HB=HB;
for i=1:length(HB)-1
    if(HB(i)*HB(i+1)<=0)
       Q=[Q;i+1]; 
    end
end
if(HB(end-1)*HB(end)<=0)
   Q=[Q;length(HB)];
end
for j=1:length(Q)-1
    W_HB(Q(j)+1:Q(j+1))=mean(HB(Q(j)+1:Q(j+1)));
end
if(Q(end)~=length(HB))
   W_HB(Q(end)+1:end)=mean(HB(Q(end)+1:end));
end
W_fle=std(W_HB);
%%============================transition frequency
HB(HB<0)=-1;
HB(HB>0)=1;
Fre=length(find(abs(diff(HB))>0))/122;
end