## Setting working directory

setwd("D:/Data Science and Analysis/Course Project/Data")

## Obtaining features names
features<-read.table("features.txt")
colnames(features)<-c("ID","Name")
namesvec<-as.character(features$Name)

library(data.table)
library(plyr)
library(reshape2)

## Read-in a data frame activities performed by train and test groups

activity_test<-read.table("TEST/y_test.txt")
activity_train<-read.table("train/y_train.txt")

## Getting a vector of activities names, based on their number

lab<-read.table("activity_labels.txt")
labels<-(lab[,2])

## Combining two data frames together

activity<-rbind(activity_train,activity_test)

## Substituting activities numbers with corresponding names

activity[[1]] <- factor(activity[[1]], levels=seq_along(labels), labels=labels)

## Obtaining data for test group

x_test<-read.table("Test/x_test.txt")
x_test<-data.table(x_test)
subject_test<-fread("Test/subject_test.txt")

## Obtaining data for train group

subject_train<-fread("Train/subject_train.txt")
x_train<-read.table("Train/x_train.txt")
x_train<-data.table(x_train)

## Creating a list

l<-list(x_train,x_test)

DT<-data.table()

## Combining the two into one data table

DT<-rbindlist(l)

## Naming the columns of a data table 

colnames(DT)<-namesvec

## Getting a vector of numbers od columns containing words "mean" and "std" in all their variations

numbers<-grep(".[Mm][Ee][Aa][Nn].|.[Ss][Tt][Dd.]",namesvec)

## Subsetting the data table based on those column numbers

DT<-DT[,numbers, with=FALSE]

## Creating a list of Subjects performing the activitites and merging it into one data table 

l3<-list(subject_train,subject_test)
subject<-rbindlist(l3)

## Adding colums "Activity" and "Subject" to our big data table
 
DT[,Activity:=activity][,Subject:=subject]

## Performing statistical analysis and creating a tidy data set 

new <- ddply(melt(DT,id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, Average=mean(value))

## Writing new tidy data into file

write.table(new,"newdata.txt")










