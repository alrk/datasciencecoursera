### Files list:
1. activity_subject_averages.txt
	- a tab separated dataset dataset (produced by running run-analysis.R in current directory)
2. codebook.pdf 
	- codebook for activity_subject_averages.txt
3. run-analysis.R
	- the script used to create the dataset (see below)

### Acknowledgement: 
The dataset used is provided by
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

	
### Dataset generation
The script run-analysis.R is to be run in the main data directory (the one containing the files "features_info.txt", "features.txt", "activity_labels.txt", and "train" and "test" subdirectories.

The script has no parameters

Script output is the file  activity_subject_averages.txt in working directory.
 
### How the script works

We do the following:

1. Read features and activity labels files
2. Read train and test datasets and the corresponding labels and subject codes
3. Replace activity labels by activity names. We also replace dashes by underscores and make all words lower-case and replace the numeric subject codes by more informative strings like "subject-01", "subject-02", etc.
4. Merge the training and the test sets using rbind()
5. Extract mean and standard deviation columns for each measurement (using grepl() and subset())
6. Split the resulting dataset by subject and activity label, calculate the mean for each (numeric) variable and write it to the new dataset. This is done using ddply(). The features in the new dataset are named by adding the "-ave" suffix to the coresponding original feature.
7. Write the resulting dataset to the tab-separated file activity_subject_averages.txt
8. Cleanup: remove all the created objects from workspace