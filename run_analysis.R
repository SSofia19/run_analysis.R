## Install libraries needed
library(dplyr)
library(data.table)

##Get data
if(!file.exists("./data")){dir.create("./data")}
fileUrl<- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/coursera.zip")
unzip(zipfile="./data/coursera.zip", exdir="./data")

##Read out the Test data:
activityTest<- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=F)
featuresTest<-read.table("./data/UCI HAR Dataset/test/x_test.txt", header=F)
subjectTest<- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=F)

##Read out Train data:
activityTrain<- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=F)
featuresTrain<- read.table("./data/UCI HAR Dataset/train/x_train.txt", header=F)
subjectTrain<- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Begin merging Training and test data

subject<- rbind(subjectTest, subjectTrain)
features<- rbind(featuresTrain, featuresTest)
activity<- rbind(activityTrain, activityTest) 

## Read data table labels

featureNames <- read.table("./data/UCI HAR Dataset/features.txt")

## Use above header information to label the newly merged tables
featureNames<- select(featureNames, V2)
colnames(features)<- t(featureNames)
colnames(activity)<- "Activity"
colnames(subject)<- "Subject"

## Merge together all tables into one dataset
complete <- cbind(features,activity,subject)

## Extract only the measurements of mean and standard deviation
subMeanComplete<- complete[,grep("mean", colnames(complete))]
subStdComplete<-complete[, grep("std", colnames(complete))]

## Combine mean, standard deviation, activity and subject
subMeanStd<- cbind( activity, subject, subStdComplete, subMeanComplete)

## Rename the values in the Activity column from numeric to variable names given in the activity labels

for (i in 1:10299) {
    if (subMeanStd[i,1] == 1 ){
      subMeanStd[i,1] <- "WALKING"
    }
    else if (subMeanStd[i,1] == 2){
      subMeanStd[i,1] <- "WALKING_UPSTAIRS"
    }
    else if (subMeanStd[i,1] == 3){
      subMeanStd[i,1] <- "WALKING_DOWNSTAIRS"
    }
    else if (subMeanStd[i,1] == 4){
      subMeanStd[i,1] <- "SITTING"
    }
    else if (subMeanStd[i,1] == 5 ){
      subMeanStd[i,1] <- "STANDING"
    }
    else {
      subMeanStd [i,1]<- "LAYING"
    }
  }


## Adjust names in columns to give clearer descriptions

names(subMeanStd)<-gsub("Acc", "Accelerometer", names(subMeanStd))
names(subMeanStd)<-gsub("BodyBody", "Body", names(subMeanStd))
names(subMeanStd)<-gsub("Gyro", "Gyroscope", names(subMeanStd))
names(subMeanStd)<-gsub("Mag", "Magnitude", names(subMeanStd))
names(subMeanStd)<-gsub("tBody", "TimeBody", names(subMeanStd))
names(subMeanStd)<-gsub("-mean", "Mean", names(subMeanStd))
names(subMeanStd)<-gsub("-std", "STD", names(subMeanStd))
names(subMeanStd)<-gsub("-mean", "Mean", names(subMeanStd))
names(subMeanStd)<-gsub("^t", "Time", names(subMeanStd))
names(subMeanStd)<-gsub("^f", "Frequency", names(subMeanStd))
names(subMeanStd)<-gsub("Freq", "Frequency", names(subMeanStd))

## Make data tables tidy by giving average for each activity per subject
subMeanStd$Subject <- as.factor(subMeanStd$Subject)
tidyData <- aggregate(. ~Subject + Activity, subMeanStd, mean)

##Order tidyData for easier viewing
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)