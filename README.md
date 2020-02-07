# Data Platform in 30 Days

Data Platform in 30 Days (DPi30) is designed to help you create a data platform in Azure quickly and efficiently. With less time deploying resources you have more time to learn about the platform!

### ARM Template Test Deployment Status
![Build Status](https://cabattag.visualstudio.com/dpi30/_apis/build/status/cbattlegear.dpi30?branchName=master)

## Getting Started

If you know what path you want to do right away go directly to either the simple deployment or Modern Data Warehouse deployment. From there you can use the deploy template button to get everything up and running.

* [Simple Deployment](simple/)
* [Modern Data Warehouse Deployment](moderndatawarehouse/)
* [Managed Instance Deployment](managedinstance/)

If you are unsure which to choose you can use the Decision Tree and Deployment powershell script that will help you decide and deploy the best template.

### Using the Decsion Tree and Deployment Powershell script
1. [Open Azure Cloud Shell in your Azure Portal](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart-powershell#start-cloud-shell)
2. Run `cd ~`
3. Clone the repository with: `git clone https://github.com/Azure-Samples/dpi30.git`
4. Run the powershell script with `./dpi30/dpi30.ps1`