library(ggplot2)
library(ggdendro)
library(ggridges)
library(Hmisc)

mydata<-read.table("D:/desktop/SCH93/d_deg.csv", sep = ",",header = T)
data<-as.data.frame(scale(mydata[,2:205])) 
sex<-mydata$sex[]
data<-cbind(data,sex)
coeff_output <- matrix("double",200,3)
for (i in 1:200)                 
{  
      y<-lm(data[,i+4]~sans+saps+I(sans*saps)+age+FD+sex,data)
      dat<-summary(y)
      coeff_output[i,]=dat$coefficients[2:4,1]
}
r<-rcorr(coeff_output[,1:2])
r$r
r$P

write.csv(coeff_output,file="D:/desktop/SCH93/effect_d_pc.csv")
coeff<-apply(coeff_output[,1:2],2,as.numeric)

pca1<-princomp(coeff,cor=T,scores=T)

r<-rcorr(pca1$scores[,1],coeff_output[,1:2])
r$r
r$P

write.csv(pca1$scores[,1],file="D:/desktop/SCH93/effect_pca_d_pc.csv")

------------------------------------------------------------------------
library(ggplot2)
library(ggdendro)
library(ggridges)
library(Hmisc)

coeff_output <-read.table("D:/desktop/SCH93/effect_deg.csv", sep = ",",header = T)
coeff_output <- as.matrix(coeff_output)
coeff<-apply(coeff_output[,2:3],2,as.numeric)

pca1<-princomp(coeff,cor=T,scores=T)

r<-rcorr(pca1$scores[,1],coeff_output[,2:3])
r$r
r$P

write.csv(pca1$scores[,1],file="D:/desktop/effect_pca_pd.csv")

install.packages("installr")
require(installr)
updateR()