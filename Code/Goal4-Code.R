# load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
#install.packages("ggthemes")
library(ggthemes)
library(scales)

# Read the data

library(readr)
Notclean_flat<- read_csv("Desktop/DAEN 690/DataFlat.csv")


#View the data, 10 rows
head(Notclean_flat, n=10)

# Select specific columns of unconditioned flat data
Uncon_FlatData <- Notclean_flat[, c( "DispatchedIncidentType", 
                                     "FinalIncidentType",
                                    "CalcCall2FirstDispatch","CalcCall2FirstArrive", 
                                     "CalcUnitDispatch2Enroute", "CalcUnitDispatch2Arrive",
                                    "CalcUnitDispatch2Available","CallConfirmedDT","UnitIdSummarized")]

# View the selected columns
Uncon_FlatData 

# Check for missing values in all columns of the data frame
missing_info <- colSums(is.na(Uncon_FlatData))
# Display the count of missing values for each column
print(missing_info)


#Data conditioning/Cleaning

#Impute missing in Calc columns
# Install and load the 'mice' package
#install.packages("mice")
library(mice)

# Specify the columns to impute
columns_to_impute <- c("CalcCall2FirstDispatch","CalcCall2FirstArrive",
                      "CalcUnitDispatch2Enroute",
                       "CalcUnitDispatch2Arrive", 
                      "CalcUnitDispatch2Available")

# Create an object with the specified columns
imputed_data <- mice(Uncon_FlatData[, columns_to_impute], method = "mean")

# Combine the imputed datasets
imputed_data <- complete(imputed_data)

# View the imputed data
print(imputed_data)

# Replace missing values in Uncon_FlatData with imputed values
Uncon_FlatData[columns_to_impute] <- imputed_data
# Print the combined data frame
print(Uncon_FlatData)

#View missing data in other columns
missing_info1 <- colSums(is.na(Uncon_FlatData))
print(missing_info1)

#No missing data but there's NA

# Check for missing values in Uncon_FlatData and create a logical matrix
missing_values_matrix <- is.na(Uncon_FlatData)

#Removing all rows with NA
# Remove rows with any missing values
Uncon_FlatData <- na.omit(Uncon_FlatData)

# Check for missing values in the cleaned data
missing_values_matrix_cleaned <- is.na(Uncon_FlatData)

missing_values_matrix_cleaned 
#False representing valid data points

#Remove Duplicates
Uncon_FlatData <- unique(Uncon_FlatData)
Uncon_FlatData

#Check if unique
is_unique <- nrow(Uncon_FlatData) == nrow(unique(Uncon_FlatData))
is_unique
#[1] TRUE Data is unique

#check if there's still missing values
missing_values3 <- colSums(is.na(Uncon_FlatData))
missing_values3

#missing_values3" is not showing any missing values. 

#Check summary of data
summary(Uncon_FlatData)

#install.packages("lubridate")
library(lubridate)

# Separating date/time from CallConfirmedDT to be able to filter before/after the 
#implementation of the new algorithm

Uncon_FlatData$Date <- as.Date(Uncon_FlatData$CallConfirmedDT)  # Extract the date part
Uncon_FlatData$Time <- format(as.POSIXct(Uncon_FlatData$CallConfirmedDT), format = "%H:%M:%S")  # Extract the time part

# Now Uncon_FlatData has two new columns: Date and Time

# Checking for "NA" in the Date column 
num_na_in_date <- sum(is.na(Uncon_FlatData$Date))

# Print the number of NA values
print(num_na_in_date)

# Getting the most recent date available in the dataset
most_recent_date <- max(Uncon_FlatData$Date, na.rm = TRUE)

# Print the most recent date
print(most_recent_date)

#Creating two new datasets from Uncon_FlatData 

# Creating the before_dispatch dataset
before_dispatch <- subset(Uncon_FlatData, Date < as.Date("2023-07-18"))

#before_dispatch <- subset(Uncon_FlatData, Date < as.Date("2023-08-08"))

# Creating the after_dispatch dataset
after_dispatch <- subset(Uncon_FlatData, Date >= as.Date("2023-07-18"))

# Calculate the average of the Call Processing time column BEFORE the dispatch algorithm
#I'm using all types of incidents

avg_Bcpt <- mean(before_dispatch$CalcCall2FirstDispatch, na.rm = TRUE)


# Calculate the average of the Call Processing time column AFTER the dispatch algorithm
#I'm using all types of incidents

avg_Acpt <- mean(after_dispatch$CalcCall2FirstDispatch, na.rm = TRUE)

# Put the averages into a named vector
averages <- c(Before = avg_Bcpt, After = avg_Acpt)

# Create a simple bar plot
barplot(averages,
        main = "Call Processing Time",
        ylab = "Average Time (Seconds)",
        xlab = "Dispatch Period",
        col = c("blue", "red"),
        ylim = c(0, max(averages) * 1.2))

# % Increase in Call Processing time
# 112.35/99.73 = 12.65% increase

# Response Time

# Calculate the average of Response Time column BEFORE the dispatch algorithm
#I'm using the all incident types

avg_Brt <- mean(before_dispatch$CalcCall2FirstArrive, na.rm = TRUE)

# Calculate the average of Response Time column AFTER the dispatch algorithm
#I'm using all incident types

avg_Art <- mean(after_dispatch$CalcCall2FirstArrive, na.rm = TRUE)

# % Increase in Call Processing time
# 412.69/401.72 = 2.73% increase

# Put the averages into a named vector
averages <- c(Before = avg_Brt, After = avg_Art)

# Create a simple bar plot
barplot(averages,
        main = "Response Time",
        ylab = "Average Time (Seconds)",
        xlab = "Dispatch Period",
        col = c("blue", "red"),
        ylim = c(0, max(averages) * 1.2))

# FILTERED DATA
#(Analyzing ALS and Medical Incident Types Only (Medical = BLS))

unique(before_dispatch$FinalIncidentType)

als_bls_b <- subset(before_dispatch, FinalIncidentType %in% c("ALS", "Medical"))
unique(als_bls_b$FinalIncidentType)

a_b_c <- after_dispatch %>%
  mutate(
    FinalIncidentType = recode(FinalIncidentType,
                               "ALS"    = "ALS",
                               "ALPHA"  = "ALS",
                               "BRAVO"  = "ALS",
                               "MEDICAL"= "BLS",
                               "CHARLIE"= "BLS"
    )
  )

unique(a_b_c$FinalIncidentType)

als_bls_a <- subset(a_b_c, FinalIncidentType %in% c("ALS", "BLS"))

unique(als_bls_a$FinalIncidentType)

# Calculate the average of the Call Processing time column BEFORE the dispatch algorithm
#Using Only ALS and BLS columns

avg_ab <- mean(als_bls_b$CalcCall2FirstDispatch, na.rm = TRUE)

avg_a_b_c <- mean(als_bls_a$CalcCall2FirstDispatch, na.rm = TRUE)

#19.35 % increase in Call Processing time analyzing only ALS/BLS before and after the algorithm

averages2 <- c(Before = avg_ab, After = avg_a_b_c)

# Create a barplot and capture the return value, which contains the bar midpoints
delta <- max(averages2) * 0.02  # 2% of the max value for a little space above the bar
bp <- barplot(averages2,
              main = "Call Processing Time",
              ylab = "Average Time (Seconds)",
              xlab = "Dispatch Period",
              col = c("blue", "red"),
              ylim = c(0, max(averages2) * 1.2))

# Loop over the bar midpoints to add the text
for(i in 1:length(averages2)) {
  # The x-coordinate is the bar midpoint, the y-coordinate is just above the bar
  text(bp[i], averages2[i] + delta, labels = round(averages2[i], 2), pos = 3)
}

## Response Time

avg_ab1 <- mean(als_bls_b$CalcCall2FirstArrive, na.rm = TRUE)

avg_a_b_c1 <- mean(als_bls_a$CalcCall2FirstArrive, na.rm = TRUE)

averages2a <- c(Before = avg_ab1, After = avg_a_b_c1)


# Create a simple bar plot
barplot(averages2a,
        main = "Response Time",
        ylab = "Average Time (Seconds)",
        xlab = "Dispatch Period",
        col = c("blue", "red"),
        ylim = c(0, max(averages2a) * 1.2))

# 5.35% increase in Response time analyzing only ALS/BLS before and after the algorithm


#Analyzing if “FinalIncidentType” is the same as “DispatchedIncidentType” to see
#the performance of the algorithm
#Including all incident types

#BEFORE THE ALGORITHM
# I have 503 854 data points

# Step 1: Create a logical vector that marks where entries in both columns differ
different_rows <- before_dispatch$DispatchedIncidentType != before_dispatch$FinalIncidentType

# Step 2: Count the number of TRUE values in the vector
num_different <- sum(different_rows)

# Step 3: Calculate the percentage of different rows
percent_different <- (num_different / nrow(before_dispatch)) * 100

# Output the percentage
print(percent_different)

#AFTER THE ALGORITHM
# I have 26 478 data points

# Step 1: Create a logical vector that marks where entries in both columns differ
different_rows1 <- after_dispatch$DispatchedIncidentType != after_dispatch$FinalIncidentType

# Step 2: Count the number of TRUE values in the vector
num_different1 <- sum(different_rows1)

# Step 3: Calculate the percentage of different rows
percent_different1 <- (num_different1 / nrow(after_dispatch)) * 100

# Output the percentage
print(percent_different1)

# FILTERED DATA (ALS and BLS only)

# BEFORE

# Step 1: Create a logical vector that marks where entries in both columns differ
different_rows2 <- als_bls_b$DispatchedIncidentType != als_bls_b$FinalIncidentType

# Step 2: Count the number of TRUE values in the vector
num_different2 <- sum(different_rows2)

# Step 3: Calculate the percentage of different rows
percent_different2 <- (num_different2 / nrow(als_bls_b)) * 100

# Output the percentage
print(percent_different2)

#AFTER

als_bls_a <- als_bls_a %>%
  mutate(
    DispatchedIncidentType = recode(DispatchedIncidentType,
                               "ALS"    = "ALS",
                               "ALPHA"  = "ALS",
                               "BRAVO"  = "ALS",
                               "MEDICAL"= "BLS",
                               "CHARLIE"= "BLS"
    )
  )

# Step 1: Create a logical vector that marks where entries in both columns differ
different_rows3 <- als_bls_a$DispatchedIncidentType != als_bls_a$FinalIncidentType

# Step 2: Count the number of TRUE values in the vector
num_different3 <- sum(different_rows3)

# Step 3: Calculate the percentage of different rows
percent_different3 <- (num_different3 / nrow(als_bls_a)) * 100

# Output the percentage
print(percent_different3)
