# Datasets

## Data-set Overview 
The data analyzed in this project is sourced from the Fairfax County Fire and Rescue Department. The project encompasses the exploration and analysis of two datasets structured as tabular data. These datasets contain a range of variables relevant to the records of the unit responses to emergency medical services calls in Fairfax County, where each row represents an incident and each column, a specific attribute related to the incident.  
The data was collected directly from FCFRD covering the period from January 2021 through August 2023, derived from actual incidents recorded by the responding personnel. The dataset contains incident-related information across multiple attributes such as the identification of the incident, description of the incident, EMS categories, the time for various stages of the incident, and response time. The data was given as flat data and raw data being filtered data and unfiltered data respectively. The data raw contains 1,048,576 rows and 530,382 for data flat. From those, 73,699 and 215,012 are unique rows for raw and flat, respectively.  


## Data Profile 
Dataset Owner: Fairfax County & Rescue Department​

Dataset Type: Proprietary​

Dataset Size: 171.2MB​

Dataset Location: Internet​

Dataset Access: Microsoft Onedrive ​

Dataset Restrictions: No restrictions.​

Dataset Time Range: January 2021- August 2023​

Dataset Collection Process: Based on incidents and automation.​

Analytic/Algorithm that will use dataset: Dispatching algorithm.


## Data Context 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/e6ce9f1f-6d6c-4691-a2a1-c329a1e80c5d)
The Fairfax County & Rescue Department's data collection process for their FRD system initiates with a 911 call and concludes after incident support completion. Key steps include gathering incident details at the call center and initiating the dispatch alarm. The dataset records critical variables like the geographical response area, unit status, assigned fire station, and care level required (ALS or BLS).

Each incident in the dataset is uniquely identified and includes initial and confirmed incident types, processing time, and factors affecting it. Additionally, response columns detail personnel types in units and track various timestamps of unit activity, relying on manual entries by first responders. While generally accurate, these entries can occasionally have inconsistencies or missing values, which are important for data exploration and error identification.

The dataset ensures patient privacy by excluding specific personal information. It includes both manually entered and system-generated data, offering comprehensive insight into incident and response dynamics.

## Data Conditioning 
1. Missing Value Handling: Key variables with missing data removed; imputation of average response times for certain variables.

2. Error Rectification: Statistical analysis and machine learning used to identify and correct data inconsistencies and outliers.

3. Data Standardization: Uniform treatment of missing values, replaced with "NA" for consistency and ease of analysis.

4. Validation and Testing: Comprehensive examination to ensure accuracy and integrity of the cleaned dataset, confirming error rectification.

## Data Quality

