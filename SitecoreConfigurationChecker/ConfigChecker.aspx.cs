using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Office.Interop.Excel;
using LinqToExcel;
using System.IO;
using System.Data.OleDb;
using ExcelDataReader;

namespace SitecoreConfigurationChecker
{
    public partial class ConfigChecker : Sitecore.sitecore.admin.AdminPage
    {
        private List<string> skippedConfigs = new List<string>();

        enum serverType
        {
            cd = 6,
            cm = 7,
            processing = 8,
            cmProcessing = 9,
            reporting = 10
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ShowErrors(string errorText)
        {
            errorsContent.InnerHtml += errorText;
            errors.Attributes["class"] = "resultContent shown errors";
            errors.Focus();
        }
        protected void CheckConfig_Click(object sender, EventArgs e)
        {
            skippedConfigs.Clear();
            resultContent.Controls.Clear();
            skippedList.Controls.Clear();
            errors.Attributes["class"] = "hidden";

            string role = serverRole.Value;
            int roleColumn = 0;

            switch (role)
            {
                case "cd":
                    {
                        roleColumn = (int)serverType.cd;
                        break;
                    }
                case "cm":
                    {
                        roleColumn = (int)serverType.cm;
                        break;
                    }
                case "proc":
                    {
                        roleColumn = (int)serverType.processing;
                        break;
                    }
                case "cmproc":
                    {
                        roleColumn = (int)serverType.cmProcessing;
                        break;
                    }
                case "rep":
                    {
                        roleColumn = (int)serverType.reporting;
                        break;
                    }
            }

            string currentAppPath = manualSwitcher.Checked ? manualPathContainer.Value : Server.MapPath("~");
            if(!Directory.Exists(currentAppPath + "\\App_Config"))
            {
                string errorText = String.Format("The provided directory: {0} , does not contain the 'App_Config' folder. Please ensure that you have set the 'Manual' path correctly or the current page has been installed in Sitecore", currentAppPath);
                ShowErrors(errorText);
                return;
            }
            string searchProv = searchProvider.Value;
            DataSet dtSet = new DataSet();
            Dictionary<string, string> missconsistens = new Dictionary<string, string>();
            List<string> processedConfigs = new List<string>();
            IExcelDataReader excelReader = null;
            try
            {
                excelReader = ExcelReaderFactory.CreateOpenXmlReader(sprdsheet.PostedFile.InputStream);
            }
            catch (ExcelDataReader.Exceptions.HeaderException ex)
            {
                string errorText = String.Format("The provided spreadsheet file is not an Excel table!!! \n \r StackTrace: {0}", ex.StackTrace);
                ShowErrors(errorText);
                return;
            }

            if (excelReader != null)
            {

                dtSet = excelReader.AsDataSet();
                System.Data.DataTable table = dtSet.Tables[0];

                for (int i = 10; i < table.Rows.Count; i++)
                {
                    if (String.IsNullOrEmpty(table.Rows[i][1].ToString())) continue;
                    if (table.Rows[i][3].ToString() == "Web.config" || table.Rows[i][3].ToString() == "Web.config.Oracle") continue;

                    if (roleColumn != 0)
                    {
                        string configPath = table.Rows[i][2].ToString().Replace(@"\website", currentAppPath) + @"\" + table.Rows[i][3].ToString().Substring(0, table.Rows[i][3].ToString().IndexOf(".config") + 7).Replace(" ", String.Empty);
                        bool configShouldBeEnabled = table.Rows[i][roleColumn].ToString() == "Enable";
                        bool isConfigExists = File.Exists(configPath);

                        if (processedConfigs.Contains(table.Rows[i][2].ToString() + table.Rows[i][3].ToString().Substring(0, table.Rows[i][3].ToString().IndexOf(".config") + 7).Replace(" ", String.Empty)))
                        {
                            skippedConfigs.Add(table.Rows[i][2].ToString() + @"\" + table.Rows[i][3].ToString());
                            continue;
                        }
                        processedConfigs.Add(table.Rows[i][2].ToString() + table.Rows[i][3].ToString().Substring(0, table.Rows[i][3].ToString().IndexOf(".config") + 7).Replace(" ", String.Empty));
                        bool isSelectedProvider = table.Rows[i][5].ToString() == searchProv || searchProv == "Lucene is used" && table.Rows[i][5].ToString() == "Lucene" || searchProv == "Solr is used" && table.Rows[i][5].ToString() == "Solr" || table.Rows[i][5].ToString() == "Base" || String.IsNullOrEmpty(table.Rows[i][5].ToString()) ? true : false;
                        try
                        {
                            if (isSelectedProvider && isConfigExists && configShouldBeEnabled == false || !isSelectedProvider && isConfigExists && configShouldBeEnabled == true)
                            {
                                missconsistens.Add(configPath, "Should be disabled");
                            }

                            if (isSelectedProvider && !isConfigExists && configShouldBeEnabled)
                            {
                                missconsistens.Add(configPath, "Should be Enabled");
                            }
                        }
                        catch (ArgumentException)
                        {
                            skippedConfigs.Add(table.Rows[i][2].ToString().Replace(@"\website", currentAppPath) + @"\" + table.Rows[i][3].ToString());
                        }
                        catch (Exception ex)
                        {
                            string errorText = String.Format("The '{1}' error occurred during defining the misconsitensies. Check the StackTrace for detais: \n {0}", ex.StackTrace, ex.Message);
                            ShowErrors(errorText);
                            return;
                        }
                    }
                }
                excelReader.Close();
            }
            else
            {
                string errorText = "Was not able to create a ExcelReader. It looks like the Excel file is corrupted or has the wrong format";
                ShowErrors(errorText);
                return;
            }
          

            if(missconsistens.Count == 0)
            {
                string resultLine = String.Format(@"<div class=""line""><div class=""configPath single {1}"">{0}</div></div>", "There are no mismatches found","green");
                resultContent.InnerHtml += resultLine;
            }
            else
            {
                foreach (var str in missconsistens)
                {
                    string textColor = "green";
                    if (str.Value != "Should be Enabled") textColor = "red";
                    string resultLine = String.Format(@"<div class=""line""><div class=""configPath"">{0}</div><div class=""status {1}"">{2}</div></div>", str.Key, textColor, str.Value);
                    resultContent.InnerHtml += resultLine;
                }
            }
            
            skippedCount.InnerText = skippedConfigs.Count.ToString();
            if (skippedConfigs.Count > 0)
            {
                showSkippedList.Attributes["class"] = "shown";
            }

            foreach (string str in skippedConfigs)
            {
                string resultLine = String.Format(@"<div class=""line""><div class=""configPath single"">{0}</div></div>",str);
                skippedList.InnerHtml += resultLine;
            }
            results.Attributes["class"] = "resultContent";
            sprdsheet.Attributes["value"] = "";
            if (manualSwitcher.Checked)
            {
                manualBlock.Attributes["class"] = "shown";
            }
            results.Focus();
        }
    }
}