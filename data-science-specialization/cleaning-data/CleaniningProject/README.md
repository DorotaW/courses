Cleaning_Project
================

There are following steps in the script run_analysis.R:

1. Merges the training and the test sets to create one data set.
  * If there are no right files in working directory the zip file is dowloaded and unzipped
  * Using read.table functions uploading training and test set, labels and subjects(6 *tes/train objects)
  * features.txt and activity_labels are uploaded as well
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  * Merging two sets together (without activity or subject labels) and keeping only columns that are mean and standard          deviation for each measurement . Those columns are chosen based on column names (stored in features) - they have to         contain either mean() or std(), meanFreq() are excluded.
3. Uses descriptive activity names to name the activities in the data set
  * Columns with subjects and activity lables are added, after merging with activity_lables activityIDs are replaced with       description.
4. Appropriately labels the data set with descriptive variable names. 
  * Descriptive variable names are pulled out from features
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
  * Using melt and ddply data is aggregated and sumarized by subject and activity, each variable is now in separte row          rather then column
  * New tidy data set is saved as tab delimited txt file.
6. Using memisc library and data.set options codebook is created
