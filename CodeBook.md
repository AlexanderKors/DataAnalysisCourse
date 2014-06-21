Setting working directory

<pre><code>setwd("D:/Data Science and Analysis/Course Project/Data")
</code></pre>

Obtaining features names
<pre><code>
           features<-read.table("features.txt")
           colnames(features)<-c("ID","Name")
           namesvec<-as.character(features$Name)

           library(data.table)
           library(plyr)
           library(reshape2)
</code></pre>

## Read-in a data frame activities performed by train and test groups

<pre><code>activity_test<-read.table("TEST/y_test.txt")
activity_train<-read.table("train/y_train.txt")
</code></pre>
## Getting a vector of activities names, based on their number

<pre><code>lab<-read.table("activity_labels.txt")
labels<-(lab[,2])
</code></pre>
## Combining two data frames together

<pre><code>activity<-rbind(activity_train,activity_test)
</code></pre>
## Substituting activities numbers with corresponding names

<pre><code>activity[[1]] <- factor(activity[[1]], levels=seq_along(labels), labels=labels)
</code></pre>
## Obtaining data for test group

<pre><code>x_test<-read.table("Test/x_test.txt")
x_test<-data.table(x_test)
subject_test<-fread("Test/subject_test.txt")
</code></pre>
## Obtaining data for train group

<pre><code>subject_train<-fread("Train/subject_train.txt")
x_train<-read.table("Train/x_train.txt")
x_train<-data.table(x_train)
</code></pre>
## Creating a list

<pre><code>l<-list(x_train,x_test)

DT<-data.table()
</code></pre>
## Combining the two into one data table

<pre><code>DT<-rbindlist(l)
</code></pre>
## Naming the columns of a data table 

<pre><code>colnames(DT)<-namesvec
</code></pre>
## Getting a vector of numbers od columns containing words "mean" and "std" in all their variations

<pre><code>numbers<-grep(".[Mm][Ee][Aa][Nn].|.[Ss][Tt][Dd.]",namesvec)
</code></pre>
## Subsetting the data table based on those column numbers

<pre><code>DT<-DT[,numbers, with=FALSE]
</code></pre>
## Creating a list of Subjects performing the activitites and merging it into one data table 

<pre><code>l3<-list(subject_train,subject_test)
subject<-rbindlist(l3)
</code></pre>
## Adding colums "Activity" and "Subject" to our big data table
 
<pre><code>DT[,Activity:=activity][,Subject:=subject]
</code></pre>
## Performing statistical analysis and creating a tidy data set 

<pre><code>new <- ddply(melt(DT,id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, Average=mean(value))
</code></pre>
## Writing new tidy data into file

<pre><code>write.table(new,"newdata.txt")
</code></pre>









