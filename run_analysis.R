
#Setting Working Directory (I know cleaning is spelled wrong)
setwd("C:\\Coursera\\Getting and Cleining data\\Assignment\\UCI HAR Dataset")

## Prepare files to process 
Link_to_Features_Set <- ("./features.txt") 
Link_to_Activity_Labels_Set <- ("./activity_labels.txt") 
Link_to_X_Train_Set <- ("./train/X_train.txt") 
Link_to_Y_Train_Set <- ("./train/y_train.txt") 
Link_to_Subject_Train_Set <- ("./train/subject_train.txt") 
Link_to_X_Test_Set  <- ("./test/X_test.txt") 
Link_to_Y_Test_Set  <- ("./test/y_test.txt") 
Link_to_Subject_Test_Set <- ("./test/subject_test.txt") 

# Load Files to start processing 
features <- read.table(Link_to_Features_Set, colClasses = c("character")) 
activity_labels <- read.table(Link_to_Activity_Labels_Set, col.names = c("ActivityId", "Activity")) 
x_train <- read.table(Link_to_X_Train_Set) 
y_train <- read.table(Link_to_Y_Train_Set) 
subject_train <- read.table(Link_to_Subject_Train_Set) 
x_test <- read.table(Link_to_X_Test_Set) 
y_test <- read.table(Link_to_Y_Test_Set) 
subject_test <- read.table(Link_to_Subject_Test_Set) 

##Merging the test and training data to later append.

test_data <- cbind(cbind(x_test,subject_test),y_test)
train_data <-cbind(cbind(x_train,subject_train),y_train)

##Appending the data to create big final set

total_data <- rbind(test_data,train_data)

#Labelling the columns

names(total_data) <-  rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]

##Question 2

install.packages("plyr")
library(plyr)


##Using grepl inside subset to only get the variables with mean,std in.
total_Data_Mean_Std <- total_data[,grepl("mean|std|Subject|ActivityId", names(total_data))]


## Question 3/ Uses descriptive activity names to name the activities in the data set 

total_Data_Mean_Std<-merge(x = total_Data_Mean_Std, y = activity_labels, by = "ActivityId", all.x = TRUE)

total_Data_Mean_Std <- total_Data_Mean_Std[,-1] 


## Question 4/ Appropriately labels the data set with descriptive variable names. 
# Remove parentheses 
names(total_Data_Mean_Std) <- gsub('\\(|\\)',"",names(total_Data_Mean_Std), perl = TRUE) 
# Create syntactically valid names 
names(total_Data_Mean_Std) <- make.names(names(total_Data_Mean_Std)) 


# More descriptive naming convention 
names(total_Data_Mean_Std) 


names(total_Data_Mean_Std) <- gsub('Acc',"Acceleration",names(total_Data_Mean_Std)) 
names(total_Data_Mean_Std) <- gsub('GyroJerk',"AngularAcceleration",names(total_Data_Mean_Std)) 
names(total_Data_Mean_Std) <- gsub('Gyro',"AngularSpeed",names(total_Data_Mean_Std)) 
names(total_Data_Mean_Std) <- gsub('Mag',"Magnitude",names(total_Data_Mean_Std)) 
names(total_Data_Mean_Std) <- gsub('^t',"TimeDomain.",names(total_Data_Mean_Std)) 
names(total_Data_Mean_Std) <- gsub('^f',"FrequencyDomain.",names(total_Data_Mean_Std)) 

names(total_Data_Mean_Std) <- gsub('\\.',"",names(total_Data_Mean_Std)) 



## Question 5/ From the data set in step 4, creates a second, independent tidy data set with the  
## average of each variable for each activity and each subject. 

library(plyr)

total_avg = ddply(total_Data_Mean_Std, c("Subject","Activity"), numcolwise(mean)) 


write.table(total_avg, file = "Tidy dataset.txt",row.names = FALSE) 

