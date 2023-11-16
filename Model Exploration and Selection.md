# ML Model Exploration and Selection

## Solution Approach

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/2eb82ca7-6134-49bb-8a55-ab2a4aaa6923)
1. Resource Allocation Methods :- 
*	General Analysis, addresses the ambulance allocation issue, begin by analyzing the top 8 stations with the highest response times. Investigate the discrepancy between these stations and the top 7 areas where ambulances are frequently dispatched. Specifically, examine why station 420 is an outlier. Next, evaluate whether to retain the 4 remaining ambulances based on their location in BLS incident hotspots and frequent dispatch areas, using the current evaluation data.
*	Greedy Search, which involves segmenting the area into smaller regions. For each of these regions, we identify the coordinates of units and their respective stations. By analyzing the distance, we can approximate the response time within each region based on the number of ambulances allocated to it.
Subsequently, for each region, we employ the Greedy Search technique to determine precise locations for positioning the allocated responders, optimizing their placement to minimize response times effectively. 
* Partition Method, in this, Fairfax County was divided into ten sections, each containing about four fire stations, to analyze BLS incident response times and frequencies. This analysis identified sections with above-average response times and incident rates, especially those lacking BLS stations. The next step involved pinpointing which eight sections required BLS coverage based on metrics that determined the best location for a BLS station within these sections. The remaining two sections were analyzed to evaluate the effectiveness of their current BLS allocations.
2. Minimizing Response Time
* The second objective is managing an emergency response system to minimize the response time for emergency incidents with an optimal allocation of the units, using the limited resources available to responders. This task is particularly complex due to the inherent uncertainties in both the spatial and temporal distribution of incidents, as well as the dynamic and changing nature of urban environments. Consequently, decision algorithms must possess the adaptability to evolve with the environment they serve. 

### Evaluation of current BLS - 3 Approaches of Optimal Allocation
#### Optimal Allocation 1 - General Analysis Method
An initial analysis was utilized to identify the optimal 20 BLS units. For this approach, we answered two questions to identify a potential allocation: 

1. Where are the 12 ambulances with the higher response time sent the most? 
2. What is the potential allocation for the 20 ambulances (based on the results obtained from question1)?

For question 1, the focus is on those top 8 stations with higher response time, which are found after following the solution approach in above section.  After identifying them, we proceed to calculate the frequency of incidents for these stations, using: 

                  Frequency = Count of Incidents within each GeoFirstDue.

For the remaining 4 stations, we kept those as BLS stations if they were incidents hotspots, which is provided from the results of the solution approach.  The final selection of the 20 BLS units selects those that were covering hotspots and where the incidents were sent the most. 

#### Optimal Allocation 2 - Greedy Search Method
For goal 2, Greedy Search was utilized to find the optimal allocation of 20 BLS transport units. 
Greedy search is a decision-making algorithm that selects the best available option at each step without considering the global impact of the choices. This approach aims to find a locally optimal solution without backtracking or revisiting decisions once made. It is commonly used in various fields, including computer science and artificial intelligence, for tasks such as finding minimum spanning trees, determining shortest paths, data compression, and activity selection.
In our project, the fundamental concept behind Greedy Search is to reduce the travel distance from the
BLS to the incidents. Given the absence of precise incident locations, we assume that the travel distance is calculated from the BLS location to the stations associated with the incidents. Based on this assumption, we retrieved the coordinates of each station from the Fairfax County Fire and Rescue Department's 2021 map (refer to data in Appendix F) and computed Euclidean distances among 39 stations to represent the relative travel distance of the BLS. 
In Greedy Search, 19 stations were selected out of the total 39 stations to be labeled as stations without bls, leaving the remaining 20 stations as having bls. Next, each of the 19 non-BLS stations was individually analyzed to find the shortest distances between itself and the 20 BLS stations. Finally, all the smallest distances are sum up to get the cumulative distance from the 19 stations to the 20 stations. The purpose of Greedy Search is to discover sets of 19 stations that result in the smallest cumulative distance. This approach aids in determining the most efficient route for BLS to help, thereby reducing the response time, especially those units dispatched from various stations.

#### Optimal Allocation 3 - Partition Method
For approach 3, the Partition Method was employed to optimize the allocation of 20 BLS transport units. The Partition Method is an algorithmic strategy that divides a problem into smaller, more manageable segments or partitions. This approach works by breaking down the larger problem into subsets, solving each subset individually, and then combining these solutions to form the overall solution. 
In our project, the Partition Method was employed to enhance BLS response efficiency by segmenting Fairfax County into ten sections, each encompassing approximately four stations. This segmentation was based on the geographical proximity and operational range of the stations.  
Once divided, we conducted a detailed analysis of each section, focusing on two key metrics: response time and frequency of BLS incidents. The objective was to identify sections where these metrics exceeded the county average. For sections with higher-than-average incident frequencies or response times, we scrutinized the availability and distribution of BLS resources. The analysis involved assessing whether these sections were adequately equipped with BLS units or if there was a need for additional resources. This strategy allowed us to pinpoint areas requiring enhanced BLS coverage, ensuring a more balanced and effective allocation of emergency resources across the county. By targeting sections with elevated incident frequency and delayed response time, the Partition Method aids in optimizing response times and improving overall emergency service efficiency within Fairfax County.


## Model Selection
To address these allocation challenges, we consider two main approaches. Firstly, a ML model is constructed to simulate the deployment of the existing 12 BLS units along with an additional 8 BLS unit and evaluate the performance of these units. However, accurately estimating dispatch assignments in the model, considering incident types, unit types, and secondary effects, poses a challenge. Therefore, we utilize three methods – general analysis, greedy search, and partition approach – to determine potential allocations for the 20 BLS units. These methods account for incident types, hotspots, unit types, dispatch sequence, travel distance, and other factors.

For the predictive model, we choose a DNN predictive model. DNNs excel at automatically learning features, handling non-linear relationships, scaling for big data, being versatile across tasks, and achieving state-of-the-art performance. This enables effective leveraging of our entire dataset, resulting in accurate and valuable insights.

### DNN Model 
#### Descriptive Analysis based on the DNN Model: 
![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/7e181704-33cc-484d-a63c-bc7d58724b8c)

Deep Neural Networks (DNNs) are advanced machine learning models that have the capacity to recognize patterns and intricate relationships within large datasets. As demonstrated in Figure 12, the DNN model consists of an input layer, multiple hidden layers, and an output layer. The nodes in these layers represent neurons, and the connecting lines represent weights. The structure and approach of the DNN model are detailed below:
1. Data Utilization:
* The DNN model is designed to harness the full potential of the dataset.
* By feeding the model with relevant features from the dataset, it can predict the response time based on the given input features.
2.Learning Process:
* The model identifies potential relationships between different features, such as the location of the incident, time of day, and type of incident, and the resultant response time.
* The weights, which connect two neurons from two adjacent layers, are adjusted during the training process to minimize the prediction error.
3. Forward Propagation:
* The process starts at the input layer where the dataset's features are fed into the model.
4. Activation and Propagation:
* Each neuron processes the data it receives and transmits the result to the next layer.
* This processing involves summing up the products of inputs and their corresponding weights, which is termed the net input function.
* The resultant sum is then passed through an activation function, which decides the neuron's output that is sent to the next layer.

##### Metrics and Analysis:
* With the DNN model, predictions are typically evaluated using metrics like Mean Absolute Error (MAE), Mean Squared Error (MSE), and Root Mean Squared Error (RMSE) to understand the model's performance and accuracy.
* By comparing predicted response times with actual response times, one can gauge how well the model is performing and make necessary adjustments to improve its predictive power.

##### Applications:
Optimal Allocation (Goal 2): By predicting response times for various scenarios, the DNN model can assist in making informed decisions about resource allocation, ensuring that ambulances are optimally positioned to respond swiftly.
Response Time Prediction (Goal 3): Accurate prediction of response times can help in evaluating the efficiency of the ambulance service and in identifying the stations where the additional 8 BLS can be placed.
In conclusion, the DNN model serves as a robust tool in this project to achieve goals 2 and 3 by enabling optimal resource allocation and accurate prediction of response times.




