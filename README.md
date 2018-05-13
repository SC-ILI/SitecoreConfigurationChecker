# SitecoreConfigurationChecker
A Sitecore page which provides an opportunity to check the current Sitecore instance configuration according to the provided spreadsheet

# Compatibility
In theory, this tool should be compatible with Sitecore starting from the 8.1.1 version till the 8.2.6 version.
For now, the tool was tested with Sitecore 8.2.5 and 8.2.6.

# Installation
While the SitecoreConfigurationTool is under testing, to install the tool please perform the following steps:

1. Clone the project and build it.
2. Copy the "ExcelDataReader.DataSet.dll", "ExcelDataReader.dll" and "SitecoreConfigurationChecker.dll" files to the "bin" folder of your Sitecore Instance.
3. Copy the "ConfigChecker.aspx" file to the "\sitecore\admin" folder of your Sitecore instance.

# How to use the tool

1. Open the "http(s)://host name/sitecore/admin/ConfigChecker.aspx" page.
2. Select the downloaded spreadsheet (You can use the links on the page to download the spreadsheet for your version of Sitecore).
3. Click the "Check" button.
