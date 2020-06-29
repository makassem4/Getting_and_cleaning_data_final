library(dplyr)
filename<- "getdata_projectfiles_UCI HAR Dataset.zip"

#Download Dataset
#Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
#Checking if folder exists
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

#Assigning data frames
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))

#Merging the two datasets
X<- rbind(x_train,x_test)
Y<- rbind(y_train,y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Dataset <- cbind(X,Y,Subject)

#Extracting the measurements on the mean and sd for each
Tidy_Data <- Merged_Dataset %>%
  select(subject,code,contains("mean"),contains("std"))

#Using descriptive activity names to name the activities dataset
Tidy_Data$code <- activities[Tidy_Data$code,2]

#Labeling the data set with descriptive variable names
names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

#Creates a tidy data set with the average of each variable for each activity and
#each subject
FinalData <- Tidy_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
FinalData
