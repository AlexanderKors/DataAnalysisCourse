setwd("D:/Data Science and Analysis/Course Project/Data")
features<-read.table("features.txt")
colnames(features)<-c("ID","Name")
namesvec<-as.character(features$Name)

library(data.table)
library(plyr)
library(reshape2)

activity_test<-read.table("TEST/y_test.txt")
activity_train<-read.table("train/y_train.txt")

lab<-read.table("activity_labels.txt")
labels<-(lab[,2])

activity<-rbind(activity_train,activity_test)

activity[[1]] <- factor(activity[[1]], levels=seq_along(labels), labels=labels)

x_test<-read.table("Test/x_test.txt")
x_test<-data.table(x_test)
subject_test<-fread("Test/subject_test.txt")

subject_train<-fread("Train/subject_train.txt")
x_train<-read.table("Train/x_train.txt")
x_train<-data.table(x_train)

l<-list(x_train,x_test)

DT<-data.table()
DT<-rbindlist(l)

colnames(DT)<-namesvec

numbers<-grep(".[Mm][Ee][Aa][Nn].|.[Ss][Tt][Dd.]",namesvec)
DT<-DT[,numbers, with=FALSE]

l3<-list(subject_train,subject_test)
subject<-rbindlist(l3)

DT[,Activity:=activity][,Subject:=subject]

new <- ddply(melt(DT,id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, Average=mean(value))

write.table(new,"newdata.txt")










