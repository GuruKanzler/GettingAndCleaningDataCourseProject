# Assigment description for last week in Coursera course: Getting and cleaning data.

# The purpose of this project is to demonstrate your ability to collect, work with, and
# clean a data set. The goal is to prepare tidy data that can be used for later analysis.
# You will be graded by your peers on a series of yes/no questions related to the
# project. You will be required to submit: 1) a tidy data set as described below, 2) a
# link to a Github repository with your script for performing the analysis, and 3) a
# code book that describes the variables, the data, and any transformations or work that
# you performed to clean up the data called CodeBook.md. You should also include a
# README.md in the repo with your scripts. This repo explains how all of the scripts
# work and how they are connected.
#
# One of the most exciting areas in all of data science right now is wearable computing -
# see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing
# to develop the most advanced algorithms to attract new users. The data linked to from
# the course website represent data collected from the accelerometers from the Samsung
# Galaxy S smartphone. A full description is available at the site where the data was
# obtained:
#
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Here are the data for the project:
#
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# You should create one R script called run_analysis.R that does the following.
#
# 1)    Merges the training and the test sets to create one data set.
# 2)    Extracts only the measurements on the mean and standard deviation for each measurement.
# 3)    Uses descriptive activity names to name the activities in the data set
# 4)    Appropriately labels the data set with descriptive variable names.
# 5)    From the data set in step 4, creates a second, independent tidy data set with the
#       average of each variable for each activity and each subject.


#############################################################################################
# Preparations
#############################################################################################

# Packages needed
library(data.table)
library(plyr)

# Create function used for last part of script. It adds the second argument as a 
# prefix to the first argument.
addPrefix <-    function(names, prefix) {
        if (!(names %in% c("Subject", "Activity"))) {
                paste(prefix, names, sep = "")
        }
        else {
                names
        }
}

# Create a destination folder for downloaded data if it doesn't already exists.
if (!file.exists("./data")) {
        dir.create("./data")
}

# Variables to make for a bit more readable code for downloading and extracting data
folder <- file.path(getwd(), "data")
url <-
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(folder, "UCI HAR Dataset.zip")

# Download and unzip data
if (!file.exists(f)) {
        download.file(url, f, mode = "wb")
        unzip(f, exdir = folder)
}


# Store some file paths
fpath           <- file.path(folder, "UCI HAR Dataset")
fptrain         <- file.path(fpath, "train")
fptest          <- file.path(fpath, "test")


# Load data sets for train and test
xtrain          <- read.table(file.path(fptrain, "X_train.txt"))
ytrain          <- read.table(file.path(fptrain, "Y_train.txt"))
subjecttrain    <- read.table(file.path(fptrain, "subject_train.txt"))

xtest           <- read.table(file.path(fptest, "X_test.txt"))
ytest           <- read.table(file.path(fptest, "Y_test.txt"))
subjecttest     <- read.table(file.path(fptest, "subject_test.txt"))


# Load activity labels
activitylabels  <-
        read.table(file.path(fpath, "activity_labels.txt"),
                   col.names = c("Id", "Activity"))

# Load features labels
featurelabels   <-
        read.table(file.path(fpath, "features.txt"), colClasses = c("character"))




#############################################################################################
# Tasks and solutions


# 1)    Merges the training and the test sets to create one data set.
#       Merge trainig and test data sets
train           <- cbind(xtrain, subjecttrain, ytrain)
test            <- cbind(xtest, subjecttest, ytest)
sensordata      <- rbind(train, test)

names(sensordata) <-
        rbind(rbind(featurelabels, c(562, "Subject"), c(563, "Id")))[, 2]


# 2)    Extracts only the measurements on the mean and standard deviation for each measurement.
#       subset data: keep mean and std measurements. (and subject/Id)
sensordataMeanStd <-
        sensordata[, grepl("mean|std|Subject|Id", names(sensordata))]


# 3)    Uses descriptive activity names to name the activities in the data set
#       Join in the names of the activities that the "Id" refers to.
sensordataMeanStd <-
        join(sensordataMeanStd,
             activitylabels,
             by = "Id",
             match = "first")
sensordataMeanStd <- sensordataMeanStd[, -1]


# 4)    Appropriately labels the data set with descriptive variable names.
#       Normalize names by removing parenthasises and following the norm of how variables
#       should be named in the R community.
names(sensordataMeanStd) <-
        gsub("([()])", "", names(sensordataMeanStd))
names(sensordataMeanStd) <- make.names(names(sensordataMeanStd))


# 5)    From the data set in step 4, creates a second, independent tidy data set with the
#       average of each variable for each activity and each subject.

SensorData_Mean_by_Activity_and_Subject <-
        ddply(sensordataMeanStd, c("Activity", "Subject"), numcolwise(mean))


# Add prefix to variable names
names(SensorData_Mean_by_Activity_and_Subject) <-
        sapply(names(SensorData_Mean_by_Activity_and_Subject),
               addPrefix,
               prefix = "MeanOf.")

# Output data set to file.
write.table(
        SensorData_Mean_by_Activity_and_Subject,
        file = file.path(fpath, "SensorData_Mean_by_Activity_and_Subject.txt"),
        row.name = FALSE
)
