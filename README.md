Course Project Getting and Cleaning Data 
1. This script downloads a zip file from http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Installs the libraries needed for using the script. 
3. Reads out the tables in the test and training folders. 
4. Merges the test and training tables together and places the variable names as the column names.
5. Extracts the measurements for standard deviation and the mean and combines them with the subject and activity of the subject. 
6. Renames the values from numeric to character statements for easier reading. 
7. Alters column names to create better descriptions. 
8. Create a tidy data set from the extractd data by averaging per activity. 
9. Orders the data by subject then activity.