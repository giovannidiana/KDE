library(ks);

#mydata <- read.table("/home/diana/workspace/data/data-June_WT/Gfile.dat", header=FALSE);
mydata <- read.table("/home/diana/workspace/data/lifespan/lifespan-ee.dat", header=FALSE);

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

names(mydata)<-c("B","day0","genotype","Strain","t0","t1","t2",
		"TSD","f0","f1","f2","FSD",
		"egg5","FUDR","AB","age","num","ce","CAUSE");

data0 <- subset(mydata,Strain==GT & t2==T2 & t0==20 & t1==20 & TSD==2
		& f1==2.00e+09 & FSD==2 & egg5==1 & ce==0);
print(nrow(data0))
# Make grid
minLS=min(data0$age);
maxLS=max(data0$age);

data0 <- subset(data0,(f2==Food));

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


data1 <- subset(data0,(f2==Food),select = c("age"));
print(nrow(data0));
H1<-dpik(x=data1$age,range.x=c(minLS,maxLS),gridsize=GS);
fhat1<-bkde(x=data1$age,bandwidth=H1,range.x=c(minLS,maxLS),gridsize=GS);

joint1=fhat1$y/sum(fhat1$y)

## The command "image()" shows the transpose of the matrix.

write.table(joint1,paste(OutFolder,"/pdf_LS_",GT,"_",as.character(args[2]),"_GS",GS,"_group",group,".dat",sep=""),col.names=F,row.names=F);
#
