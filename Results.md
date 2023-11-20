# Results of Optimal Allocation Approaches

## Current Allocation of 12 BLS 
Main Focus - Are those 12 existing ambulances (BLS transport units) meeting the response time benchmark for the FCFRD?
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/a6a05814-321e-4a4d-a3c5-4a1acd6a34d8)

### Response time of current allocation
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/8b6aa78e-ac3e-4dc1-9d64-766eb371dd97)

The results obtained for the response time of the current 12 BLS units are shown in Figure 14. As a reference, the first bar chart presents the averages of response time of the BLS units and the second, the 90th percentile response time. The orange line indicates the response time benchmark for the FCFRD, which is 390 seconds.

The results of the from the average response time for the ambulances showed that just 5 of them are currently below the department benchmark, which means that 7 are above the goal of response time. The ambulances A410, A409, A431, A427, and A408 have the lowest response time between 363.57 to 384.48 seconds. While the ambulances A412, A441, A416 were identified as the units with the highest response time between 417.45 to 486.78 seconds.

## Comparing All 3 Allocation Approaches Visually 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/8e260f06-867f-42a2-91cf-a42fd5a01ff2)

## Description of the 3 Optimal Allocation 
### 1. General Analysis
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/a66b97db-d7fa-4214-a067-476ac915c30c)

In Figure above, we presented where the top 8 ambulances with the highest response time are sent the most. As a reference to understand this analysis, the attribute that represents where the incidents are sent is collected by the geographical area related with a station, which is why on the x-axis we have the label as station. Those stations (areas where they are sent the most) represented by blue are one of the current ambulances units and the orange are potential ambulances from the analysis. 
We identified that from those top 20 geographical are 7 areas where they are sent the most, which was interesting because we expected to have at least the 8 areas from where those top 8 BLS are located. The area that was missing was the one at station 420. After analyzing where the ambulance A420 is sent the most we identify that it mostly covers the area of station 419, which is within the top 20 in Figure 20. Therefore, we also consider that ambulance A420 for the potential allocation.
The next step was deciding if we keep the remaining 4 current ambulances. And, based on the analysis from the evaluation of the current evaluation, those 4 areas where they are located are BLS incidents hotspots and where BLS units are sent the most.

After this analysis, the potential 20 ambulances stations are the current 12 that the department has and an additional 8, which are: 421, 419, 429, 426, 401, 413, 436, and 417.

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/9a67f445-2135-4dd0-a2e7-fbfd1b0d160e)


### 2. Greedy Search 
Our Greedy Search method is designed to minimize the travel distance from BLS to incidents. As the actual locations of the incidents are unavailable, we estimate the travel distance from the BLS location to the stations that first respond to the incidents. In cases where the incident occurs at a station with a BLS unit, the travel distance is assumed to be 0. Conversely, if the incident takes place near a station without a BLS unit, the travel distance is computed based on the Euclidean distance from the incident station to the nearest BLS. The following outlines the steps of the method:
* Retrieve Coordinates for 39 Fire Stations
A figure of the Fairfax County Fire and Rescue Department's 2021map with the 39 Fire Stations annotated is loaded into Matlab as a 2D object. Then by the built-in command “getpts”, the pixel-based 2D X-Y coordinates of the 39 stations are obtained as we click each Fire Station sequentially. Since the lower left corner of the figure is taken as the reference base of the coordinate system, the X-Y coordinates indicate the relative location of the 39 Fire Stations accordingly (refer to data in Appendix F). It is not necessary to obtain the practical locations of the Fire Stations because the relative distance between any two stations is concerned. 
* Compute Distance Matrix for the 39 Stations
The Euclidean Distance is employed to calculate the distance between each pair of the 39 stations. The formula for Euclidean Distance between two points (x1, y1) and (x2, y2) in a two-dimensional space is given by: ![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/9f6a1613-4b91-4b23-88f5-a2ad95f48d32)

* Greedy Search Implementation
The Greedy Search aimed to optimize the spatial distribution of two distinct groups of stations, those equipped with (BLS) and those without. The core objective of the algorithm is to ascertain a configuration that minimizes the cumulative distance between these two groups. 
The algorithm initiates with the setting of a tries counter to zero, which is used to limit the iterations of the optimization process to 100,000. This constraint ensures computational feasibility while allowing for a thorough exploration of possible configurations. Two key lists, sum_distance_list and without_bls_list, are initialized to store the cumulative distances for each iteration and the corresponding station combinations, respectively.
Each iteration of the algorithm begins with the random selection of nine stations from a predefined list of stations under consideration (station_to_consider), utilizing the random sample method. The algorithm then segregates the stations into two groups: one (with BLS) comprising a predefined list of stations with BLS augmented by the randomly selected stations, and the other (without BLS) consisting of the remaining stations.
For each station in the without BLS group, the algorithm calculates its distance to every station in the with BLS group. These distances are determined based on a pre-existing distance matrix. The minimum distance from each station in the without BLS group to any station in the with BLS group is computed and aggregated. This aggregation represents the total minimum distance for the particular configuration of station groups being evaluated.

Greedy Search algorithm in Python 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/e589a2f6-69a7-43fb-a858-c29fd0603947)

Upon completion of all iterations, the algorithm identifies the configuration that yields the smallest cumulative minimum distance. This optimal configuration is then output, providing a potential solution for the optimal spatial distribution of resources across the two groups of stations.

The result below shows the output of four different iterations using the Greedy approach. 
 ![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/24ec4ceb-b48d-40f9-ae54-4c413d86cd70)


The first and initial iteration of the algorithm yields the most favorable result, achieving the lowest cumulative sum of distances at 1945.72. This outcome also identifies a set of 19 stations that can effectively operate without a BLS unit. Consequently, this leaves the remaining 20 stations equipped with BLS, thus optimizing the distribution of emergency healthcare resources. 

In summary, the map visually represents the optimal placement of the 20 units as determined by our methodology. This configuration includes 10 existing BLS stations (**408, 409, 410, 415, 416, 427, 431, 441, 440, 444**), complemented by an additional 10 stations (**404, 414, 417, 419, 421, 422, 426, 430, 439, 442**) strategically recommended by the algorithm's output for BLS implementation.

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/5268739e-1f5d-4fa1-bf73-345201aad227)


### 3. Partition Approach
#### Partition Method Implementation
The Partition Method was employed to optimize the coverage and response efficiency of Basic Life Support (BLS) units across various sections of the jurisdiction. The principal aim was to ensure that BLS units were strategically placed to serve areas with high incident frequencies and longer response times effectively. The process began with initializing the data into a structured data frame. A comprehensive list of all fire stations within the county was generated, followed by the strategic grouping of these stations into distinct sections, with each section containing a cluster of stations required BLS response. The frequency of these incidents was then tallied for each station, leading to the identification of stations with the highest call volumes - the incident hotspots. The sections were then scrutinized individually, calculating the average frequency of incidents for each. For BLS allocation, the Fairfax County was divided into 10 sections to compute the cumulative incident frequency within each section. Another function quantified the existing BLS stations within these sections. The image below helps in better understnading the partitioning.

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/4c504aaa-9d29-419c-b267-0952e51e0a83)


The Partition Method also included a thorough evaluation of specific sections. This involved an assessment of current BLS station placements against the frequency of incidents, respons1e time and sections that did not have a BLS unit, guiding the strategic positioning of new BLS units.

### Results of sections above the number of avg incidents :- 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/06aa9b13-0873-40b1-b8c8-706e9c04c683)

### Results of sections above the avg response time :- 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/81eb3482-21bb-4aac-b694-aa74be75e64f)

The initial iteration of the Partition Method achieved an optimal outcome by effectively identifying key sections requiring additional support based on a comprehensive analysis of incident frequencies, response times, and BLS unit availability in Fairfax County. Sections 7, 3, 5, 2, and 10 were highlighted due to their incident rates being above the average of 805.03. Sections 8, 5, 6, 4, and 10 were pinpointed because their response times exceeded the average response time of 412.78 seconds. Additionally, section 6 was identified as a critical area due to the absence of a BLS unit.
This strategic approach led to the selection of eight primary sections— 2, 3, 4, 5, 6, 7, 8 and 10—for enhanced BLS coverage. By concentrating on these sections, the method ensures an optimized allocation of emergency healthcare resources across the county, promoting a more balanced and efficient response system. In comparison to the previous allocation, this new strategy involves changing the location of three BLS units. The current BLS stations are 408, 409, 410, 415, 416, 420, 427, 431, 441, 440, and 444, with station 412 having been removed. The proposed additional eight stations, selected to enhance coverage in the identified sections, are 411, 417, 419, 421, 425, 426, 429, 430, and 436. This reconfiguration signifies a crucial step towards improving the overall effectiveness and efficiency of the BLS system in Fairfax County, ensuring quicker and more reliable responses to emergencies in the most critical areas.

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/a6ef9509-98b4-499b-a430-efb3c83fd7fb)

## Comparing ALL 3 Allocation Approaches Visually 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/8e260f06-867f-42a2-91cf-a42fd5a01ff2)


# Results of Dispatch Algorithm 
### Comparison of Call Processing Time Before and After New Dispatch Algorithm Implementation Across All Incident Types
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/1b0b4d6d-2a0b-4b4e-b057-86586f5232a7)

Prior to the implementation of the new system, the average call processing time was 99.73 seconds (about 1 and a half minutes). Following its introduction, this time increased to 112.35 seconds (around 12.6%). This increment is anticipated and can be attributed to the revised protocol for handling 911 calls. Call takers now engage in a more thorough questioning process, gathering detailed information about the incident. This approach ensures that the most appropriate units are dispatched to the incident location, which consequently leads to an increase in call processing time, but it also significantly increases the accuracy in dispatching the correct units. This meticulous method is designed to minimize the likelihood of needing to send additional units later, thereby streamlining the overall response process and improving the efficiency of emergency services.

The second graph below shows the Response Time before and after the algorithm, also including all incident types. 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/ff9a0fc1-945f-4f78-beec-67b8eb926ceb)

In this analysis, the expectation was that the new dispatch algorithm would lead to a reduction in response times. Contrary to these expectations, the data indicated an approximate increase of 2.7% in response times following the algorithm's implementation.

The following graphs will show the same analysis for incident types where ALS and BLS units are sent:- 

* Call processing time analysis for ALS and BLS incident types
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/8c80e0a5-7977-4e56-a203-9bac9515f866)

* Response time analysis for ALS and BLS incident types
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/eba6dc4a-9755-4657-bf7d-d22593fea34c)

When the data was further filtered to focus solely on incidents involving ALS and BLS, a similar trend was observed, mirroring the overall pattern noted in the general analysis. Specifically, there was a marked 19.35% increase in Call Processing Time when comparing the periods before and after the implementation of the new algorithm, but exclusively for ALS/BLS incidents. This highlights a consistent rise in the duration of call handling. Additionally, the Response Time for ALS/BLS incidents also showed an increase of 5.35%. This data underscores the impact of the new dispatch algorithm on the specific subset of ALS/BLS emergency responses, revealing a consistent pattern across different types of emergency incidents.

To conclude our analysis on the dispatch algorithm's impact, we specifically studied the “FinalIncidentType” and “DispatchedIncidentType” columns. This comparative evaluation aimed to assess the efficiency of the increased call processing time. Our findings revealed a significant improvement in dispatch accuracy: prior to the algorithm's implementation, only 88% of cases showed a match between the dispatched and final incident types. However, post-implementation, this accuracy increased notably, with over 92% of the incidents in these columns now matching. This increase in matching percentages underscores the effectiveness of the extended call processing time, affirming its crucial role in enhancing the precision and appropriateness of unit deployment in response to emergency incidents.



