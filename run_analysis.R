###data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## 1. merge the training and test sets to create one data set

    
read.table("./test/subject_test.txt") #subjects in test
                          
 #2947 1
                          
     x_test<-read.table("./test/X_test.txt") #test set
                          dim(x_test) #2947  561
                          
     y_test<-read.table("./test/y_test.txt") #test labels
                          dim(y_test) #2947    1
                    
     subject_train<- read.table("./train/subject_train.txt") #subjects in train
                          dim(subject_test) #2947    1
                          
     x_train<-read.table("./train/X_train.txt") #train set
                          dim(x_train) #7352  561
                          
     y_train<-read.table("./train/y_train.txt") #train labels
                          dim(y_train) #7352  1

##rename subject variable name as 'subject'
    subject_train<- rename(subject_train, subject= V1)
    subject_test<-  rename(subject_test, subject =V1)

##rename activity variable as 'activity'
    y_test<- rename(y_test, activity = V1)
    y_train<-rename(y_train, activity = V1)
      
##merge the data into one table
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
  
   
##2. extract only the measurements on the mean and standard deviation for each measurement 
#determine which vaariables to extract
   
   variable_labels<-read.table("./features.txt") #variable labels 
   V1<- grep("mean", variable_labels$V2) 
   V2<- grep("std", variable_labels$V2)
   
   data2<-select(data, subject, activity, V1:V6,V41:V46,V81:V86,V121:V126, 
          V161:V166,V201:V202, V214:V215,V227:V228, V240,V241,V253:V254, V266:V271,
          V294:V296,V345:V350,V373:V375, V424:V429, V452:V454,V503:V504,V513, V516:V517,
          V526, V529:V530,V539,V542:V543,V552)
   
##3. Add descriptive activity names
   ## activities
   #1 WALKING
   #3 WALKING_DOWNSTAIRS
   #4 SITTING
   #5 STANDING
   #6 LAYING
   activity_labels<-read.table("./activity_labels.txt") #activity labels
   dim(activity_labels) #6 2
  
##data2[,1] <-read.table("./activity_labels.txt")[data2[, 1],2]
  ##names(data2) <- "activity"
  ##View(data2)
  sqldf(c('update data2 set activity = "standing" where activity = "5"', 'select * from data2'))
