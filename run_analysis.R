# Set workspace
setwd("/Users/forestray/Desktop/Cousera/Getting&CleaningData//UCI HAR Dataset")

# Clean up workspace
rm(list=ls())

# Load required packages
library(plyr)
library(knitr)

# Load data 
testFeatures <- read.table("./test//X_test.txt")
testActivities <- read.table("./test//y_test.txt")
testSubjects <- read.table("./test/subject_test.txt")

trainFeatures <- read.table("./train//X_train.txt")
trainActivities <- read.table("./train//y_train.txt")
trainSubjects <- read.table("./train/subject_train.txt")

# Load features & activities
features <- read.table("./features.txt")[,2]
activities <- read.table("./activity_labels.txt")
names(activities) <- c("ID", "Activity")

# Merge training and test data sets, labeling column names
Features <- rbind(testFeatures, trainFeatures)
colnames(Features) <- t(features)

Activities <- rbind(testActivities, trainActivities)
colnames(Activities) <- c("Activity")

Subjects <- rbind(testSubjects, trainSubjects)
colnames(Subjects) <- c("Subject")

dataMerged <- cbind(Subjects, Features, Activities)

# Extract only the measurements on the mean and std for each measurement.
extract_features <- grepl("mean|std", features)
dataMerged <- dataMerged[,extract_features]

# Use descriptive activity names to name the activities in the data set
dataMerged[, 81] = activities[dataMerged[, 81], 2]

# Appropriately label the data set with descriptive variable names. 
names(dataMerged) <- gsub("^t", "Time", names(dataMerged))
names(dataMerged) <- gsub("Acc", "Accelerometer", names(dataMerged))
names(dataMerged) <- gsub("Gyro", "Gyroscope", names(dataMerged))
names(dataMerged) <- gsub("^f", "Frequency", names(dataMerged))
names(dataMerged) <- gsub("Mag", "Magnitude", names(dataMerged))
names(dataMerged) <- gsub("BodyBody", "Body", names(dataMerged))

# From the data set in step 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
tidy <- aggregate(. ~Subject + Activity, dataMerged, mean) 
tidy <- tidy[order(tidy$Subject, tidy$Activity),]
write.table(tidy, file="tidyData.txt", row.name=FALSE, sep="/t")
