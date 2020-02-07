# DPi30 Modern Data Warehouse Deployment Template

This template is for medium to large data estates that need to do complex analytics and transformations against their data to get true insights into their business. It is based on the architecture outlined in the [Azure Modern Data Warehouse Architecture](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/modern-data-warehouse) article.

It will deploy:
* Azure Data Factory
* Azure Data Lake Gen 2
* Azure Databricks
* Azure Synapse Analytics (formerly Azure Data Warehouse)

## Getting Started
To deploy the DPi30 Modern Data Warehouse Template click the button below and fill in the required information.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcbattlegear%2Fdpi30%2Fmaster%2Fmoderndatawarehouse%2Fdpi30moderndatawarehouse.json" target ="_blank">
    <img src="https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/deploybutton.png"></img>
</a>

## Next Steps
After deploying the template you will want to start getting data into your data warehouse and doing analytics. Here a few links to help you get started:

* [Best practices for SQL Analytics in Azure Synapse Analytics (formerly SQL DW)](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-best-practices)
* [Data loading strategies for Azure SQL Data Warehouse](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/design-elt-data-loading)
* [Create an Azure Databricks Spark cluster](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-quickstart-create-databricks-account#create-a-spark-cluster-in-databricks)
* [Run a Databricks notebook with the Databricks Notebook Activity in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/transform-data-using-databricks-notebook)

## Rationale

### Why are you deploying Databricks?
The goal of deploying Databricks in this template is to allow for real time data processing via Kafka or Event Hubs. Also it is the best method to allow for high performance access and modification of data in Data Lake Gen 2.

### Why are you deploying Data Lake Gen 2?
Data Lake Gen 2 has a high performance HDFS driver that allows for fast access from both Databricks and Data Warehouse via Polybase. 

### Why are you deploying Azure Synapse Analytics (formerly Azure Data Warehouse)? 
High speed processing of structured data. It's the best landing point to handle analytics at scale once you have structured your data.

### Why are you deploying DW200c instead of DW100?
We are deploying 200c to a) Get multiple nodes for data warehouse processing (each 100 DWU equals 1 compute node) and b) use Gen 2 Data Warehouse which comes with several performance and caching improvements.

### Why did you deploy Data Factory?
Data Factory is the best option to orchestrate all this data movement and has the best options for moving data from one place to another quickly and easily.
