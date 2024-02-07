# NYC-Taxi-Trips-Analytics

### Overview
This repository contains code and queries for analyzing New York City (NYC) taxi trip data using PySpark and Neo4j. The analysis focuses on tasks such as data cleaning, adding new columns, summarizing trip data per zone, and performing centrality analysis and community detection using graph algorithms.

### Inputs
1. NYC Taxi Trips dataset: This dataset includes records of NYC taxi trips, each with characteristics like distance, number of passengers, origin and destination zones, and trip cost.
2. NYC Zones dataset: This dataset contains information about zones where taxi trips can originate or terminate.

### Tasks Summaries
#### 1. PySpark Analysis
##### Data Cleaning
Remove records with zero distance or no passengers.
Handle outlier records in the dataset.

##### Adding New Columns
Join the taxi trips dataset with the zones dataset to enrich trip data.
Compute the unit profitability of each trip.

##### Zone Summarisation and Ranking
Summarize trip data per zone, including total trip volume, average profitability, and total passenger volume.
Obtain the top 10 ranks based on the above criteria.

##### Execution Time Measurement
Record the total and task-specific execution times for each dataset size and format.

#### 2. Neo4j Analysis
##### Task 0 - Find Isolated Nodes
Identify isolated nodes and self-pointing relationships in the Neo4j database.

##### Task 1 - Community Detection
Use the Louvain algorithm for community detection to identify clusters of strongly connected zones.

##### Task 2 - Centrality Analysis
Employ the Page Rank algorithm for centrality analysis to measure the hub-like features of each zone.

##### Task 3 - Zone Recommendation
Combine the results of centrality analysis and community detection to identify the top three zones with the highest centrality score within each community cluster.