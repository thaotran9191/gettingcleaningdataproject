##Set working directory

setwd("~/Documents/datasciencecoursera/gettingcleaningdata/project")

##Name files path

path <- file.path("~/Documents/datasciencecoursera/gettingcleaningdata/project","projectdata")

##Download file

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "~/Documents/datasciencecoursera/gettingcleaningdata/project/projectdata.zip", method = "curl")
list.files("~/Documents/datasciencecoursera/gettingcleaningdata/project")

##Unzip file
unzip(zipfile="~/Documents/datasciencecoursera/gettingcleaningdata/project/projectdata.zip",exdir="~/Documents/datasciencecoursera/gettingcleaningdata/project")


##Check files

list.files("~/Documents/datasciencecoursera/gettingcleaningdata/project/UCI HAR Dataset")

##Define datapath

pathdata <- file.path("~/Documents/datasciencecoursera/gettingcleaningdata/project","UCI HAR Dataset")
files <- list.files(pathdata, recursive = TRUE)
files

###Question 1.

#Input data training, testing, feature, and activity

xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
strain <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
stest <- read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)
activity <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create columns in training and testing data

colnames(xtrain) <- features[,2]
colnames(ytrain) <- "act.Id"
colnames(strain) <- "subjectId"
colnames(xtest) <- features[,2]
colnames(ytest) <- "act.Id"
colnames(stest) <- "subjectId"

#Merge data training and testing

mrg_train <- cbind(ytrain, strain, xtrain)
mrg_test <- cbind(ytest, stest, xtest)

#Create activity table

colnames(activity) <- c('act.Id','act.Label')

#Merge data training, testing, and activity
full.data <- rbind(mrg_train, mrg_test)

###Question 2.

colNames <- colnames(full.data)
meanstd <- (grepl("act.Id" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
data.meanstd <- full.data[ , meanstd == TRUE]

###Question 3.

data.activity <- merge(data.meanstd, activity, by = 'act.Id', all.x = TRUE)

###Question 4.

Tidydata <- aggregate(. ~subjectId + act.Id, data.activity, mean)
Tidydata <- Tidydata[order(Tidydata$subjectId, Tidydata$act.Id),]

###Question 5. 
write.table(Tidydata, "Tidy.txt", row.name = FALSE)

