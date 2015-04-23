# create directory to download data and hold results
# written for Windows

if (!file.exists('gacdproject')) {
	dir.create('gacdproject')
}

setwd('./gacdproject')

# prepare data download
setInternet2(use=TRUE)
zipurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# download data
download.file(zipurl, destfile = 'getdata-projectfiles-UCI HAR Dataset.zip')

# unzip & load the data
zipfile <- dir()[1]
unzip(zipfile)
