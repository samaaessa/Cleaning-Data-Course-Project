library(dplyr)

# reading dataset features' name 
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#reading testset 
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#reading trainset
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merging train and test
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
all_data <- cbind(subject, y, x)


#select a specific set of columns
col_names <- names(all_data)
col_mattars <- col_names[grepl(c("mean","std"),col_names)]

#filter dataset by columns that mattars
data_mattars <- select(all_data,subject,code,col_mattars)

data_mattars$activity <- activities[data_mattars$code,2]

#Make columns' names more discriptive 
names(data_mattars)<-gsub("Acc", "Accelerometer", names(data_mattars))
names(data_mattars)<-gsub("Gyro", "Gyroscope", names(data_mattars))
names(data_mattars)<-gsub("BodyBody", "Body", names(data_mattars))
names(data_mattars)<-gsub("Mag", "Magnitude", names(data_mattars))
names(data_mattars)<-gsub("^t", "Time", names(data_mattars))
names(data_mattars)<-gsub("^f", "Frequency", names(data_mattars))
names(data_mattars)<-gsub("tBody", "TimeBody", names(data_mattars))
names(data_mattars)<-gsub("-mean()", "Mean", names(data_mattars), ignore.case = TRUE)
names(data_mattars)<-gsub("-std()", "STD", names(data_mattars), ignore.case = TRUE)
names(data_mattars)<-gsub("-freq()", "Frequency", names(data_mattars), ignore.case = TRUE)
names(data_mattars)<-gsub("angle", "Angle", names(data_mattars))
names(data_mattars)<-gsub("gravity", "Gravity", names(data_mattars))


#summurize data
tidy_data <- group_by(data_mattars,subject,activity)
final_data <- summarise_all(tidy_data,mean)

#save the result into external file
write.table(final_data, "FinalData.txt", row.name=FALSE)
