library(ks)

mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
GT="QL196"
Food=1.10e+10
T2=20
GS=30

BinTrue=TRUE
BinHpiTrue=TRUE
data0 <- subset(mydata,V3==GT & V6==T2 & V4==6);
names(data0)<-c("B","BD","GT","Day","F2","T2","ADF","ASI","NSM");
minADF=min(data0$ADF)/1e6;
maxADF=max(data0$ADF)/1e6;
minASI=min(data0$ASI)/1e6;
maxASI=max(data0$ASI)/1e6;
minNSM=min(data0$NSM)/1e6;
maxNSM=max(data0$NSM)/1e6;

data <- subset(data0,(F2==Food|Food==0),select = c("ADF","ASI","NSM"))/1e6;
H3d<-Hpi.diag(x=data);
fhat<-kde(x=data,H=H3d,xmin=c(minADF,minASI,minNSM),xmax=c(maxADF,maxASI,maxNSM),binned=BinTrue,bgridsize=c(GS,GS,GS),gridsize=GS);

data1 <- subset(data0,(F2==Food|Food==0),select = c("ADF"))/1e6;
print(nrow(data1))
H1<-dpik(x=data1$ADF,range.x=c(minADF,maxADF),gridsize=GS);
fhat1<-bkde(x=data1$ADF,bandwidth=H1,range.x=c(minADF,maxADF),gridsize=GS);

data2 <- subset(data0,(F2==Food|Food==0),select = c("ASI"))/1e6;
H2<-dpik(x=data2$ASI,range.x=c(minASI,maxASI),gridsize=GS);
fhat2<-bkde(x=data2$ASI,bandwidth=H2,range.x=c(minASI,maxASI),gridsize=GS);

data3 <- subset(data0,(F2==Food|Food==0),select = c("NSM"))/1e6;
H3<-dpik(x=data3$NSM,range.x=c(minNSM,maxNSM),gridsize=GS);
fhat3<-bkde(x=data3$NSM,bandwidth=H3,range.x=c(minNSM,maxNSM),gridsize=GS);



plot(

