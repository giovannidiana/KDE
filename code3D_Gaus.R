library(mvtnorm);

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

# Set the multiplicative parameters alpha and beta
alpha=as.numeric(args[5])
beta=as.numeric(args[6])

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

data <- subset(data0,(F2==Food|Food==0),select = c("NSM","ASI","ADF"))/1e6;
print(nrow(data))

## Here I calculate the mean and covariance matrix
factor=cbind(c(alpha,alpha*beta,alpha*beta),c(alpha*beta,alpha,alpha*beta),c(alpha*beta,alpha*beta,alpha));
S=cov(data)*factor
if(det(S)<0) {
	print("Negative determinant!");
	exit();
}
fhat<-dmvnorm(x=expand.grid(seq(minNSM,maxNSM,length.out=GS),
			    seq(minASI,maxASI,length.out=GS),
			    seq(minADF,maxADF,length.out=GS)),
	      mean=apply(data,2,mean),
	      sigma=S);


joint=fhat/sum(fhat)

## The command "image()" shows the transpose of the matrix.

write.table(joint,paste(OutFolder,"/Gaus3D_",GT,"_",Food,"_GS",GS,"_group0.dat",sep=""),col.names=F,row.names=F);
#
