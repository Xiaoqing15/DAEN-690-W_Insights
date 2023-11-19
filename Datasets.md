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
1. Completeness: 
Analyzing the Fairfax County FRD emergency response data (1/01/2021 to 8/31/2023), we find two types of missing values ('NA' and empty cells), with missing data often contextually relevant rather than indicative of recording errors, as seen in columns like 'UnitWithPatientDT' and 'CalcCall2FirstArrive'.
2. Uniqueness:
The Fairfax County FRD emergency response data (1/01/2021-8/31/2023) shows context-specific missing values, like 'NA' or empty cells, indicating varied incident scenarios rather than data errors.
3. Accuracy:
The dataset was sourced from the FRD's data warehouse, where they adhere to strict and standardized protocols for incident reporting, patient care documentation, and data collection. Additionally, FRD's commitment to regular and timely data updates is vital for maintaining data accuracy, particularly in dynamic sectors like emergency services. These collective practices ensure the dataset's high accuracy in this project. For privacy reasons, the locations or outcomes of the EMS incidents are not provided in this dataset.
4. Atomicity:
According to the data collection and data storage, each EMS incident can be treated as an atomic unit of data.
5. Conformity:
The dataset exhibits a high level of consistency in its contents. For instance, the Incident Number follows a consistent pattern starting with 'E,' followed by the two-digit year, three-digit Julian date, and a four-digit sequential number. Additionally, time intervals are consistently represented in seconds, timestamps adhere to the "mm/dd/yyyy hh:mm:ss" format, and incident types are uniformly abbreviated and aligned with those found in the dispatch algorithms document.
6. Overall Quality: 
The overall quality of the flat data is generally good. However, it is essential to acknowledge certain limitations, notably the absence of data related to the locations or outcomes of the EMS incidents. These missing components could potentially impact the accuracy and depth of subsequent research findings. (This aspect will be reevaluated after conducting further research.)



