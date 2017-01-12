# HISTORY


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
nn<-as.numeric(args[8])

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
	set.seed(10);
# Take a permutation of the data INDEX
	perm <- sample(1:nrow(data));
# Calculate the size of each group
	partsize <- floor(nrow(data)/5);
# split the index permutation into 5 groups
	indlist <- split(perm,ceiling(1:nrow(data)/partsize));
	tokeep <- ! 1:nrow(data) %in% indlist[[group]];
	data <- data[ tokeep,];
}
set.seed(10);
tokeep <- sample(1:nrow(data));
data<-data[ tokeep[1:floor(nrow(data)*frac)],];

eval.points<-expand.grid(list(seq(minADF,maxADF,length=GS),
			      seq(minASI,maxASI,length=GS),
			      seq(minNSM,maxNSM,length=GS)));

vec<-vector(mode="numeric",length=GS*GS*GS);
norm=0;
tmp<-matrix(ncol=3,nrow=nrow(data));

for(i in 1:(GS^3)){
	for(j in 1:nrow(data)){
		for(k in 1:3) tmp[j,k]<-as.vector(data[j,k]-eval.points[i,k]);
	}

	di<-apply(tmp^2,1,sum);
	j=0; while(j<nn){
		ind<-which.min(di);
		rad<-sqrt(di[ind]);
		di<-di[-ind];
		j=j+1;
	}
	vec[i]=1/rad^3;
	norm=norm+vec[i];
}

for(i in 1:(GS^3)) vec[i]=vec[i]/norm;

write.table(vec,paste(OutFolder,"/",label,"_",GT,"_",Food,"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
#
