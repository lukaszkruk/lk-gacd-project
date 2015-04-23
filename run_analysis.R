# run_analysis.R
# set the working directory containing the unzipped 'UCI HAR Dataset' folder

library(data.table)
library(dplyr)

# specify data files to load
testfile <- 'UCI HAR Dataset/test/X_test.txt'
testlabelsfile <- 'UCI HAR Dataset/test/y_test.txt'
testsubjectfile <- 'UCI HAR Dataset/test/subject_test.txt'
trainfile <- 'UCI HAR Dataset/train/X_train.txt'
trainlabelsfile <- 'UCI HAR Dataset/train/y_train.txt'
trainsubjectfile <- 'UCI HAR Dataset/train/subject_train.txt'

featuresfile <- 'UCI HAR Dataset/features.txt'
activityfile <- 'UCI HAR Dataset/activity_labels.txt'

# read the data and apply column names to labels and subject data
testdata <- data.table(read.table(testfile))
testlabels <- read.table(testlabelsfile)
names(testlabels) <- 'label'
testsubject <- read.table(testsubjectfile)
names(testsubject) <- 'subject'

traindata <- data.table(read.table(trainfile))
trainlabels <- read.table(trainlabelsfile)
names(trainlabels) <- 'label'
trainsubject <- read.table(trainsubjectfile)
names(trainsubject) <- 'subject'

# add label & subject columns to the two datasets
labeledtest <- cbind(testdata, testlabels, testsubject)
labeledtrain <- cbind(traindata, trainlabels, trainsubject)

# merge test and train datasets into one table
mergeddata <- data.table(rbind(labeledtest, labeledtrain))

# load & apply feature (column) names to the merged dataset
features <- read.table(featuresfile, stringsAsFactors = FALSE)
names(mergeddata) <- c(features$V2, 'label', 'subject')

# select only columns with std and mean of measurements
# this unfortunately does not preserve column order
selecteddata <- cbind(
	select(mergeddata, subject),
	select(mergeddata, label),
	select(mergeddata, contains('mean', ignore.case = FALSE)), 
	select(mergeddata, contains('std'))
)

# load activity names and join to main data for final full dataset (data)
activity <- read.table(activityfile)
names(activity) <- c('label','activity')

labeleddata <- merge(x = selecteddata, y = activity, by = 'label', all.x = TRUE)

# reorder the columns
completedata <- select(labeleddata, activity, subject:(dim(labeleddata)[2]-1))

# this dataset represents completed steps 1 to 4 in the project assignment 
# let's save it
write.csv(completedata, file ='completedata.csv', row.names = FALSE)

# completedata <- data.table(read.csv('completedata.csv'))

# get average of each variable per subject and activity. sources:
# http://stackoverflow.com/questions/21208801/group-by-multiple-columns-in-dplyr-using-string-vector-input
# http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr

grp_cols <- names(completedata)[1:2]
dots <- lapply(grp_cols, as.symbol)

summariseddata <- completedata %>%
    group_by_(.dots=dots) %>%
    summarise_each(funs(mean))

# sort the result by activity, then subject
sorteddata <- summariseddata[order(summariseddata$activity, summariseddata$subject),]

# save the final tidy dataset
write.csv(sorteddata, file ='sorteddata.csv', row.names = FALSE)