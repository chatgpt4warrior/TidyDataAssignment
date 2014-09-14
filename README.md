##TidyDataAssignment
##==================

## How the Code Works

## Assumption 

It is assumed that the working directory is set to "UCI HAR Dataset" and no 
files/path modified.  

## Step1a: Read the raw file using read.table function and load it into the 
seperate dataframe

- 'train/X_train.txt'
- 'train/y_train.txt'
- 'train/subject_train.txt'  
- 'test/X_test.txt'
- 'test/y_test.txt'
- 'test/subject_test.txt'
- 'features.txt'
- 'activity_labels.txt'

## Step1b: Add Column Names for dataframe using colnames function

- ytrain
- subjtrain
- ytest
- subjtest
- activity

## Step1c: Merge the variables to its respective Activities and subject

The three related files (X_train.txt,y_train.txt,subject_train.txt )have same
number of records and no common key. It is assumed that each row (number) in 
the first file is mapped to the other two file in the same order. 

Club the three training data together using cbind function and stored in 
"trainData" dataframe

Similarly, the test data are clubbed together using cbind function and stored 
in "testData" dataframe 

##Step1d: Merge the training and test data into one dataset.

Add the rows of testData to the trainData and create one single "modelData" 
dataframe.

## Step2a: Create a subset of features which stores
## measurements for mean and standard deviation 

The column having mean() and std() are considered as mesurements fot mean and 
standard deviation.
In all three are 66 columns for measurements.

The feature list are filtered using grep command and a subset of the features 
having these 66 measurements is created.

##Step2b: Create a column list based on the rows in measureCol 
##add activity_id and subject_id to the above column list  

The column name V1 in the modelData will map to the value=1 in V1 column of the
measureCol dataframe.Hence by prefixing 'V' to the measureCol value, we can get 
a list of column names for the mean and standard deviation measurements.

The measureCol V1 columns values are looped through a for loop to get the 
column list(colName).

Note: activity_id and subject_id must be added to the column list for 
calculations downstream   

##Step2c: Extracts only the measurements on the mean and standard deviation 
## and create a subset using the column list colName.

The column list is applied to modelData dataframe to get the required subset 
of mean and std measurements in the subset "modelSubset". 

## Step3a: Create a list of column description for applying labelling 
## to the measurements  

The labels are available in column V2 of the measureCol dataframe.
The measureCol V2 columns values are looped through a for loop to get the 
column labels(colDesc).

Note: activity_id and subject_id must be added as first 2 columns in the list 
as we have added those columns in subset.

##Step3b: Apply the labels with descriptive variable names 
 
The measurement labels are applied to the subset dataframe "modelSubset"

##Step4a: Merge the subset to activity dataframe to get activity descriptions
##with activity_id as key

The descriptive activity names are mapped to the activities in the subset by 
merging the subset (modelSubset) and activity (activity) dataframe using
activity_id as key. 

##Step4b: Drop the activity_id column from the just create data frame

The activity id column is not required for further processing and it is dropped 
from modelSubset.

##Step4c: Reorder the column to bring activity_desc as first column

The activity description column is the last column after merging. It is 
reordered to first column for easy viewing.

##Step5: Calculate the mean for the measurements for each activity per subject
##using melt and dcast function

reshape2 package must be installed locally for this step 2 execute correctly.

For calculating the mean, the measurement are passed to the melt function for 
each activity_desc and subject_id and the result is stored in meltActSubj.

Then meltActSubj is passed to dcast function and mean is each for each 
measurements. The result is stored in tidy data set "meanActSubj"  

##Step6: Write the tidy dataset to the file

A text file(TidyDataset.txt) is created in the working directory by passing the
tidy dataset(meltActSubj) to write.table with row.names=FALSE and other 
parameters are left to default.  
