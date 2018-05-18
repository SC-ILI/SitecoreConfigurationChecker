# SitecoreConfigurationChecker
A Sitecore page which provides an opportunity to check the current Sitecore instance configuration according to the provided spreadsheet

# Compatibility
In theory, this tool should be compatible with Sitecore starting from the 8.1.1 version till the 8.2.6 version.
For now, the tool was tested with Sitecore 8.2.5 and 8.2.6.

# Installation

Before building the project please ensure that the "Public Sitecore Nuget": https://sitecore.myget.org/F/sc-packages/api/v3/index.json is add to your Visual Studio. More information about "Public Sitecore Nuget" can be found here: https://doc.sitecore.net/sitecore_experience_platform/82/developing/developing_with_sitecore/sitecore_public_nuget_packages_faq

While the SitecoreConfigurationTool is under testing, there are two possible options to install the tool:

Manually:

1. Clone the project and build it.
2. Copy the "ExcelDataReader.DataSet.dll", "ExcelDataReader.dll" and "SitecoreConfigurationChecker.dll" files to the "bin" folder of your Sitecore Instance.
3. Copy the "ConfigChecker.aspx" file to the "\sitecore\admin" folder of your Sitecore instance.

Using the "Publish" feature of the Visual Studio:

1. Clone the project and open it in Visual Studio.
2. Click Build --> Publish SitecoreConfigurationChecker
3. Select "Folder"
4. Click "Browse" and choose the "Website" folder of your Sitecore solution.
5. Click "Publish" 

# How to use the tool

To check the current instance:

1. Open the "http(s)://host name/sitecore/admin/ConfigChecker.aspx" page.
2. Select the downloaded spreadsheet (You can use the links on the page to download the spreadsheet for your version of Sitecore).
3. Click the "Check" button.

To check some other instance (or App_config folder):

1. Open the "http(s)://host name/sitecore/admin/ConfigChecker.aspx" page.
2. Switch to the 'Manual' mode.
3. Paste the path to the folder which contains the "App_Config" folder.
3. Select the downloaded spreadsheet (You can use the links on the page to download the spreadsheet for your version of Sitecore).
4. Click the "Check" button.
