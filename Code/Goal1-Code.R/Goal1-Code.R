## Hi, hope you have fun reading the notes and code! -Paola


df <- read.csv("Dataflat.csv")


## Rename Incidenty type to just have two categories for ALS and BLS

#---- install.packages("dplyr")

library(dplyr)
df <- df %>%
  mutate(
    FinalIncidentType = recode(FinalIncidentType,
                               "ALS"    = "ALS",
                               "ALPHA"  = "ALS",
                               "BRAVO"  = "ALS",
                               "MEDICAL"= "BLS",
                               "CHARLIE"= "BLS"
    )
  )

##Checking Unique values: (Just ALS AND BLS + Others)
unique(df$FinalIncidentType)

#Filter for needed columns (I added some, if needed we can add more)

df <- df %>%
  select(EventID, IncidentNumber, UnitIdSummarized, GeoFirstDue, 
         CallConfirmedDT, CalcCall2FirstDispatch, CalcCall2FirstArrive, 
         CalcFirstDispatch2LastClear, CallConfirmedDT,FinalIncidentType)



#Filtering just the BLS (Ambulances)
desired_unit_ids <- c("A408", "A409", "A410", "A412", "A415", "A416",
                      "A420", "A427", "A431", "A441", "A440", "A444")

df_BLS <- df %>%
  filter(UnitIdSummarized %in% desired_unit_ids)

UnitIdSummarized_BLS<- unique(df_BLS$UnitIdSummarized)
print(UnitIdSummarized_BLS)

#Filtering ALS (Medics)

df_ALS <- df %>%
  filter(grepl("^M4", UnitIdSummarized))
  UnitIdSummarized_ALS<- unique(df_ALS$UnitIdSummarized)
  print(UnitIdSummarized_ALS)
  
  
  
  ##------------- Focusing Analysis in BLS units:
  ##------- Initial DATA CLEANING (Exploration of missing values)
  
  ## Indentification of missing values: 
  
  missing_percentage <- df_BLS %>%
    summarise_all(~ sum(is.na(.)) / n() * 100)
  
  ##--- install.packages("ggplot2")
  ##--- install.packages("tidyr")
  
  library(ggplot2)
  
  missing_percentage <- as.data.frame(missing_percentage)
  
  # Extracting column names
  column_names <- colnames(missing_percentage)
  
  # Extracting the percentage of missing values
  missing_percentages <- as.numeric(missing_percentage)
  
  # Print the lists 
  print("Column Names:")
  print(column_names)
  
  print("Percentage of Missing Values:")
  print(missing_percentages)
  
  missing_data_frame <- data.frame(Column = column_names, 
                                   MissingPercentage = missing_percentages)
  missing_data_frame
  
  # Create a bar chart
  
  # Order the data by Missing values Percentage in descending order
  missing_data_frame <- missing_data_frame[order(-missing_data_frame$MissingPercentage),]
  
  # Bar chart
  bar_chart <- ggplot(missing_data_frame, aes(x = reorder(Column, desc(MissingPercentage)), y = MissingPercentage)) +
    geom_bar(stat = "identity", fill = "#0073E5", color = "black") +  # Custom colors
    geom_text(aes(label = sprintf("%.2f%%", MissingPercentage)), 
              vjust = -0.3, size = 4, color = "black") +  #percentage labels
    labs(x = NULL, y = "Percentage of Missing Values") +
    theme_minimal(base_size = 14) +  # theme
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
          axis.title.y = element_text(size = 14, vjust = 1.5),
          panel.grid.major.y = element_line(color = "gray", size = 0.25),  # y-axis grid lines
          plot.title = element_text(size = 18, face = "bold", hjust = 0.5)) +  
    ggtitle("Percentage of Missing Values by Column")  
  

  print(bar_chart)
  
  
  ##------------ Exploration of outliers: 
  
  ##--- Boxplots for numerical columns
  
  selected_columns <- c("CalcCall2FirstDispatch",
                        "CalcCall2FirstArrive", "CalcFirstDispatch2LastClear")
  
  numerical_data <-  df_BLS %>%
    select(all_of(selected_columns))
  
  # Stack the data for boxplot
  stacked_data <- stack(numerical_data)
  
  # Boxplot
  
  boxplot <- ggplot(stacked_data, aes(x = ind, y = values)) +
    geom_boxplot(fill = "#3498db", color = "#2c3e50", alpha = 0.8, 
                 size = 0.7, outlier.colour = "#2c3e50", outlier.shape = 1, 
                 outlier.size = 3) +
    theme_minimal(base_size = 14) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 14, vjust = 1.5)) +
    labs(x = NULL, y = "Time (Seconds)") +
    ggtitle("Boxplot of Numerical Values for BLS Units") +
    scale_x_discrete(labels = c("Call Processing Time", 
                                "Response Time", "Incident Duration")) +
    theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5))
  

  print(boxplot)
  
  summary(df_BLS$CalcCall2FirstArrive)
  summary(df_BLS$CalcCall2FirstDispatch)
  summary(df_BLS$CalcFirstDispatch2LastClear)
  
  # Checking the length of the filtered data before outlier removal
  nrow(df_BLS)
  
  ##---- Remoiving outliers by IQR Rule: 
  ## Response time
  
     Q1 <- quantile(df_BLS$CalcCall2FirstArrive, 0.25,  na.rm = TRUE)
     Q3 <- quantile(df_BLS$CalcCall2FirstArrive, 0.75, na.rm = TRUE)
  
     # Calculate IQR
     IQR_value <- Q3 - Q1
  
     # Define outlier bounds
     lower_bound <- Q1 - 1.5 * IQR_value
     upper_bound <- Q3 + 1.5 * IQR_value
  
     # Filter the data, removing outliers
     df_BLS <- df_BLS %>%
     filter(CalcCall2FirstArrive >= lower_bound & CalcCall2FirstArrive <= upper_bound)
 
  ## Call Processing time
  
     Q1 <- quantile(df_BLS$CalcCall2FirstDispatch, 0.25, na.rm = TRUE)
     Q3 <- quantile(df_BLS$CalcCall2FirstDispatch, 0.75, na.rm = TRUE)
  
     # Calculate IQR
     IQR_value <- Q3 - Q1
  
     # Define outlier bounds
     lower_bound <- Q1 - 1.5 * IQR_value
     upper_bound <- Q3 + 1.5 * IQR_value
  
     # Filter the data, removing outliers
     df_BLS <- df_BLS %>%
     filter(CalcCall2FirstDispatch >= lower_bound & CalcCall2FirstDispatch <= upper_bound)
  
  ## Incident Duration 
     
     Q1 <- quantile(df_BLS$CalcFirstDispatch2LastClear, 0.25, na.rm = TRUE)
     Q3 <- quantile(df_BLS$CalcFirstDispatch2LastClear, 0.75, na.rm = TRUE)
     
     # Calculate IQR
     IQR_value <- Q3 - Q1
     
     # Define outlier bounds
     lower_bound <- Q1 - 1.5 * IQR_value
     upper_bound <- Q3 + 1.5 * IQR_value
     
     # Filter the data, removing outliers
     df_BLS <- df_BLS %>%
     filter(CalcFirstDispatch2LastClear >= lower_bound & CalcFirstDispatch2LastClear <= upper_bound)
     
  ## Boxplot without outliers: 
     
     summary(df_BLS$CalcCall2FirstArrive)
     summary(df_BLS$CalcCall2FirstDispatch)
     summary(df_BLS$CalcFirstDispatch2LastClear)
     
     # Check the length of the filtered data after outlier removal
     nrow(df_BLS)
  
     
     # Boxplot
     selected_columns <- c("CalcCall2FirstDispatch", "CalcCall2FirstArrive", "CalcFirstDispatch2LastClear")
     
     numerical_data <-  df_BLS %>%
       select(all_of(selected_columns))
     
     # Stack the data for boxplot
     stacked_data <- stack(numerical_data)
     boxplot <- ggplot(stacked_data, aes(x = ind, y = values)) +
       geom_boxplot(fill = "#3498db", color = "#2c3e50", alpha = 0.8, 
                    size = 0.7, outlier.colour = "#2c3e50", outlier.shape = 1, outlier.size = 3) +
       theme_minimal(base_size = 14) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
             axis.title.x = element_blank(),
             axis.title.y = element_text(size = 14, vjust = 1.5)) +
       labs(x = NULL, y = "Time (Seconds)") +
       ggtitle("Boxplot of Numerical Values for BLS Units") +
       scale_x_discrete(labels = c("Call Processing Time", "Response Time", "Incident Duration")) +
       theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5))
     
     # Display the updated boxplot
     print(boxplot) 
     
     ##----- Response time by BLS units: 
     
     # Calculate the median of CalcCall2FirstArrive (Response time) for each transport unit
     median_first_arrive <- df_BLS %>%
       group_by(UnitIdSummarized) %>%
       summarise(ResponseTime_median = median(CalcCall2FirstArrive, na.rm = TRUE))
     
     print(median_first_arrive)
     
     #Calculation of the 90th percentile for response time
     percentile_90th <- df_BLS %>%
       group_by(UnitIdSummarized) %>%
       summarise(ResponseTime_90th = quantile(CalcCall2FirstArrive, probs = 0.9, na.rm = TRUE))
     
     print(percentile_90th)
     
     
     
     ## Incidents hotspots of BLS transport units
     Incidents_FreqBLS <- df_BLS %>%
       group_by(GeoFirstDue) %>%
       summarise(Incident_Frequency = n_distinct(IncidentNumber)) %>%
       arrange(desc(Incident_Frequency))
     
     Incidents_FreqBLS
     
     ## BLS Incidents hotspots by Demand (Using the whole Dataset and the Column
     ## of FinalIncidentType :) )
     
     IncidentsBLS_Demand <- df %>%
       filter(FinalIncidentType == "BLS") %>%
       group_by(GeoFirstDue) %>%
       summarise(Incident_Frequency = n_distinct(IncidentNumber)) %>%
       arrange(desc(Incident_Frequency))
      
       IncidentsBLS_Demand 
         
         
## BARCHARTS FOR BLS UNITS AND RESPONSE TIME
     
     ##----------- Bar chart for response time: 
     # Create a bar chart
     median_first_arrive <- median_first_arrive %>%
       arrange(desc(ResponseTime_median))
     
     
     ##-------------------------------
     ## Chart with blue and red.
     
     median_first_arrive <- df_BLS %>%
       group_by(UnitIdSummarized) %>%
       summarise(ResponseTime_median = median(CalcCall2FirstArrive, na.rm = TRUE))
     
     # Arrange the data for plotting
     median_first_arrive <- median_first_arrive %>%
       arrange(desc(ResponseTime_median))
     
     # Define the colors for bars based on ResponseTime_median
     subdued_blue <- "#4682B4"  
     soft_orange <- "#FFA07A"
     warning_color <- "#FF0000"  
     
     ### MEDIAN BARCHART:
     bar_chart <- ggplot(median_first_arrive, aes(x = reorder(UnitIdSummarized, ResponseTime_median), y = ResponseTime_median)) +
       geom_bar(stat = "identity", fill = ifelse(median_first_arrive$ResponseTime_median > 390, warning_color, subdued_blue)) +
       geom_hline(yintercept = 390, color = soft_orange, linetype = "dashed", size = 1) +
       theme_minimal(base_size = 14) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
             axis.title.x = element_blank(),
             axis.title.y = element_text(size = 14, vjust = 1.5)) +
       labs(x = "Unit", y = "Response Time (Seconds)") +
       ggtitle("Median Response Time by BLS Units")
     
     # Display the bar chart
     print(bar_chart)
     
     ## Chart with gradient color
    
     # Define the colors for the gradient
     low_color <- "#4682B4"  # Blue for low response times
     high_color <- "#FF0000"  # Red for high response times
     
     # Create a bar chart with a gradual color scale
     bar_chart <- ggplot(median_first_arrive, aes(x = reorder(UnitIdSummarized, ResponseTime_median), y = ResponseTime_median, fill = ResponseTime_median)) +
       geom_bar(stat = "identity") +
       scale_fill_gradient(low = low_color, high = high_color) +
       geom_hline(yintercept = 390, color = soft_orange, linetype = "dashed", size = 1) +
       theme_minimal(base_size = 14) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
             axis.title.x = element_blank(),
             axis.title.y = element_text(size = 14, vjust = 1.5)) +
       labs(x = "BLS Unit", y = "Response Time (Seconds)") +
       ggtitle("Median Response Time by BLS Units") +
       scale_x_discrete(labels = scales::wrap_format(20)) +
       theme(axis.text.x = element_text(size = 8), axis.title.x = element_text(size = 14))
     
     # Display the bar chart
     print(bar_chart)
     
     ### 90TH PERCENTILE BARCHART: 
     
     percentile_90th <- percentile_90th %>%
       arrange(desc(ResponseTime_90th))
     
     bar_chart <- ggplot( percentile_90th, aes(x = reorder(UnitIdSummarized, ResponseTime_90th), y = ResponseTime_90th, fill = ResponseTime_90th)) +
       geom_bar(stat = "identity") +
       scale_fill_gradient(low = low_color, high = high_color) +
       geom_hline(yintercept = 390, color = soft_orange, linetype = "dashed", size = 1) +
       theme_minimal(base_size = 14) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
             axis.title.x = element_blank(),
             axis.title.y = element_text(size = 14, vjust = 1.5)) +
       labs(x = "BLS Unit", y = "Response Time (Seconds)") +
       ggtitle("90th Percentile Response Time by BLS Units") +
       scale_x_discrete(labels = scales::wrap_format(20)) +
       theme(axis.text.x = element_text(size = 8), axis.title.x = element_text(size = 14))
     
     # Display the bar chart
     print(bar_chart)
     
     ## This everything for now, hope you had fun! @Xioaquing, I want more cookies :")
     
     
     
     
     
     
    
     
    
  
     