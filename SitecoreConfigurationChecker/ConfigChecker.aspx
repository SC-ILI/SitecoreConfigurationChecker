<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigChecker.aspx.cs" Inherits="SitecoreConfigurationChecker.ConfigChecker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    
<body>
    <style>
     .main {
         margin:0 auto;
         width:1370px;
     }
     .configPath, .status{
         display:inline-block;
     }
        .resultHeader {
            margin-top:15px;
        }
        .configPath{
          float:left;
          font-style:italic;
        }
        .status{
            float:right;
            font-weight:bold;
        }
        .header{
            font-size: 22px;
            font-weight: bold;
            font-style: italic;
            margin: 0px auto;
            align-content: center;
            border-bottom: black;
            border-bottom-style: double;
        }
        .resultContent{
            margin-top:25px;
            display:grid
        }
        .green{
            color:green;
        }
        .red{
            color:red;
        }
        #resultContent{
            display:grid;
        }
        .headerContent{
            padding: 10px 20px 20px 250px;
            position:relative;
        }
        .headerContent span{
            position:absolute;
            top:30px;
            left:570px;
        }
        .simpleSpan{
            font-weight:normal;
            font-size:14px;
        }
        .headerImg{
            width: 200px;
        }
        .title{
            text-align:left;
            margin-bottom: 15px;
            padding:2px;
        }
        #showSkippedList{
            float:right;
            padding:2px;
        }
        #hideSkippedList{
            float:right;
            padding:2px;
        }
        .single{
            display:contents;
        }
        .hidden{
            display:none;
        }
        .shown{
            display:block;
        }
        .button{
            margin-top: 10px;
        }
        .checkbutton{
            width:150px;
            height:40px;
        }
        a{
            padding:5px;
            display:block;
        }
        .controlSection{
            border-bottom: grey solid 1px;
            padding-bottom: 15px;
        }
        .controls{
            border-bottom-style: double;
            padding-bottom: 15px;
            width: 100%;
        }
        .comment{
            color:red;
            font-weight:bold;
            padding-left:10px;
        }
    </style>
    <form id="form1" runat="server">
        <div class="main">
          <div class="header">
            <div class="headerContent">
                <img class="headerImg" src="https://www.sitecore.com/-/media/www/images/identity/sitecore-own-the-experience.svg?la=en&mh=50&mw=150&hash=7DE559DA8A06C98F96A1DE689E8036DA1DBDEE41" />
                <span>Welcome to the Sitecore Configuration Checker!</span>
            </div>
          </div>
            <div class="content">
                <div class ="controls">
                  <div class="sprdsheetPicker controlSection">
                    <div class="controlTitle">
                        <p>Please select the needed spreadsheet that lists of all the configuration files that you must enable or disable.</p>
                        <p>
                            You can dowload the needed spreadsheet using the following links: 

                            <a href="https://doc.sitecore.net//~/media/6F7BAEE97BDC4BE0AC149E8767684918.ashx?la=en">For Sitecore 8.1, Update 1, and Update 2</a>
                            <a href="https://doc.sitecore.net//~/media/11D14B0134D24C4983E56D0B4E24EA74.ashx?la=en">For Sitecore 8.1 Update 3</a>
                            <a href="https://doc.sitecore.net//~/media/8EF47E1F5FA146F59B4AD160F86BBDD9.ashx?la=en">For Sitecore 8.2</a>
                            <a href="https://doc.sitecore.net//~/media/BD14A86DCDEE490186F7DEEEFB32A2AB.ashx?la=en">For Sitecore 8.2 Update 1</a>
                            <a href="https://doc.sitecore.net//~/media/FE19CE65CAD44D26B3878C70EDEE8719.ashx?la=en">For Sitecore 8.2 Update 2, Update 3, Update 4, and Update 5</a>
                            <a href="https://doc.sitecore.net//~/media/00F628C865C8425C90E8FB856687536D.ashx?la=en">For Sitecore 8.2 Update 6</a>
                        </p>
                    </div>
                    <div class="control">
                        <input type="file" name="sprdsheet" id="sprdsheet" runat="server" accept=".xlsx"/>
                    </div>
                  </div>
                  <div class="rolePikcer controlSection">
                      <div class="controlTitle">
                          <p>Please select a Sitecore instance role:</p>
                      </div>
                      <div class="control">
                        <select id="serverRole" runat="server">
                           <option value="cd">Content Delivery (CD)</option>
                           <option value="cm">Content Management (CM)</option>
                           <option value="proc">Processing</option>
                           <option value="cmproc">Content Management (CM) + Processing</option>
                           <option value="rep">Reporting</option>
                        </select>
                      </div>
                  </div>
                  <div class="searchProviderPicker controlSection">
                      <div class="controlTitle">
                          <p>Please select a Search provider which is used on your instance</p>
                      </div>
                      <div class="control">
                          <select id="searchProvider" runat="server">
                              <option value="Lucene is used">Lucene</option>
                              <option value="Solr is used">Solr</option>
                              <option value="Azure is used">Azure</option>
                          </select>
                          <span class="comment hidden" id="searchNotif">Starting from Sitecore 8.2 Update-1</span>
                      </div>
                  </div>
                <div class="button">
                    <asp:Button Text="Check" Enabled="false" ID="checkbut" CssClass="checkbutton" runat="server" OnClick="CheckConfig_Click" />
                </div>
               </div>
                <div class="resultContent hidden" id="results" runat="server">
                    <div class="resultHeader">
                        <div class="header title">
                            Skipped Configs: <span id="skippedCount" runat="server" /> <span class="simpleSpan">(Usually, configs are skipped by the following reasons: 1. There are a few variants of the same config, e.g.: Sitecore.config and Sitecore.config.Oracle; 2. There are duplicates of the same config in the spreadsheet, so the first one will be processed as usual and the following ones will be added to the "skipped" list)</span>
                            <input type="button" class="hidden" runat="server" value="Show all skipped configs" id="showSkippedList" />
                            <input type="button" class="hidden" visible="false" value="Hide all skipped configs" id="hideSkippedList" />
                        </div>
                    </div>
                    <div id="skippedList" class="hidden" runat="server"></div>
                    <div class="resultHeader">
                        <div class="header title">Mismatches with the provided spreadsheet</div>
                    </div>
                    <div id="resultContent" runat="server"> 

                    </div>
                </div>
            </div>
        </div>
        <script>

            document.getElementById('searchProvider').onchange = function (event) {
                if (event.currentTarget.value == "Azure is used") {
                    document.getElementById('searchNotif').setAttribute("class", "comment");
                }
                else {
                    document.getElementById('searchNotif').setAttribute("class", "hidden");
                }
            }

            document.getElementById('sprdsheet').onchange = function (event) {
                console.log("This " + event.currentTarget.value);
                if (event.currentTarget.value != "") {
                    document.getElementById('checkbut').removeAttribute("disabled");
                }
                else {
                    document.getElementById('checkbut').setAttribute("disabled", "disabled");
                }
            }

            document.getElementById('showSkippedList').onclick = function (event) {
                var skippedConfigsElem = document.getElementById('skippedList');
                skippedConfigsElem.setAttribute("class", "shown");
                event.currentTarget.setAttribute("class", "hidden");
                document.getElementById('hideSkippedList').setAttribute("class", "shown");
            }

            document.getElementById('hideSkippedList').onclick = function (event) {
                var skippedConfigsElem = document.getElementById("skippedList");
                skippedConfigsElem.setAttribute("class", "hidden");
                event.currentTarget.setAttribute("class", "hidden");
                document.getElementById('showSkippedList').setAttribute("class", "shown");
            }

        </script>
    </form>
</body>
</html>
