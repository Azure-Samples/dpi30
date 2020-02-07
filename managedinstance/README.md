# DPi30 Managed Instance Deployment Template
This template is for data estates that need a place to consolidate their data into one place for reporting while having the full SQL Server feature set. 

It will deploy: 
* SQL Managed Instance (Gen 5 4 Cores)
* Azure Storage Account (Blob Storage)
* Azure Data Factory
* Jump Box Virtual Machine (B2ms with SSMS and Self Hosted Integration runtime preinstalled)

## Getting Started
To deploy the DPi30 Simple Template click the button below and fill in the required information.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcbattlegear%2Fdpi30%2Fmaster%2Fmanagedinstance%2Fdpi30managedinstance.json" target ="_blank">
    <img src="https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/deploybutton.png"></img>
</a>

## Next Steps
After deploying the simple template you will want to start getting data into your database. Here a few links to help you get started:
* [How to connect and sign on to an Azure virtual machine running Windows](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/connect-logon)
* [Copy data to and from Azure SQL Database Managed Instance by using Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-sql-database-managed-instance)
* [Create and configure a self-hosted integration runtime](https://docs.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime)
* [Columnstore Indexes](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview?view=sql-server-ver15)

## Rationale

### Why are you deploying Azure SQL Managed Instance?
Managed Instance allows you to use SQL Server features such as cross database queries without having to worry about items like backups or setting up with best practices.

### Why deploy a blob storage account instead of data lake?
SQL Azure Managed Instance currently cannot access Data Lake Gen 2 directly. To allow for bulk insert of data we are using Blob storage for direct access from SQL Azure.

### Why did you deploy Data Factory?
Data Factory is the best option to orchestrate all this data movement and has the best options for moving data from one place to another quickly and easily.

### Why did you deploy a Virtual Machine?
Since Managed Instance is contained within a Virtual Network the safest way to access it is via a Jumpbox sitting inside the same Virtual Network.