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
# Random seed
seed=as.numeric(args[5])
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

data <- subset(data0,(F2==Food|Food==0),select = c("ADF","ASI","NSM"))/1e6;
set.seed(seed)
data <- cbind(ADF=sample(data$ADF),ASI=sample(data$ASI),NSM=sample(data$NSM)); 
print(nrow(data))
H3d<-Hpi.diag(x=data);
fhat<-kde(x=data,H=H3d,xmin=c(minADF,minASI,minNSM),xmax=c(maxADF,maxASI,maxNSM),binned=BinTrue,bgridsize=c(GS,GS,GS),gridsize=GS);

joint=fhat$estimate/sum(fhat$estimate)

## The command "image()" shows the transpose of the matrix.

vec<-vector(mode="numeric",length=GS*GS*GS);
for(i in 1:GS-1){
	for(j in 1:GS-1){
		for(k in 1:GS-1){
			vec[GS*GS*i+GS*j+k]=joint[i+1,j+1,k+1]
		}
	}
}

write.table(vec,paste(OutFolder,"/pdfR3D_",GT,"_",Food,"_GS",GS,"_s",seed,".dat",sep=""),col.names=F,row.names=F);
#
