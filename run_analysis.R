# Created Assignment directory
if(!file.exists("/Users/Sumana/Assignment"))
{dir.create("/Users/Sumana/Assignment")}

#download the file in Assignment Directory
aURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(aURL, destfile = "/Users/Sumana/Assignment/Dataset.zip")

#Unzip the downloaded File
unzip(zipfile = "/Users/Sumana/Assignment/Dataset.zip", exdir = "/Users/Sumana/Assignment")

# Reading Training tables
x_train <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/train/subject_train.txt")

#Reading Testing Tables
x_test <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/test/subject_test.txt")

#Reading features vector
features <- read.table("/Users/Sumana/Assignment/UCI HAR Dataset/features.txt")

#Reading activity labels
activityLabels = read.table("/Users/Sumana/Assignment/UCI HAR Dataset/activity_labels.txt")

#Assigning column names
#From Training  
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

#From Test
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
#Activity Labels
colnames(activityLabels) <- c('activityId','activityType')

# Merge Train and Test data in one set
mrg_train <- cbind(y_train,subject_train,x_train)
mrg_test <- cbind(y_test,subject_test,x_test)
setAllInOne <- rbind(mrg_train,mrg_test)

#Extracting only the measurements on the mean and standard deviation for each measurement
#Reading column names
colnames <- colnames(setAllInOne)

#Create Vector for definingID, mean and standard deviation
meanStd <- (grepl("activityId", colnames) |
            grepl("subjectId", colnames) |
            grepl("mean..", colnames) |
            grepl("std..", colnames)  
            )

#Making subset from setAllInOne
setForMeanStd <- setAllInOne[, meanStd == TRUE]

#Uses descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanStd, activityLabels, by='activityId', all.x = TRUE)

#Appropriately labels the data set with descriptive variable names.
#creates a second, independent tidy data set with the average of each variable for each activity and each subject
secondTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId,secondTidySet$activityId),]

#Writing second tidy set in a text file
write.table(secondTidySet, "secondTidySet.txt", row.names = FALSE)

