library(ks);

mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
#mydata <- read.table("/home/diana/workspace/data/dataset-add-2/expression5.dat", header=FALSE);

# Parameters:
args<-commandArgs(trailingOnly = TRUE);
# Grid size
GS=as.numeric(args[2])
# output folder
OutFolder=as.character(args[3])
# Binned
BinTrue=TRUE

data0 <- subset(mydata, V4==6);
# Make grid
names(data0)<-c("B","BD","GT","Day","F2","T2","ADF","ASI","NSM");
minADF=min(data0$ADF)/1e6;
maxADF=max(data0$ADF)/1e6;
minASI=min(data0$ASI)/1e6;
maxASI=max(data0$ASI)/1e6;
minNSM=min(data0$NSM)/1e6;
maxNSM=max(data0$NSM)/1e6;

batchlist=readLines(paste(args[1],".txt",sep=""));

data12 <- subset(data0,B %in% batchlist,select = c("ADF","ASI"))/1e6;
print(paste("N =",nrow(data12)));
H12<-Hpi.diag(x=data12,binned=BinTrue);
fhat12<-kde(x=data12,H=H12,xmin=c(minADF,minASI),xmax=c(maxADF,maxASI),bgridsize=c(GS,GS),binned=BinTrue);

data13 <- subset(data0,B %in% batchlist,select = c("ADF","NSM"))/1e6;
H13<-Hpi.diag(x=data13,binned=BinTrue);
fhat13<-kde(x=data13,H=H13,xmin=c(minADF,minNSM),xmax=c(maxADF,maxNSM),bgridsize=c(GS,GS),binned=BinTrue);

data23 <- subset(data0,B %in% batchlist,select = c("ASI","NSM"))/1e6;
H23<-Hpi.diag(x=data23,binned=BinTrue);
fhat23<-kde(x=data23,H=H23,xmin=c(minASI,minNSM),xmax=c(maxASI,maxNSM),bgridsize=c(GS,GS),binned=BinTrue);

UnitSurf12=(maxADF-minADF)/GS*(maxASI-minASI)/GS;
UnitSurf13=(maxADF-minADF)/GS*(maxNSM-minNSM)/GS;
UnitSurf23=(maxASI-minASI)/GS*(maxNSM-minNSM)/GS;

joint12=fhat12$estimate*UnitSurf12;
joint13=fhat13$estimate*UnitSurf13;
joint23=fhat23$estimate*UnitSurf23;

write.table(joint12,paste(OutFolder,"/pdf12_",args[1],"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
write.table(joint13,paste(OutFolder,"/pdf13_",args[1],"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
write.table(joint23,paste(OutFolder,"/pdf23_",args[1],"_GS",GS,".dat",sep=""),col.names=F,row.names=F);
