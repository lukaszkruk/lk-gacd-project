Submission for the Getting and Cleaning Data Coursera class project.
https://class.coursera.org/getdata-013

This GitHub repository is part of the submission of project detailed here:
https://class.coursera.org/getdata-013/human_grading/view/courses/973500/assessments/3/submissions

The data this repository is concerned with was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The repo contains the following files:
readme.md - this file - provides overview of the analysis 
codebook.txt - describes the processed data
data_download.R - Windows script to download the data
run_analysis.R - R script performing the analysis as per the instruction notes linked above

The analysis steps are explained in comments in the run_analysis.R file, but the general process is to:

- load both (test and train) data tables and attach columns indicating performed activity and the subject
- merge the tables by appending one to another
- performing a join to activity labels
- selecting only columns with mean and std (standard deviation) measurement data
- averaging the measurement data by activity and subject - in other words getting a mean of all values for each possible combination of subject and activity
- sorting the resulting table

You can read the final dataset by using:
sorteddata <- fread('sorteddata.txt')