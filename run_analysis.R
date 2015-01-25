# Get the data
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

subjectTest<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/test/subject_test.txt",sep="", header=FALSE, col.names="subjectId")
subjectTrain<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/train/subject_train.txt",sep="", header=FALSE, col.names="subjectId")

activityTest<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/test/y_test.txt",sep="", header=FALSE, col.names="activityId")
activityTrain<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/train/y_train.txt",sep="", header=FALSE, col.names="activityId")

activityLabels<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/activity_labels.txt",sep="", header=FALSE,col.names=c("activityId","activityDesc"))
colHeaders<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/features.txt")

testSet<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/test/X_test.txt",sep="", header=FALSE)
trainSet<-read.table("~/Coursera/Data Cleaning/UCI HAR Dataset/train/X_train.txt",sep="", header=FALSE)

# Label with variable Names
colnames(testSet)<- colHeaders[,2]
colnames(trainSet)<- colHeaders[,2]

testSet <- cbind(subjectTest, activityTest, testSet)
trainSet <- cbind(subjectTrain, activityTrain, trainSet)

# Assign Activity Names
testSet <- merge(activityLabels,testSet,by="activityId")
trainSet <- merge(activityLabels,trainSet,by="activityId")

# Merge Data sets
mergedSet <- rbind(testSet,trainSet)

# Extract only the mean and standard deviation for each measurement. 
subsetMean <- grepl("mean()",colnames(mergedSet), fixed=TRUE)
subsetStd <- grepl("std()", colnames(mergedSet), fixed=TRUE)
subsetAll <- as.logical(subsetMean + subsetStd)

subsetAll[2:3] <- TRUE
subMergedSet <- mergedSet[,subsetAll]

# Create tidy data set
tidySet <- aggregate(. ~ subMergedSet$subjectId+subMergedSet$activityDesc, data=subMergedSet ,FUN=mean)

# Rename columns in new data set
tidySet <- tidySet[,-c(3,4)]
colnames(tidySet)[1:2] <- c("subjectId","activity")

# Write output
write.table(tidySet, "tidySet.txt", row.name=FALSE)
