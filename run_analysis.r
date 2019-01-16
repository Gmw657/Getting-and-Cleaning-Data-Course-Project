## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    if (!require("data.table")) {
   install.packages("data.table")
   }

   if (!require("reshape2")) {
   install.packages("reshape2")
   }

  if (!require("plyr")) {
  install.packages("plyr")
  }
  
  if (!require("knitr")) {
  install.packages("knitr")
  }
  
 require("data.table")
 require("reshape2")
 require("plyr")
 require("knitr")

#Downloading and Cleaning the Data

     if(!file.exists("./data")){dir.create("./data")}
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	  
      download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
	  
# Unzip dataSet 

    unzip(zipfile="./data/Dataset.zip",exdir="./data")
	
#unzipped files are in the folderUCI HAR Dataset. Get the list of the files

    path_rf <- file.path("./data" , "UCI HAR Dataset")
    files<-list.files(path_rf, recursive=TRUE)
     files
	 
#Read the Activity files

    dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
    dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
	
#Read the Subject files

    dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
    dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
	
#Read Fearures files

    dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
    dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
	
#Look at the properties of varibles

    str(dataActivityTest)
	str(dataActivityTrain)
	str(dataSubjectTrain)
	str(dataSubjectTest)
	str(dataFeaturesTest)
	str(dataFeaturesTrain)
	
#Merges the training and the test sets to create one data set
#1.Concatenate the data tables by rows

    dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
    dataActivity<- rbind(dataActivityTrain, dataActivityTest)
    dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
	
#2.set names to variables

    names(dataSubject)<-c("subject")
    names(dataActivity)<- c("activity")
    dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
    names(dataFeatures)<- dataFeaturesNames$V2
	
#3.Merge columns to get the data frame Data for all data

   dataCombine <- cbind(dataSubject, dataActivity)
   Data <- cbind(dataFeatures, dataCombine)
   
#Extracts only the measurements on the mean and standard deviation for each measurement

#1. Subset Name of Features by measurements on the mean and standard deviation
#i.e taken Names of Features with “mean()” or “std()”

   subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
   
#2. Subset the data frame Data by seleted names of Features

   selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
   Data<-subset(Data,select=selectedNames)
   
#3. Check the structures of the data frame Data

   str(Data)
   
#Uses descriptive activity names to name the activities in the data set

#1.Read descriptive activity names from “activity_labels.txt”
   activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
   
#2. facorize Variale activity in the data frame Data using descriptive activity names
#3. check
    head(Data$activity,30)
	
#labels the data set with descriptive variable names

   names(Data)<-gsub("^t", "time", names(Data))
   names(Data)<-gsub("^f", "frequency", names(Data))
   names(Data)<-gsub("Acc", "Accelerometer", names(Data))
   names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
   names(Data)<-gsub("Mag", "Magnitude", names(Data))
   names(Data)<-gsub("BodyBody", "Body", names(Data))
   
#check

   names(Data)
   
#Creates a second,independent tidy data set and ouput it

  library(plyr);
  Data2<-aggregate(. ~subject + activity, Data, mean)
  Data2<-Data2[order(Data2$subject,Data2$activity),]
  write.table(Data2, file = "tidydata.txt",row.name=FALSE)

  
  








