## Download the dataset
filename <- "assignmentmod3.zip"
if (!file.exists(filename)){
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, destfile = filename)
    unzip(filename)
} 

## Unzip the dataset
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

## Extract the different data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge the related data (merge all in one dataset later)
full_obs <- rbind(x_test,x_train)
full_activities <- rbind(y_test,y_train)
full_subjects <- rbind(subject_test,subject_train)

## Capture the features for mean and standard deviation
selected_features <- grep(".*mean\\(\\).*|.*std\\(\\).*",features$V2)
# And their names
selected_features_names <- features[selected_features,2]

## Extract the features from our data
selected_full_obs <- full_obs[,selected_features]

## Make the variables names descriptive and readable for observations
selected_features_names = gsub('-mean\\(\\)', '_Mean', selected_features_names)
selected_features_names = gsub('-std\\(\\)', '_Std', selected_features_names)
selected_features_names = gsub('-', '_', selected_features_names)
selected_features_names = gsub('^t', 'time_', selected_features_names)
selected_features_names = gsub('^f', 'frequency_', selected_features_names)
# Assign the feature names
names(selected_full_obs) <- selected_features_names

## Make the variable name descriptive for activities observed
names(full_activities) <- "activity"

## Make the activity names descriptive and readable
full_activities[, 1] <- activity_labels[full_activities[, 1], 2]

## Make the variable name descriptive for subject observed
names(full_subjects) <- "subject"

## Merge everyhting in one dataset
my_dataset <- cbind(full_subjects,full_activities,selected_full_obs)

## Create a second data set with 
## the average of each variable for each activity and each subject.
my_dataset_summarized <- ddply(my_dataset, .(activity, subject), function(x) colMeans(x[,3:68]))

## Write the text file to export
write.table(my_dataset_summarized, file = "my_dataset_summarized.txt",row.name=FALSE)
