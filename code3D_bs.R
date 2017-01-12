# HISTORY

# 01092015 - fixed bug on vector "vec". Index k was reaching value 0

library(ks);
library(MASS);

#mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
mydata <- read.table("/home/diana/workspace/data/dataset-add-2/expression5.dat", header=FALSE);

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
# Set the prefix of the pdf file
label<-as.character(args[5]);
# Set the group for cross validation
group<-as.numeric(args[6]);
# Fraction of dataset 
frac <- as.numeric(args[7]);

# random seed
myseed=15

# binned
BinTrue=F
BinHpiTrue=T

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
print(nrow(data));
print(args);

if(group>0){
# Here I introduce a selection of the 80% of the data for cross validation purposes.
# Set the random seed
	set.seed(group);
	data <- data[ runif(n=nrow(data))>0.2,];
}
set.seed(myseed);
tokeep <- sample(1:nrow(data));
data<-data[ tokeep[1:floor(nrow(data)*frac)],];
#H3d<-Hpi.diag(x=data);
#H3d<-Hpi(x=data);
H3d<-Hlscv(x=data);

fhat<-kde(x=data,H=H3d,xmin=c(minADF,minASI,minNSM),xmax=c(maxADF,maxASI,maxNSM),binned=BinTrue,bgridsize=c(GS,GS,GS),gridsize=GS);

joint=fhat$estimate/sum(fhat$estimate)

## The command "image()" shows the transpose of the matrix.

vec<-vector(mode="numeric",length=GS*GS*GS);
for(i in 1:GS){
	for(j in 1:GS){
		for(k in 1:GS){
			vec[GS*GS*(i-1)+GS*(j-1)+k]=joint[i,j,k]
		}
	}
}

write.table(vec,paste(OutFolder,"/",label,"_",GT,"_",Food,"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
#
