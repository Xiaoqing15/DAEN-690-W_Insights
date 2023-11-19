df <- read.csv("cleandata.csv")
library(dplyr)
unique(df$GeoFirstDue)

all_stations <- c(401, 402, 404, 405, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 
                  425, 426, 427, 428, 429, 430, 431, 432, 434, 435, 436, 437, 438, 439, 440, 441, 442, 444)

# Create lists for each section
section_1 <- c(412, 439, 425, 442)
section_2 <- c(429, 401, 444, 413)
section_3 <- c(404, 436, 431, 415)
section_4 <- c(438, 417, 416, 432)
section_5 <- c(440, 421, 434)
section_6 <- c(402, 430, 418, 423)
section_7 <- c(428, 410, 408, 426)
section_8 <- c(435, 441, 419, 420)
section_9 <- c(414, 427, 422, 405, 437)
section_10 <- c(411, 409, 424)



## Calculate the current average of frequency of Incidents where BLS are sent by GeoFirst

BLS_units <- c("A408", "A409", "A410", "A412", "A415", "A416", "A420", "A427", "A431", "A441", "A440", "A444")
current_BLS_Stations <- c("408", "409", "410", "412", "415", "416", "420", "427", "431", "441", "440", "444")

# Filter the DataFrame for incidents where BLS units were sent
BLS_incidents_df <- df[df$UnitIdSummarized %in% BLS_units, ]


# Create a data frame with unique station values
unique_stations_df <- data.frame(Stations = all_stations)

## Incidents hotspots of BLS transport units
Incidents_FreqBLS <- BLS_incidents_df %>%
  group_by(GeoFirstDue) %>%
  summarise(Incident_Frequency = n_distinct(IncidentNumber)) %>%
  arrange(GeoFirstDue)

##Adding this Frequency to the data Frame unique_stations_df

# Join the two data frames based on 'GeoFirstDue' and 'Stations'
unique_stations_df <- unique_stations_df %>%
  left_join(Incidents_FreqBLS, by = c("Stations" = "GeoFirstDue"))

# Rename the 'Incident_Frequency' column to 'Frequency' (if needed)
unique_stations_df <- unique_stations_df %>%
  rename(Frequency = Incident_Frequency)

# Print the resulting data frame
print(unique_stations_df)


# Calculate the "current BLS" column (1 if in the list, else 0)
unique_stations_df$Current_BLS <- as.integer(unique_stations_df$Stations %in% as.numeric(current_BLS_Stations))

# Print the resulting data frame
print(unique_stations_df)


## INCIDENTS BY SECTIONS
# List of sections
sections <- list(
  section_1, section_2, section_3, section_4, section_5,
  section_6, section_7, section_8, section_9, section_10
)

# Create a vector to store the average incidents for each section
section_averages <- numeric(length(sections))

# Loop through sections and calculate the average incidents for each
for (i in 1:length(sections)) {
  section_stations <- sections[[i]]
  section_average <- mean(unique_stations_df$Frequency[unique_stations_df$Stations %in% section_stations])
  section_averages[i] <- section_average
}

# Create a data frame to store the results
section_results <- data.frame(
  Section = paste("section", 1:10, sep = "_"),
  Average_Incidents = section_averages
)

# Print the results
print(section_results)



# Assuming you have the 'section_results' data frame and 'unique_stations_df' data frame

# Create a function to calculate the sum of frequency within each section
calculate_section_sum <- function(section_stations) {
  sum(unique_stations_df$Frequency[unique_stations_df$Stations %in% section_stations])
}

# Calculate the section sums and add a new column to section_results
section_results$Sum_Frequency <- sapply(sections, calculate_section_sum)

# Print the updated section_results data frame
print(section_results)

# Create a function to count BLS stations in each section
count_bls_stations <- function(section_stations) {
  sum(section_stations %in% current_BLS_Stations)
}

# Calculate the number of BLS stations and add a new column to section_results
section_results$BLS_Count <- sapply(sections, count_bls_stations)

# Print the updated section_results data frame
print(section_results)

section_results <- section_results %>%
  arrange(Average_Incidents)

# Calculate the AVEREGA RESPONSE TIME BY SECTION
calculate_average_resp_time <- function(section_stations) {
  mean(BLS_incidents_df$CalcCall2FirstArrive[BLS_incidents_df$GeoFirstDue %in% section_stations])
}

# Calculate the average response time and add a new column to section_results
section_results$Average_RespTime <- sapply(sections, calculate_average_resp_time)

# Print the updated section_results data frame
print(section_results)

# Calculate the 90th percentile response time within each section
calculate_90th_percentile_resp_time <- function(section_stations) {
  quantile(BLS_incidents_df$CalcCall2FirstArrive[BLS_incidents_df$GeoFirstDue %in% section_stations], 0.9)
}

# Calculate the 90th percentile response time and add a new column to section_results
section_results$Percentile_90_RespTime <- sapply(sections, calculate_90th_percentile_resp_time)

# Print the updated section_results data frame
print(section_results)

mean(section_results$Average_RespTime)
mean(section_results$Percentile_90_RespTime)
mean(section_results$Average_Incidents)

##Note: Here we have a dataframe with the Average of Incidents, Total frequency, Number of BLS units in that section for each section.
#Now, We can study the each section.

###-------------------------------------------------------------------------------------

##Studying ALL Sections: 


section_results <- section_results %>%
  mutate(BLS_Needed = ifelse(
    (Average_Incidents > 805.03) & 
     (Average_RespTime > 412.78) & 
      (Percentile_90_RespTime > 575.05),
    1,
    0
  ))

section_results
# Section_5



section_results <- section_results %>%
  mutate(BLS_Needed = ifelse(
    (Average_Incidents > 805.03) & 
      (Average_RespTime > 412.78),
    1,
    0
  ))
section_results

## Change this based on the Column you want to check

section_results <- section_results %>%
  arrange(desc(Percentile_90_RespTime))

section_results

##--------------------------------------------------------
#Studying section 5

## BLS in this section? 
# Convert section_1 to character type for comparison
section_1_char <- as.character(section_5)

# Check which BLS stations are in section_1
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_1_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_5:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_5.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_5) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)


##--------------------------------------------------------
#Studying section 6

## BLS in this section? 
# Convert section_1 to character type for comparison
section_6_char <- as.character(section_6)

# Check which BLS stations are in section_6
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_6_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_6:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_6.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_6) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 10

## BLS in this section? 
# Convert section_10 to character type for comparison
section_10_char <- as.character(section_10)

# Check which BLS stations are in section_10
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_10_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_10:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_10.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_10) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 2

## BLS in this section? 
# Convert section_2 to character type for comparison
section_2_char <- as.character(section_2)

# Check which BLS stations are in section_2
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_2_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_2:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_2.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_2) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 3

## BLS in this section? 
# Convert section_3 to character type for comparison
section_3_char <- as.character(section_3)

# Check which BLS stations are in section_3
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_3_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_3:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_3.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_3) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 4

## BLS in this section? 
# Convert section_4 to character type for comparison
section_4_char <- as.character(section_4)

# Check which BLS stations are in section_4
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_4_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_4:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_4.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_4) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 7

## BLS in this section? 
# Convert section_7 to character type for comparison
section_7_char <- as.character(section_7)

# Check which BLS stations are in section_7
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_7_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_7:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_7.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_7) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##--------------------------------------------------------
#Studying section 8

## BLS in this section? 
# Convert section_8 to character type for comparison
section_8_char <- as.character(section_8)

# Check which BLS stations are in section_8
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_8_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_8:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_8.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_8) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)



##--------------------------------------------------------
#Studying section 9 (quick check)

## BLS in this section? 
# Convert section_9 to character type for comparison
section_9_char <- as.character(section_9)

# Check which BLS stations are in section_9
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_9_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_9:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_9.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_9) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

##-------------------------------------------------------------------
#Current BLS for section 1 and 9
#Studying section 1

## BLS in this section? 
# Convert section_1 to character type for comparison
section_1_char <- as.character(section_1)

# Check which BLS stations are in section_1
matching_stations <- current_BLS_Stations[current_BLS_Stations %in% section_1_char]

# Print the matching stations
if (length(matching_stations) > 0) {
  cat("The following BLS stations are in section_1:\n")
  cat(matching_stations, sep = ", ")
} else {
  cat("No BLS stations are in section_1.")
}

## Where are those sent the most: 

# Calculate and append frequency for each GeoFirstDue value across all UnitIdSummarized


# Calculate frequency for each GeoFirstDue value across the Section
result_df <- data.frame(GeoFirstDue = character(0), Frequency = integer(0))
for (unit_id in section_1) {
  subset_df <- BLS_incidents_df[BLS_incidents_df$GeoFirstDue == unit_id, ]
  frequency_table <- table(subset_df$GeoFirstDue)
  frequency_df <- data.frame(GeoFirstDue = names(frequency_table), Frequency = as.vector(frequency_table))
  result_df <- rbind(result_df, frequency_df)
}


# Aggregate and sum the frequencies for each GeoFirstDue value
result_df <- aggregate(Frequency ~ GeoFirstDue, result_df, sum)



# Order the data frame in descending order 
result_df <- result_df[order(-result_df$Frequency), ]

print(result_df)

## Distance (For now, it is evaluated with the map)

## Goal 4
((297.02-293.98)/293.98)*100
