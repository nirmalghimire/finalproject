library(dplyr)
library(data.table)
library(Hmisc)

#Downloading the provided dataset
filelocation<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(filelocation,destfile="./provideddata.zip")

#unzipping the downloaded dataset
unzip(zipfile="./provideddata.zip", exdir="./finalproject3")

#1. Understanding the data files
#a. Training Data set
x_train<-read.table("./finalproject3/UCI HAR Dataset/train/x_train.txt")
y_train<-read.table("./finalproject3/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./finalproject3/UCI HAR Dataset/train/subject_train.txt")

#checking things
x_train
y_train
subject_train

#b. Test Data set
x_test <- read.table("./finalproject3/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./finalproject3/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./finalproject3/UCI HAR Dataset/test/subject_test.txt")

#checking things
x_test
y_test
subject_test

#c. Reading feature vector
features <- read.table("./finalproject3/UCI HAR Dataset/features.txt")

#checking things
features

#d. Reading provided activity labels
activity1<-read.table("./finalproject3/UCI HAR Dataset/activity_labels.txt")

#checking things
activity1

#2. Assigning Names to the variables
#a. Training variables
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

#b. Test variables
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

#c. Activity Labels
colnames(activity1) <- c("activityID", "activityType")

#checking things
colnames(x_train)
colnames(y_train)
colnames(subject_train)
colnames(x_test)
colnames(y_test)
colnames(subject_test)
colnames(activity1)

#3. Combining all dataset into one
trainall<-cbind(y_train, subject_train, x_train)
testall<-cbind(y_test, subject_test, x_test)
finalset<-rbind(trainall, testall)

#Reading columns on finalset
colmns<-colnames(finalset)

#4. Mean and SD for each measurement
mean_sd<-(grepl("activityID", colmns)|grepl("subjectID",colmns)|
            grepl("mean...",colmns)|grepl("std...",colmns))

#5. Creating required subsets
sub_mean_sd<-finalset[,mean_sd==TRUE]

#6. Using descriptive activity
ActvityNames<-merge(sub_mean_sd,activity1,
                    by="activityID",
                    all.x=TRUE)
dim(finalset)

#Creating tidy dataset
tidySet<-aggregate(. ~subjectID+activityID,ActvityNames,mean)
dim(tidySet)
tidySet<-tidySet[order(tidySet$subjectID,tidySet$activityID), ]

#writing tidy data into a text file
write.table(tidySet,"tidySet.txt",row.names=FALSE)


