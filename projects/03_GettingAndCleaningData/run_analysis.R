# Getting and Cleaning Data Course Project

# This script is to be run in the directory containing the follwoing files:
# "features_info.txt", "features.txt", "activity_labels.txt", 
# and "train" and "test" subdirectories
# 
# This script
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a tidy data set with the average of each variable for each activity and each subject. 

# This script produces 2 datasets
# 1. data.ms 
# Contains measurements on mean and standard deviation for each numeric feature and subject and activity labels
# 2. data.msa
# Contains the average of each variable for each activity and each subject
# Please see codebook.pdf for description of features names

## Acknowledgement: The dataset used is provided by
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


## Parameters (files and dirs names)
file.features <- "features.txt"
file.activity.labels <- "activity_labels.txt"

file.set.train <- "train/X_train.txt" 						# Train set
file.labels.train <- "train/y_train.txt" 					# Train labels
file.subject.train <- "train/subject_train.txt"		# Train set subjects

file.set.test <- "test/X_test.txt"						# Test set
file.labels.test <- "test/y_test.txt" 				# Test labels
file.subject.test <- "test/subject_test.txt"	# train set subjects

## Vector of features
features <- as.character(read.table(file.features, sep=" ")[, 2])
# head(features)
# str(features)

## Data frame of activity names
# Replace activity labels by descriptive activity names
# Since we use dashes ("-") in feature names, let's replace uderscores here, too
activity.labels <- read.table(file.activity.labels, sep=" ")
colnames(activity.labels) <- c("class", "label")
activity.labels$label <- tolower(activity.labels$label)
activity.labels$label <- gsub("_", "-", activity.labels$label)

## Test set
# Vector of subjects
subject.test <- as.factor(read.table(file.subject.test)[, 1])
# str(subject.test)

# Data set and labels
set.test <- read.table(file.set.test, sep="")
labels.test <- read.table(file.labels.test, sep="")
colnames(set.test) <- features
set.test$activityLabel <- activity.labels$label[labels.test$V1]
set.test$subject <- subject.test

## Train set
# Vector of subjects
subject.train <- as.factor(read.table(file.subject.train)[, 1])
# str(subject.train)

# Data set and labels
set.train <- read.table(file.set.train, sep="")
labels.train <- read.table(file.labels.train, sep="")
colnames(set.train) <- features
set.train$activityLabel <- activity.labels$label[labels.train$V1]
set.train$subject <- subject.train

## Merging test and train sets
data <- rbind(set.train, set.test)
data$activityLabel <- as.factor(data$activityLabel)
data$subject <- as.factor(paste("subject", sprintf("%02d", data$subject), sep="-")) 
# head(data$subject)

## Extract only the measurements on the mean and standard deviation for each measurement
# head(colnames(data)[grepl("mean()|std()" , colnames(data))])
data.ms <- data[, grepl("mean()|std()" , colnames(data))]
data.ms$activityLabel <- data$activityLabel
data.ms$subject <- data$subject
# str(data.ms)

## Create a second data set with the average of each variable for each activity and each subject 
# Label the columns by adding "-ave" to each transformed column name 
library(plyr)
data.msa <- ddply(data.ms, .(subject, activityLabel), numcolwise(mean))
cc <- sapply(data.msa, class)
cnum <- colnames(data.msa)[cc == "numeric"]
# cnum
colnames(data.msa) <- sapply(colnames(data.msa), function(x) ifelse(x %in% cnum, paste(x, "ave", sep="-"), x))

## Another way to do the same
# library(reshape2)
# data.melt <- melt(data.ms, id.vars = c("subject", "activityLabel"))
# data.msa2 <- dcast(data.melt, subject + activityLabel ~ ..., fun.aggregate=mean)
# colnames(data.msa2) <- sapply(colnames(data.msa2), function(x) ifelse(x %in% cnum, paste(x, "ave", sep="-"), x))
## To check that this is the same:
# identical(data.msa, data.msa2)

## Save the new dataset to file
write.table(data.msa, file="activity_subject_averages.txt", sep = "\t", row.names = F)

## Cleanup
rm(activity.labels, cc, cnum, data, data.ms, data.msa, features, file.activity.labels, file.features, file.labels.test, file.labels.train, file.set.test, file.set.train, file.subject.test, file.subject.train, labels.test, labels.train, set.test, set.train, subject.test, subject.train)
