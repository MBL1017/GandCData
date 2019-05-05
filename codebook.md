title: Coursea - Getting and Cleaning data - week 4 assignment
author: Mary Langer
date: 4/30/2019
output: tidy_data.txt
---

## Project Description
Take data collected from the accelerometers from the Samsung Galaxy S smartphone from 30 participants doing 6 activities.

##Study design and data processing

###Collection of the raw data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on 
the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the
 volunteers was selected for generating the training data and 30% the test data.   

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap
 (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body 
acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, 
a vector of features was obtained by calculating variables from the time and frequency domain. 

##Creating the tidy datafile

###Guide to create the tidy data file
-Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
-Create a folder and download the files in the zip file and unzip. Set the directory to the the folder you created.
1. load data using read.table()
	 subject_test.txt #subjects in the test group                          
     X_test.txt #test set measurements                                                  
     y_test.txt #test labels                                             
     subject_train.txt #subjects in the train group                                              
     X_train.txt  #train set measurements                                                 
     y_train.txt  #train labels
     features.txt #variable labels 

  2. Add variable names as the column headers, replace other column headers to help with the merging of data into one table
	                        
library(dplyr)
##rename subject variable name as 'subject'
    subject_train<- rename(subject_train, subject= V1)
    subject_test<-  rename(subject_test, subject =V1)

##rename activity variable as 'activity'
    y_test<- rename(y_test, activity = V1)
    y_train<-rename(y_train, activity = V1)
      
## update the column labels with the variable labels from the "features"  file
    colnames(x_test) = variable_labels[,2]  
    colnames(x_train)= variable_labels[,2]

3. merge the data into one table:

##merge the test data
   test<-cbind(y_test,x_test)
   test<-cbind(subject_test,test)
        dim(test) #2947 563
   
##merge the train data
   train<- cbind(y_train,x_train)
   train<- cbind(subject_train, train)
        dim(train) #7352  563
   
##merge train and test
    data<- rbind(test,train) 
        dim(data) #10299 563


4. Extract columns of data for only the measurements on the mean and standard deviation for each measurement 
	used grepl()

#determine which vaariables to extract
      AllVariableNames= colnames(data)  
      data2 = (grepl("subject", AllVariableNames)
              | grepl("activity" , AllVariableNames) 
              | grepl("mean.." , AllVariableNames) 
              | grepl("std.." , AllVariableNames)) 
      
      data3<-data[ ,data2 ==TRUE]
      
5.  add descriptive activity names 
	used match and merge

   ## activities
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

   activity_labels<-read.table("./activity_labels.txt", header = FALSE) #activity labels
   dim(activity_labels) #6 2
   colnames(activity_labels) <- c('actId','activity')
  
##match the activity number with the activity labels, update column values with the labels
   data3$activity<- activity_labels$activity[match(data3$activity, activity_labels$actId)]
   
data3<- merge(data3$activity, data3)



6.create a second, independent tidy data set with the average of variable for each variable for each activity and each subject
  	used aggregate and arrange
	write.table to write the tidy data set to a .txt file
   
   tidy_data<- aggregate(.~subject + activity, data3, mean )
   tidy_data<- arrange(tidy_data, subject, activity)
   
   write.table(tidy_data, "tidydata.txt", row.names =FALSE)

###Cleaning of the data
The run_analysis.R:
-merges the data from the train and test files
-adds the subjects to the data file and 
-adds the activity descriptions and variable descriptions
-extract all the variables for the mean and standard deviation


##Description of the variables in the tiny_data.txt file
General description of the file including:
 - Dimensions of the dataset- 180 81
 - Summary of the data- By subject (30 subjects), by activity (6 actvities) the mean of measurement. The 't' prefix denotes time and the 'f' denotes the frequency domain signals. 
 All measurements in Hz.  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

  
 Variables present in the dataset- 

Subject- integer, values 1-30 denotes the subject in the test
Activity - 6 LEVELS - LAYING, SITTING, WALKING, WALKING_DOWNSTAIRS, STANDING, LAYING
tBodyAcc-mean()-X , number    -time Body Accelerometer X direction mean
tBodyAcc-mean()-Y , number    -time Body Accelerometer Y direction mean
tBodyAcc-mean()-Z , number    -time Body Accelerometer Z direction mean
tBodyAcc-std()-X  , number    -time Body Accelerometer X direction standard deviation
tBodyAcc-std()-Y  , number    -time Body Accelerometer Y direction standard deviation            
tBodyAcc-std()-Z  , number    -time Body Accelerometer Z direction standard deviation            
tGravityAcc-mean()-X    , number -time Gravity Accelerometer X direction mean  
tGravityAcc-mean()-Y    , number -time Gravity Accelerometer Y direction mean     
tGravityAcc-mean()-Z    , number -time Gravity Accelerometer Z direction mean           
tGravityAcc-std()-X     , number -time Gravity Accelerometer X direction standard deviation 
tGravityAcc-std()-Y     , number -time Gravity Accelerometer Y direction standard deviation
tGravityAcc-std()-Z     , number -time Gravity Accelerometer Z direction standard deviation
tBodyAccJerk-mean()-X   , number -time Body Accelerometer Jerk X direction mean
tBodyAccJerk-mean()-Y   , number -time Body Accelerometer Jerk Y direction mean        
tBodyAccJerk-mean()-Z   , number -time Body Accelerometer Jerk Z direction mean       
tBodyAccJerk-std()-X    , number -time Body Accelerometer Jerk X direction standard deviation
tBodyAccJerk-std()-Y    , number -time Body Accelerometer Jerk Y direction standard deviation
tBodyAccJerk-std()-Z    , number -time Body Accelerometer Jerk Z direction standard deviation    
tBodyGyro-mean()-X      , number -time Body gyroscope X direction mean       
tBodyGyro-mean()-Y      , number -time Body gyroscope Y direction mean
tBodyGyro-mean()-Z      , number -time Body gyroscope Z direction mean       
tBodyGyro-std()-X       , number -time Body gyroscope X direction standard deviation 
tBodyGyro-std()-Y       , number -time Body gyroscope Y direction standard deviation 
tBodyGyro-std()-Z       , number -time Body gyroscope Z direction standard deviation 
tBodyGyroJerk-mean()-X  , number -time Body gyroscope Jerk X direction mean
tBodyGyroJerk-mean()-Y  , number -time Body gyroscope Jerk Y direction mean
tBodyGyroJerk-mean()-Z  , number -time Body gyroscope Jerk Z direction mean
tBodyGyroJerk-std()-X   , number -time Body gyroscope Jerk X direction standard deviation
tBodyGyroJerk-std()-Y   , number -time Body gyroscope Jerk Y direction standard deviation
tBodyGyroJerk-std()-Z   , number -time Body gyroscope Jerk Z direction standard deviation
tBodyAccMag-mean()      , number -time Body Accelerometer Magnitude mean
tBodyAccMag-std()       , number -time Body Accelerometer Magnitude standard deviation
tGravityAccMag-mean()   , number -time Gravity Accelerometer Magnitude mean     
tGravityAccMag-std()    , number -time Gravity Accelerometer Magnitude standard deviation
tBodyAccJerkMag-mean()  , number -time Body Accelerometer Jerk Magnitude mean 
tBodyAccJerkMag-std()   , number -time Body Accelerometer Jerk Magnitude standard deviation 
tBodyGyroMag-mean()     , number -time Body Gyroscope Magnitude mean
tBodyGyroMag-std()      , number -time Body Gyroscope Magnitude standard deviation
tBodyGyroJerkMag-mean() , number -time Body Gyroscope Jerk Magnitude mean
tBodyGyroJerkMag-std()  , number -time Body Gyroscope Jerk Magnitude standard deviation
fBodyAcc-mean()-X       ,number  -frequency Body Accelerometer X direction mean
fBodyAcc-mean()-Y       ,number  -frequency Body Accelerometer Y direction mean
fBodyAcc-mean()-Z       ,number  -frequency Body Accelerometer Z direction mean
fBodyAcc-std()-X        ,number  -frequency Body Accelerometer X direction standard deviation        
fBodyAcc-std()-Y        ,number  -frequency Body Accelerometer Y direction standard deviation
fBodyAcc-std()-Z        ,number  -frequency Body Accelerometer Z direction standard deviation
fBodyAcc-meanFreq()-X   ,number  -frequency Body Accelerometer X direction mean Frequency 
fBodyAcc-meanFreq()-Y   ,number  -frequency Body Accelerometer Y direction mean Frequency      
fBodyAcc-meanFreq()-Z   ,number  -frequency Body Accelerometer Z direction mean Frequency 
fBodyAccJerk-mean()-X   ,number  -frequency Body Accelerometer Jerk X direction mean 
fBodyAccJerk-mean()-Y   ,number  -frequency Body Accelerometer Jerk Y direction mean
fBodyAccJerk-mean()-Z   ,number  -frequency Body Accelerometer Jerk Z direction mean   
fBodyAccJerk-std()-X    ,number  -frequency Body Accelerometer Jerk X direction standard deviation   
fBodyAccJerk-std()-Y    ,number  -frequency Body Accelerometer Jerk Y direction standard deviation   
fBodyAccJerk-std()-Z    ,number  -frequency Body Accelerometer Jerk Z direction standard deviation   
fBodyAccJerk-meanFreq()-X     ,number  -frequency Body Accelerometer Jerk X direction mean Frequency
fBodyAccJerk-meanFreq()-Y     ,number  -frequency Body Accelerometer Jerk Y direction mean Frequency 
fBodyAccJerk-meanFreq()-Z     ,number  -frequency Body Accelerometer Jerk Z direction mean Frequency
fBodyGyro-mean()-X            ,number  -frequency Body Gyro X direction mean 
fBodyGyro-mean()-Y            ,number  -frequency Body Gyro Y direction mean 
fBodyGyro-mean()-Z            ,number  -frequency Body Gyro Z direction mean 
fBodyGyro-std()-X             ,number  -frequency Body Gyro X direction standard deviation
fBodyGyro-std()-Y             ,number  -frequency Body Gyro Y direction standard deviation
fBodyGyro-std()-Z             ,number  -frequency Body Gyro Z direction standard deviation
fBodyGyro-meanFreq()-X        ,number  -frequency Body Gyro X direction mean Frequency
fBodyGyro-meanFreq()-Y        ,number  -frequency Body Gyro Y direction mean Frequency 
fBodyGyro-meanFreq()-Z        ,number  -frequency Body Gyro Z direction mean Frequency
fBodyAccMag-mean()            ,number  -frequency Body Accelerometer Magnitude mean
fBodyAccMag-std()             ,number  -frequency Body Accelerometer Magnitude standard deviation
fBodyAccMag-meanFreq()        ,number  -frequency Body Accelerometer Magnitude mean Frequency
fBodyBodyAccJerkMag-mean()    ,number  -frequency Body Jerk Magnitude mean Frequency
fBodyBodyAccJerkMag-std()     ,number  -frequency Body Jerk Magnitude standard deviation
fBodyBodyAccJerkMag-meanFreq() ,number  -frequency Body Jerk Magnitude mean Frequency
fBodyBodyGyroMag-mean()        ,number  -frequency Body Gyro Magnitude mean
fBodyBodyGyroMag-std()         ,number  -frequency Body Gyro Magnitude standard deviation
fBodyBodyGyroMag-meanFreq()    ,number  -frequency Body Gyro Magnitude mean Frequency
fBodyBodyGyroJerkMag-mean()    ,number  -frequency Body Gyro Jerk Magnitude mean
fBodyBodyGyroJerkMag-std()     ,number  -frequency Body Gyro Jerk Magnitude standard deviation
fBodyBodyGyroJerkMag-meanFreq(),number  -frequency Body Gyro Jerk Magnitude mean Frequency


