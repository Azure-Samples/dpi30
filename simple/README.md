# DPi30 Simple Deployment Template
This template is for smaller data estates that just need a place to consolidate their data into one place for reporting. 

It will deploy: 
* SQL Azure Database (Gen 5 2 Cores)
* Azure Storage Account (Blob Storage)
* Azure Data Factory

## Getting Started
To deploy the DPi30 Simple Template click the button below and fill in the required information.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcbattlegear%2Fdpi30%2Fmaster%2Fsimple%2Fdpi30simple.json" target ="_blank">
    <img src="https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/deploybutton.png"></img>
</a>

## Next Steps
After deploying the simple template you will want to start getting data into your database. Here a few links to help you get started:
* [Copy data from an on-premises SQL Server database to Azure Blob storage](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-hybrid-copy-portal)
* [Copy data from Azure Blob storage to a SQL database by using Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-copy-data-portal)
* [Columnstore Indexes](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview?view=sql-server-ver15)

## Rationale

### Why are you deploying Azure SQL Hyperscale?
Hyperscale is the best option for a simple data warehouse. It allows for read scale out for Business Intelligence queries and to expand to 100 TB comfortably.

### Why deploy a blob storage account instead of data lake?
SQL Azure currently cannot access Data Lake Gen 2 directly. To allow for bulk insert of data we are using Blob storage for direct access from SQL Azure.

### Why did you deploy Data Factory?
Data Factory is the best option to orchestrate all this data movement and has the best options for moving data from one place to another quickly and easily.