library(mvtnorm);
library(ks);
library(MASS);

#mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
mydata <- read.table("/home/diana/workspace/data/dataset-add-2/expression5.dat", header=FALSE);

# Parameters:
args<-commandArgs(trailingOnly = TRUE);
# Genotype
GT="QL196"
# Temperature
T2="20"
# Grid size
GS=30
# Folder output

flist=c("1", "2e+07", "6.3e+07", "6.3e+08", "2e+09", "1.1e+10"); 
set.seed(args[1])

data0 <- subset(mydata,V3==GT & V6==T2 & V4==6);
# Make grid
names(data0)<-c("B","BD","GT","Day","F2","T2","ADF","ASI","NSM");
data <- subset(data0,F2==2.00e+09,select = c("NSM","ASI","ADF"))/1e6;
## Here I calculate the mean and covariance matrix
S=cov(data)
data_random=data.frame(rmvnorm(mean=apply(data,2,mean),sigma=S,n=200*6));
names(data_random)=c("ADF","ASI","NSM");
minADF=min(data_random$ADF);
maxADF=max(data_random$ADF);
minASI=min(data_random$ASI);
maxASI=max(data_random$ASI);
minNSM=min(data_random$NSM);
maxNSM=max(data_random$NSM);

for(f in 0:5) {
	
	H3d<-Hpi(x=data_random[1:200+f*200,]);

	fhat<-kde(x=data_random[1:200+f*200,],H=H3d,xmin=c(minADF,minASI,minNSM),xmax=c(maxADF,maxASI,maxNSM),binned=F,bgridsize=c(GS,GS,GS),gridsize=GS);
	
	joint=fhat$estimate/sum(fhat$estimate)

    vec<-vector(mode="numeric",length=GS*GS*GS);
	for(i in 1:GS){
		for(j in 1:GS){
			for(k in 1:GS){
				vec[GS*GS*(i-1)+GS*(j-1)+k]=joint[i,j,k]
			}
		}
	}

## The command "image()" shows the transpose of the matrix.
   write.table(vec,paste("/home/diana/workspace/Analysis/R_projects/pdf3D_infosample/fake_QL196_",flist[f+1],"_GS30_group0.dat",sep=""),col.names=F,row.names=F);
}
#
