library(ks);

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
# Set the group for cross validation
group<-as.numeric(args[5]);

# binned
BinTrue=TRUE
BinHpiTrue=TRUE

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

data0 <- subset(data0,(F2==Food|Food==0));

if(group>0){
# Here I introduce a selection of the 80% of the data for cross validation purposes.
# Set the random seed
	set.seed(10);
# Take a permutation of the data INDEX
	perm <- sample(1:nrow(data0));
# Calculate the size of each group
	partsize <- floor(nrow(data0)/5);
# split the index permutation into 5 groups
	indlist <- split(perm,ceiling(1:nrow(data0)/partsize));
	tokeep <- ! 1:nrow(data0) %in% indlist[[group]];
	data0 <- data0[ tokeep,];
}


data1 <- subset(data0,(F2==Food|Food==0),select = c("ADF"))/1e6;
print(nrow(data0));
H1<-dpik(x=data1$ADF,range.x=c(minADF,maxADF),gridsize=GS);
fhat1<-bkde(x=data1$ADF,bandwidth=H1,range.x=c(minADF,maxADF),gridsize=GS);

data2 <- subset(data0,(F2==Food|Food==0),select = c("ASI"))/1e6;
H2<-dpik(x=data2$ASI,range.x=c(minASI,maxASI),gridsize=GS);
fhat2<-bkde(x=data2$ASI,bandwidth=H2,range.x=c(minASI,maxASI),gridsize=GS);

data3 <- subset(data0,(F2==Food|Food==0),select = c("NSM"))/1e6;
H3<-dpik(x=data3$NSM,range.x=c(minNSM,maxNSM),gridsize=GS);
fhat3<-bkde(x=data3$NSM,bandwidth=H3,range.x=c(minNSM,maxNSM),gridsize=GS);

joint1=fhat1$y/sum(fhat1$y)
joint2=fhat2$y/sum(fhat2$y)
joint3=fhat3$y/sum(fhat3$y)

## The command "image()" shows the transpose of the matrix.

write.table(joint1,paste(OutFolder,"/pdf1D1_",GT,"_",Food,"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
write.table(joint2,paste(OutFolder,"/pdf1D2_",GT,"_",Food,"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
write.table(joint3,paste(OutFolder,"/pdf1D3_",GT,"_",Food,"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
#
