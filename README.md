# THE EFFECT OF DISPATCH ALGORITHM MODIFICATION ON SERVICE DELIVERY
#### DAEN 690 FALL 2023
#### Paola Reyes, Diana Borda, Rishika Reddy Aleti, Jael Tegulwa, Xiaoqing Liu
#
## Description of our project
With the implementation of a new dispatch algorithms, the Fairfax County Fire & Rescue Department (FRD) is in need of optimizing the deployment of its emergency medical service (EMS) resources, including 12 ambulances and 31 medics running across 39 fire stations. Based on this scenario, the FRD is considering the conversion of eight medics to ambulances to ensure timely and suitable medical aid while maintaining response time standards and operational efficiency. The project aims to evaluate rationality of current distribution of ambulances, identify the optimal fire stations for conversion, estimate the implication of such conversions on community and FRD, and analyze the effectiveness of the new dispatch algorithms. By exploring these questions, FRD is able to find a balance between resource allocation, response time benchmarks, and operational resilience to provide efficient and effective emergency medical services to the community.

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/bafe0234-2d6c-4bf5-906d-69aae66ee156)   

## General Framework
Our approach is divided into three key phases: Data Collection and Analysis, Demand Analysis, and the upcoming Model Development phase.

Phase 1: Data Collection and Analysis
The foundation of any robust solution lies in the quality and depth of our data. We start by gathering two types of crucial information: historical data and geographic data.
Historical Data provides us with a window into the past. It allows us to identify trends, anomalies, and patterns that have emerged over time. Through techniques like statistical analysis and data visualization, we extract meaningful insights. On the other hand, by understanding the geographical distribution of our data, we can uncover insights that may not be immediately apparent. 

Phase 2: Demand Analysis
With a solid foundation of historical and geographic data, we move into the Demand Analysis phase. Here, our primary goal is to identify areas of high demand or activity - what we refer to as "hotspots".

Phase 3: Model Development
Building on the insights gained from our data analyses, we will create predictive models.

Phase 4: Results and Analysis

![image](https://github.com/Xiaoqing15/DAEN-690-W_Insights/assets/137991044/8240ce63-b8b4-4386-9365-56314dd0856c)



 ## Outline of our project
                      |                   Sprints                  |                  Status                  |         
                      |:------------------------------------------:|:----------------------------------------:|
                      |             Problem Definition             |                 Finished                 |
                      |                   Data Sets                |                 Finished                 |
                      |           Analytics / Algorithms           |                 Finished                 |        
                      |               Visualizations               |                 Ongoing                  |
                      |             Final Presentations            |                 Ongoing                  |

## Sprint 1 Problem Definition
* Background
* Problem Statement
* Research
* Solution Statement
* Project Objectives
* User Stories
  
During this Sprint, our team made commendable progress across various project components. Starting with describing the project with brief and elaborated background along with mentioning the problem understanding and problem space which was further continued by solution space, where we strategically researched heuristics and hierarchical planning for resource allocation, demonstrating a thoughtful approach to optimization. Our project objectives were met with encompassing vital aspects such as team learning, a well-attained solution, a deep understanding of the problem, and the creation of substantial product value. Thorough research and a clear articulation of the project's background formed the bedrock of our efforts. Additionally, the creation of detailed scenarios under the product vision section added valuable context to our user stories. Looking ahead, we acknowledge the importance of refining our time management and prioritization of user stories. We also plan to integrate early validation and establish a more structured feedback loop for greater agility in addressing challenges. During this Sprint, the team executed flawlessly, with every aspect aligning seamlessly with the plan. There were no areas that required improvement, indicating that the Sprint was executed perfectly and met all expectations. With our team's effective collaboration, and we're poised to further optimize our approach in future Sprints. 
## Sprint 2 Data Sets
*	OVERVIEW	
*	FIELD DESCRIPTIONS	
*	DATA CONTEXT	
*	DATA CONDITIONING	
*	DATA QUALITY ASSESSMENT
*	OTHER DATA SOURCES	
*	STORAGE MEDIUM	
*	STORAGE SECURITY	
*	STORAGE COSTS

During this Sprint, the team delved into Section 2: Datasets with precision and efficiency. User Stories were identified and categorized meticulously, ensuring comprehensive coverage. The team demonstrated commendable performance in handling diverse tasks related to data collection and standardization. Managing activities was streamlined due to well-defined User Stories and clear task assignments, enabling efficient resource allocation and progress monitoring. A significant accomplishment was the emphasis on data quality and assurance, with rigorous checks enhancing dataset integrity. Exploring additional data sources and implementing secure, cost-effective storage were additional strengths. For improvement, refining data conditioning and exploring advanced storage solutions could enhance future projects. The extensive use of visualizations to pinpoint station hotspots based on population density and incident counts was a standout success, providing valuable insights for resource allocation. This Sprint was marked by attention to detail, structured data handling, and a strong focus on data quality, offering valuable lessons for future data-intensive projects.The area of improvement suggested in this Sprint was about getting better User Stories that align with the team, ensuring a more seamless and productive workflow in future projects.

   ## Sprint 3 Algorithms & Analysis/ML Model Exploration & Selection
*	SOLUTION APPROACH	
* SYSTEMS ARCHITECTURE	
*	SYSTEMS SECURITY	
*	SYSTEMS DATA FLOWS	
*	ALGORITHMS & ANALYSIS	
* MACHINE LEARNING	
*	MODEL EXPLORATION
*	MODEL SELECTION

To address the diverse user stories that were presented, the system incorporated a modular architecture, ensuring agility and scalability. The architecture was built around a central data processing and ML moduling, interconnected with data sources and a Machine Learning Model. Data from emergency calls and historical incident reports were continuously ingested into the system. After pre-processing, it was used to train and evaluate the ML model and populate the visualizations. In our initial client meeting, we laid out our approach, ensuring they had a clear understanding of our strategy and the technological avenues we were exploring. Their feedback was invaluable, providing a practical perspective that we, as developers, might overlook. In a follow-up meeting, we showcased our preliminary results, giving them a tangible sense of our progress and the potential of our solution. Feedback loops were established to refine the model with real-world outcomes. Initial algorithmic approaches encompassed supervised learning models such as DNNs for dispatching and Greedy Heuristics for allocating. Their suitability was assessed based on the accuracy, 90 percentile and regression scores. Further, Hopper cluster analysis was performed to use it in future. 

  ## Sprint 4 VISUALIZATIONS / ML MODEL TRAINING, EVALUATION, & VALIDATION	
* OVERVIEW	
*	VISUALIZATIONS	
*	MACHINE LEARNING	
*	MODEL TRAINING	
*	MODEL EVALUATION	
*	MODEL VALIDATION
  
The section presents a detailed analysis of ambulance service efficiency in Fairfax County, focusing on the response times and distribution of current Basic Life Support (BLS) units in relation to incident hotspots. It evaluates whether the existing 12 BLS units meet the Fairfax County Fire and Rescue Department's (FCFRD) response time benchmarks and if their placement aligns with the areas of highest demand. The analysis employs various strategies, including General Analysis, Greedy Search, and Partition Methods, to identify optimal BLS unit allocation. Additionally, it introduces a Deep Neural Network (DNN) predictive model designed to forecast response times for better ambulance deployment. The narrative is structured to assess, optimize, and predict, aiming to enhance the emergency medical services' effectiveness through data-driven strategies and machine learning insights.
