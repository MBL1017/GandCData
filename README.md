# Getting and Cleaning Data- week 4 assignment

	Merge data into one data set with descriptive variable labels and descriptive activity labels.
	Extact variables for only mean and standard deviation measurements

	Create a second tidy data set that that has the average for each variable by activity and subject
__________________________________________________


## Data used:
	The data  represents data collected from the accelerometers from the Samsung Galaxy S smartphone. 
	A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

	The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities 
	(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on 
	the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
	The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the
 	volunteers was selected for generating the training data and 30% the test data.   

	The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap
 	(128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body 
	acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, 
	a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 
__________________________________________________
## Getting Started:

-Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
-Software needed: RGui; RStudio

How to install R: https://cran.r-project.org/doc/manuals/R-admin.html

How to install RStudio: https://www.rstudio.com/products/rstudio/download/
__________________________________________________
## The scripts follows these steps:
### 1. load data
	used read.table()

     subject_test<- read.table("./test/subject_test.txt") #subjects in test
                                                    
     x_test<-read.table("./test/X_test.txt") #test set
                                                    
     y_test<-read.table("./test/y_test.txt") #test labels
                                           
     subject_train<- read.table("./train/subject_train.txt") #subjects in train
                                                   
     x_train<-read.table("./train/X_train.txt") #train set
                                                   
     y_train<-read.table("./train/y_train.txt") #train labels
                        
     variable_labels<-read.table("./features.txt") #variable labels 
                      

  ### 2. Add variable names as the column headers, replace other column headers
	used colnames().                       
library(dplyr)
### rename subject variable name as 'subject'
    subject_train<- rename(subject_train, subject= V1)
    subject_test<-  rename(subject_test, subject =V1)

### rename activity variable as 'activity'
    y_test<- rename(y_test, activity = V1)
    y_train<-rename(y_train, activity = V1)
      
### update the column labels with the variable labels from the "features"  file
    colnames(x_test) = variable_labels[,2]  
    colnames(x_train)= variable_labels[,2]

### 3. merge the data into one table:

### merge the test data
   test<-cbind(y_test,x_test)
   test<-cbind(subject_test,test)
        dim(test) #2947 563
   
### merge the train data
   train<- cbind(y_train,x_train)
   train<- cbind(subject_train, train)
        dim(train) #7352  563
   
### merge train and test
    data<- rbind(test,train) 
        dim(data) #10299 563


### 4. Extract columns of data for only the measurements on the mean and standard deviation for each measurement 
	used grepl()

extract only the measurements on the mean and standard deviation for each measurement 
#determine which vaariables to extract
      AllVariableNames= colnames(data)  
      data2 = (grepl("subject", AllVariableNames)
              | grepl("activity" , AllVariableNames) 
              | grepl("mean.." , AllVariableNames)
	      | grepl("std.." , AllVariableNames)) 
      
      data3<-data[ ,data2 ==TRUE]
      
### 5.  add descriptive activity names 
	used match and merge

   ## activities
   #1 WALKING
   #3 WALKING_DOWNSTAIRS
   #4 SITTING
   #5 STANDING
   #6 LAYING
   activity_labels<-read.table("./activity_labels.txt", header = FALSE) #activity labels
   dim(activity_labels) #6 2
   colnames(activity_labels) <- c('actId','activity')
  
### match the activity number with the activity labels, update column values with the labels
   data3$activity<- activity_labels$activity[match(data3$activity, activity_labels$actId)]
   
data3<- merge(data3$activity, data3)



### 6.create a second, independent tidy data set with the average of variable for each variable for each activity and each subject
  	used aggregate and arrange
	write.table to write the tidy data set to a .txt file

 **** A tidy data set is defined as follows. This definition is from the Journal of Statistical Software- Tidy Data by Hadley Wickham
	1.Each variable forms a column
	2. Each observation forms a row
	3.Each type of observational unit forms a table
The tidy data set that was created  has only one type of measurement in each column and one observation in each row. The observational unit is the mean.
   
   tidy_data<- aggregate(.~subject + activity, data3, mean )
   tidy_data<- arrange(tidy_data, subject, activity)
   
   write.table(tidy_data, "tidydata.txt", row.names =FALSE)


