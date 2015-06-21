##Part 1
## Install libraries needed
library(dplyr)
library(data.table)

##Get data
if(!file.exists("./data")){dir.create("./data")}

  fileUrl<- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile="./data/coursera.zip")
  unzip(zipfile="./data/coursera.zip", exdir="./data")



##Read out the Activity train and test data, merge data, and label data:
activityTest<- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=F)
activityTrain<- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=F)
activity<- rbind(activityTest, activityTrain)
activityLabels<- read.table("./data/UCI HAR Dataset/activity_labels.txt")
mergedActivity <- merge(activity, activityLabels, by.x = "V1", by.y = "V1", sort=F)
colnames(mergedActivity) <- c("ActivityCode", "ActivityDescription")

##Read out featues test and train data, merge data, and label data:
featuresTest<-read.table("./data/UCI HAR Dataset/test/x_test.txt", header=F)
featuresTrain<- read.table("./data/UCI HAR Dataset/train/x_train.txt", header=F)
features<- rbind(featuresTest, featuresTrain)
featuresTxt<- read.table("./data/UCI HAR Dataset/features.txt")
colnames(features) <- t(select(featuresTxt, V2))

##Read out subject test and train data, and merge data
subjectTest<- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=F)
subjectTrain<- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject<- rbind(subjectTest, subjectTrain)
colnames(subject) <- "Subject"

## Merge all tables to one data set
complete <- cbind(subject, mergedActivity, features)

## Part 2 Extract only the measurements on the mean and standard deviation
## for each measurement
subcomplete<-  complete[,grep("mean"|"std", colnames(complete), ignore.case=TRUE)]

##Part 3 Add back descriptive activity name
subcomplete2<- cbind(subject, mergedActivity, subcomplete)

##Part 4 Alter column names to be readable
names(subcomplete2) <-gsub("Freq", "Frequency", names(subcomplete2))
names(subcomplete2) <-gsub("^t", "Time", names(subcomplete2))
names(subcomplete2) <-gsub("^f", "Frequency", names(subcomplete2))
names(subcomplete2) <-gsub("Acc", "Accelerometer", names(subcomplete2))
names(subcomplete2) <-gsub("-mean", "Mean", names(subcomplete2))
names(subcomplete2) <-gsub("Gyro", "Gyroscope", names(subcomplete2))
names(subcomplete2) <-gsub("-std", "STD", names(subcomplete2))
names(subcomplete2) <-gsub("Mag", "Magnitude", names(subcomplete2))
names(subcomplete2) <-gsub("BodyBody", "Body", names(subcomplete2))
names(subcomplete2) <-gsub("tBody", "TimeBody", names(subcomplete2))
names(subcomplete2) <-gsub("BodyBody", "Body", names(subcomplete2))
names(subcomplete2) <-gsub("-", "", names(subcomplete2))

##Part 5  Average each column by the subjects activity
subcomplete2$Subject<- as.factor(subcomplete2$Subject)

tidyData<-aggregate(.~Subject +ActivityCode, subcomplete2, mean)
tidyData<-arrange(tidyData, Subject)
tidyData<- tidyData[, -3]
write.table(tidyData, file= "Tidy.txt", row.names=FALSE)