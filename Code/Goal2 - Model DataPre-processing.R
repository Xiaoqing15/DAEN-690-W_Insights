getwd()
setwd('/Users/amber/Documents/DAEN-690/dataset/data_dnn')
library(tidyverse)
library(lubridate)
library(gridExtra)
library(stringr)

#df0 <- read.table("DataFlat.txt",header=TRUE, sep="|")
#remove rows reponse_time is na
#df1 <- df0[!is.na(df0$CalcCall2FirstArrive), ]
#write.csv(df1, file = "df_dnn1.csv", row.names = FALSE)

# In excel, description columns were removed, times are transformed
# to 0-1 (0-24hours), the dataset is split by 2023/08/07. EMS category is divided into 1(A), 2(B)

#read old 
df_dnn <- read.csv("df_dnn_old.csv", header=TRUE, sep=',')
#drops rows of geofirstdue having NAs
df_dnn1 <- df_dnn[!is.na(df_dnn$GeoFirstDue), ]

#add coordination of stations
df_coord <- df_dnn <- read.csv("coordinate_of_stations.csv", header=TRUE, sep=',')
df_dnn2 <- left_join(df_dnn1, df_coord, by=c("GeoFirstDue" = "station"))

#remove stations other than 39
df_dnn3 <- df_dnn2[!is.na(df_dnn2$incident_amount), ]


###numberize incident type
#ALS
df_dnn3$InitialIncidentType[which(df_dnn3$InitialIncidentType == "ALS")] <- 1
df_dnn3$DispatchedIncidentType[which(df_dnn3$DispatchedIncidentType == "ALS")] <- 1
df_dnn3$ArrivedIncidentType[which(df_dnn3$ArrivedIncidentType == "ALS")] <- 1
df_dnn3$FinalIncidentType[which(df_dnn3$FinalIncidentType == "ALS")] <- 1

#MEDICAL
df_dnn3$InitialIncidentType[which(df_dnn3$InitialIncidentType == "MEDICAL")] <- 2
df_dnn3$DispatchedIncidentType[which(df_dnn3$DispatchedIncidentType == "MEDICAL")] <- 2
df_dnn3$ArrivedIncidentType[which(df_dnn3$ArrivedIncidentType == "MEDICAL")] <- 2
df_dnn3$FinalIncidentType[which(df_dnn3$FinalIncidentType == "MEDICAL")] <- 2

#ACCIF
df_dnn3$InitialIncidentType[which(df_dnn3$InitialIncidentType == "ACCIF")] <- 3
df_dnn3$DispatchedIncidentType[which(df_dnn3$DispatchedIncidentType == "ACCIF")] <- 3
df_dnn3$ArrivedIncidentType[which(df_dnn3$ArrivedIncidentType == "ACCIF")] <- 3
df_dnn3$FinalIncidentType[which(df_dnn3$FinalIncidentType == "ACCIF")] <- 3

#ODF
df_dnn3$InitialIncidentType[which(df_dnn3$InitialIncidentType == "ODF")] <- 4
df_dnn3$DispatchedIncidentType[which(df_dnn3$DispatchedIncidentType == "ODF")] <- 4
df_dnn3$ArrivedIncidentType[which(df_dnn3$ArrivedIncidentType == "ODF")] <- 4
df_dnn3$FinalIncidentType[which(df_dnn3$FinalIncidentType == "ODF")] <- 4

#CPRF
df_dnn3$InitialIncidentType[which(df_dnn3$InitialIncidentType == "CPRF")] <- 5
df_dnn3$DispatchedIncidentType[which(df_dnn3$DispatchedIncidentType == "CPRF")] <- 5
df_dnn3$ArrivedIncidentType[which(df_dnn3$ArrivedIncidentType == "CPRF")] <- 5
df_dnn3$FinalIncidentType[which(df_dnn3$FinalIncidentType == "CPRF")] <- 5

#Other types
df_dnn3$InitialIncidentType <- ifelse(df_dnn3$InitialIncidentType %in% c(1, 2, 3, 4, 5), 
                                      df_dnn3$InitialIncidentType, 6)
df_dnn3$DispatchedIncidentType <- ifelse(df_dnn3$DispatchedIncidentType %in% c(1, 2, 3, 4, 5), 
                                      df_dnn3$DispatchedIncidentType, 6)
df_dnn3$ArrivedIncidentType <- ifelse(df_dnn3$ArrivedIncidentType %in% c(1, 2, 3, 4, 5), 
                                      df_dnn3$ArrivedIncidentType, 6)
df_dnn3$FinalIncidentType <- ifelse(df_dnn3$FinalIncidentType %in% c(1, 2, 3, 4, 5), 
                                      df_dnn3$FinalIncidentType, 6)

#identify Unittype
df_dnn4 <- df_dnn3 %>%
  mutate(unit_letter = str_extract(UnitId, "[A-Za-z]+"),
         unit_number = str_extract(UnitId, "\\d+"))
##dd coord where units start from
df_coord_unit <- read.csv("coordinate_of_units.csv", header=TRUE, sep=',')
df_dnn4$unit_number <- as.integer(df_dnn4$unit_number)
df_dnn5 <- left_join(df_dnn4, df_coord_unit, by=c("unit_number" = "units_from"))
##remove units not in fairfax
df_dnn6 <- df_dnn5[!is.na(df_dnn5$unit_coord_x), ]
##remove rows of staffs (end with letter)
indices_to_remove <- grep("[A-Za-z]$", df_dnn6$UnitId)
df_dnn7 <- df_dnn6[-indices_to_remove, ]
#ggplot(df_dnn7) +
#  geom_bar(aes(x=unit_letter)) +
#  coord_flip()
##E-1, M-2, A-3, R-4
df_dnn7$unit_type <- ifelse(df_dnn7$unit_letter == "E", 1, 
                        ifelse(df_dnn7$unit_letter == "M", 2, 
                           ifelse(df_dnn7$unit_letter == "A", 3, 
                              ifelse(df_dnn7$unit_letter == "R", 4, NA))))
#remove other unit types
df_dnn8 <- df_dnn7[!is.na(df_dnn7$unit_type), ]
#!!!!!identify bls_trans
df_dnn8$bls_trans <- 0
df_dnn8$bls_trans <- ifelse(df_dnn8$unit_number %in% 
                              c(408, 409, 410, 412, 415, 416, 420, 427, 431, 441, 440, 444) & df_dnn8$unit_type == 3, 1, 0)

#check and remove outliers
#response_time 
response_time_1 <- quantile(df_dnn8$response_time, 0.01)
response_time_99 <- quantile(df_dnn8$response_time, 0.99)
df_dnn9 <- df_dnn8[df_dnn8$response_time >= response_time_1 & df_dnn8$response_time <= response_time_99, ]
#call_processing
df_dnn10 <- df_dnn9[!is.na(df_dnn9$call_processing_time), ]
call_processing_time_1 <- quantile(df_dnn10$call_processing_time, 0.01)
call_processing_time_99 <- quantile(df_dnn10$call_processing_time, 0.99)
df_dnn11 <- df_dnn10[df_dnn10$call_processing_time >= call_processing_time_1 & df_dnn10$call_processing_time <= call_processing_time_99, ]
#call_to_arrive
sum(!df_dnn11$call_to_arrive == '#VALUE!')
df_dnn12 <- df_dnn11[!df_dnn11$call_to_arrive == '#VALUE!', ]


#add BLS station switch
df_dnn12$bls_station <- 0
df_dnn12$bls_station <- ifelse(df_dnn12$GeoFirstDue %in% 
                                 c(408, 409, 410, 412, 415, 416, 420, 427, 431, 441, 440, 444), 1, 0)
#write.csv(df_dnn12, file = "df_dnn12_v1.csv", row.names = FALSE)

#clean dataset
#sum(is.na(df_dnn13$turnout))
#unique(df_dnn13$call_processing_time)
df_dnn13 <- read.csv("df_dnn12_v1.csv", header=TRUE, sep=',')
df_dnn14 <- df_dnn13[!is.na(df_dnn13$DispitchedEMScategory), ]
df_dnn15 <- df_dnn14[!(df_dnn14$FinalEMScategory == '' | df_dnn14$FinalEMScategory == 'NULL'), ]
df_dnn16 <- df_dnn15[!is.na(df_dnn15$incident_duration), ]
df_dnn17 <- df_dnn16[!is.na(df_dnn16$turnout), ]


write.csv(df_dnn17, file = "df_dnn17.csv", row.names = FALSE)

#dataset only for BLS
df_bls_v1 <- df_dnn17[df_dnn17$UnitId %in% c("A408", "A410", "A412", "A415", "A416", 
                                         "A420", "A427", "A431", "A441", "A440",
                                         "A409", "A444"), ]
#write.csv(df_bls_v1, file = "df_bls_v1.csv", row.names = FALSE)


