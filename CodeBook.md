# Code book

This is a summary of data, transformations and variables done for the last assignment in the Coursera course *Getting and cleaning data*.

The ReadMe file contains more information about the assignment.

## Data
The data stems from a study (*Human Activity Recognition Using Smartphones*) by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. See links for further information.

Experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

#### For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

See links for further information.

#### Links
[Study performed at ICS UCI EDU](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[Raw data from study](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Transformations: from raw data to tidy data

The following steps have been taken to create a tidy data set:

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

"[Course3Week4ProjectAnalysis.R](https://github.com/GuruKanzler/GettingAndCleaningDataCourseProject/blob/master/Course3Week4ProjectAnalysis.R)" contains the code that do above steps.

### Variables in tidy data set

* [Activity]  (Type of activity; WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* [Subject] (Id of studied subject; 1:30)
* [MeanOf...] ("..." refers to a mean of each of all the measurement variables)

See links above for further information about what those measurements are, but basically they cover time and frequency domain accelerations in XYZ directions, together with a range of statistics (like mean, max, std, etc) of each type of measurement.

## Output data

The transformed data is stored in a space-separated file named "[SensorData_Mean_by_Activity_and_Subject.txt](https://github.com/GuruKanzler/GettingAndCleaningDataCourseProject/blob/master/SensorData_Mean_by_Activity_and_Subject.txt)".


