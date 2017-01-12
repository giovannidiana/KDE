library(ks);

mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
#mydata <- read.table("/home/diana/workspace/data/dataset-add-2/expression5.dat", header=FALSE);

# Parameters:
args<-commandArgs(trailingOnly = TRUE);
# Genotype
GT=as.character(args[1]);
# Food level
Food=as.numeric(args[2]);
# Temperature
T2="20"
# Grid size
GS=as.numeric(args[3])
# Folder output
OutFolder=as.character(args[4])
# binned
BinTrue=TRUE
BinHpiTrue=FALSE

data0 <- subset(mydata,V3==GT & V6==T2 & V4==6);
print(nrow(data0))
# Make grid
names(data0)<-c("B","BD","GT","Day","F2","T2","ADF","ASI","NSM");
minADF=min(data0$ADF)/1e6;
maxADF=max(data0$ADF)/1e6;
minASI=min(data0$ASI)/1e6;
maxASI=max(data0$ASI)/1e6;
minNSM=min(data0$NSM)/1e6;
maxNSM=max(data0$NSM)/1e6;

data12 <- subset(data0,(F2==Food|Food==0),select = c("ADF","ASI"))/1e6;
print(nrow(data12))
H12<-Hpi.diag(x=data12,binned=BinHpiTrue);
fhat12<-kde(x=data12,H=H12,xmin=c(minADF,minASI),xmax=c(maxADF,maxASI),binned=BinTrue,bgridsize=c(GS,GS),gridsize=GS);

data13 <- subset(data0,(F2==Food|Food==0),select = c("ADF","NSM"))/1e6;
H13<-Hpi.diag(x=data13,binned=BinHpiTrue);
fhat13<-kde(x=data13,H=H13,xmin=c(minADF,minNSM),xmax=c(maxADF,maxNSM),binned=BinTrue,bgridsize=c(GS,GS),gridsize=GS);

data23 <- subset(data0,(F2==Food|Food==0),select = c("ASI","NSM"))/1e6;
H23<-Hpi.diag(x=data23,binned=BinHpiTrue);
fhat23<-kde(x=data23,H=H23,xmin=c(minASI,minNSM),xmax=c(maxASI,maxNSM),binned=BinTrue,bgridsize=c(GS,GS),gridsize=GS);

nbin=GS

UnitSurf12=(maxADF-minADF)/nbin*(maxASI-minASI)/nbin;
UnitSurf13=(maxADF-minADF)/nbin*(maxNSM-minNSM)/nbin;
UnitSurf23=(maxASI-minASI)/nbin*(maxNSM-minNSM)/nbin;

#joint12=fhat12$estimate*UnitSurf12
#joint13=fhat13$estimate*UnitSurf13
#joint23=fhat23$estimate*UnitSurf23

joint12=fhat12$estimate/sum(fhat12$estimate)
joint13=fhat13$estimate/sum(fhat13$estimate)
joint23=fhat23$estimate/sum(fhat23$estimate)

## The command "image()" shows the transpose of the matrix.

write.table(joint12,paste(OutFolder,"/pdf12_",GT,"_",Food,"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
write.table(joint13,paste(OutFolder,"/pdf13_",GT,"_",Food,"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
write.table(joint23,paste(OutFolder,"/pdf23_",GT,"_",Food,"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
#
