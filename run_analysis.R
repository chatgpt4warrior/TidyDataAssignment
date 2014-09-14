## Step1a: Read the raw file into dataframes. 

xtrain = read.table('./train/X_train.txt', header = FALSE, stringsAsFactors = F)
ytrain = read.table('./train/y_train.txt', header = FALSE, stringsAsFactors = F)
subjtrain = read.table('./train/subject_train.txt', header = FALSE, stringsAsFactors = F)
xtest = read.table('./test/X_test.txt', header = FALSE, stringsAsFactors = F)
ytest = read.table('./test/y_test.txt', header = FALSE, stringsAsFactors = F)
subjtest = read.table('./test/subject_test.txt', header = FALSE, stringsAsFactors = F)
features = read.table('./features.txt', header = FALSE, stringsAsFactors = F)
activity = read.table('./activity_labels.txt', header = FALSE, stringsAsFactors = F)

## Step1b: Add Column Names for dataframe using colnames function

colnames(ytrain) <- c("activity_id")
colnames(subjtrain) <- c("subject_id")
colnames(ytest) <- c("activity_id")
colnames(subjtest) <- c("subject_id")
colnames(activity) <- c("activity_id","activity_desc")

## Step1c: Merge the variables to its respective Activities and subject 

trainData <- cbind(xtrain,subjtrain,ytrain)
testData <- cbind(xtest,subjtest,ytest)

##Step1d: Merge the training and test data into one dataset.

modelData <- rbind(trainData,testData)


## Step2a: Create a subset of features which stores
## measurements for mean and standard deviation 


meanCol <- subset(features,  grepl(glob2rx("*mean()*") , V2) )
stdCol <- subset(features,  grepl(glob2rx("*std()*") , V2) )
measureCol <- rbind(meanCol,stdCol)

##Step2b: Create a column list based on the rows in measureCol 
##add activity_id and subject_id to the above column list  

colName <- c("subject_id","activity_id")
for (i in measureCol$V1) {
    addCol <- paste("V",i,sep="")
    colName <- c(colName,addCol)
}

##Step2c: Extracts only the measurements on the mean and standard deviation 
## and create a subset using the column list colName.

if(!exists("modelSubset")) {
		 modelSubset <- subset(modelData, select=colName)
		} 

## Step3a: Create a list of column description for applying labelling 
## to the measurements  

colDesc <- c("subject_id","activity_id")
for (i in measureCol$V2) {
        colDesc <- c(colDesc,i)
}

##Step3b: Apply the labels with descriptive variable names 
 
colnames(modelSubset) <- colDesc

##Step4a: Merge the subset to activity dataframe to get activity descriptions
##with activity_id as key

mergedData = merge(modelSubset,activity,by.x="activity_id",by.y="activity_id")

##Step4b: Drop the activity_id column from the just create data frame

mergedData$activity_id <- NULL

##Step4c: Reorder the column to bring activity_desc as first column

col_idx <- grep("activity_desc", names(mergedData))
mergedData <- mergedData[, c(col_idx, (1:ncol(mergedData))[-col_idx])]

##Step5: Calculate the mean for the measurements for each activity per subject
##using melt and dcast function

library(reshape2)

meltActSubj <- melt(mergedData,id=c("activity_desc","subject_id"),measure.vars=c(3:ncol(mergedData)))

meanActSubj <- dcast(meltActSubj, activity_desc + subject_id ~ variable,mean)

##Step6: Write the tidy dataset to the file
write.table(meanActSubj, file = "./TidyDataset.txt",row.names=FALSE)

