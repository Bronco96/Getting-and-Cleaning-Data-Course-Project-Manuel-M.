features <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activitylabel <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
train <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
test <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
trainsubject <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
testsubject <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
testlabel <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/test/y_test.txt", col.names = "code")
trainlabel <- read.table("~/Documents/Forecasting R/3 Getting and Cleaning Data 19hr/Week 4/UCI HAR Dataset/train/y_train.txt", col.names = "code")


#30 volunteers
#each performed 6 activities
#30% test 70% train
#captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz

library(dplyr)

# You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.

names(train)
names(test)
All <- rbind(train, test)
Labels <- rbind(trainlabel, testlabel)
Subjects <- rbind(trainsubject, testsubject)
Merged <- cbind(Subjects, Labels, All)
View(Merged)

#Extracts only the measurements on the mean and standard deviation for each measurement.

dataset <- select(Merged, subject, code, contains("mean"), contains("std"))

#Uses descriptive activity names to name the activities in the data set

dataset$code <- activitylabel[dataset$code, 2]

#Appropriately labels the data set with descriptive variable names.

names(dataset)[1] <- "Subject"
names(dataset)[2] <- "Activity"
names(dataset) <- gsub("Acc", "Accelerometer", names(dataset))
names(dataset) <- gsub("Gyro", "Gyroscope", names(dataset))
names(dataset) <- gsub("BodyBody", "Body", names(dataset))
names(dataset) <- gsub("Mag", "Magnitude", names(dataset))
names(dataset) <- gsub("^t", "Time", names(dataset))
names(dataset) <- gsub("^f", "Frequency", names(dataset))
names(dataset) <- gsub("tBody", "TimeBody", names(dataset))
names(dataset) <- gsub("-mean()", "Mean", names(dataset))
names(dataset) <- gsub("-std()", "STD", names(dataset))
names(dataset) <- gsub("-freq()", "Frequency", names(dataset))
names(dataset) <- gsub("angle", "Angle", names(dataset))
names(dataset) <- gsub("gravity", "Gravity", names(dataset))

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

grouped <- group_by(dataset, Subject, Activity)
summarised  <- summarise_all(grouped, funs(mean))


tidydata <- dataset %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))

write.table(tidydata, "TidyData.txt", row.names = FALSE)

#Check variable names

str(tidydata)
tidydata
View(tidydata)
