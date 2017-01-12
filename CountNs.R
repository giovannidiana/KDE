mydata <- read.table("/home/diana/workspace/data/dataset-add-2/expression5.dat", header=FALSE);

data0 <- subset(mydata,V6==T2 & V4==6);
# Make grid
names(data0)<-c("B","BD","GT","Day","F2","T2","ADF","ASI","NSM");


