using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SharePoint.Client;
using SP = Microsoft.SharePoint.Client;
using System.Security;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using System.Data;
using System.Configuration;
using System.Net.Mail;
using Microsoft.SharePoint.Client.Utilities;
using System.Text.RegularExpressions;

namespace ReadExcelDataFromDocumentLibrary
{
    class Program
    {
        static void Main(string[] args)
        {
            const string webUrl = "SharepointWebUrl";
         
            const string USER = "****";
            const string PWD = "****";
            //const string Domain = "domain";
            //Authentication for on premises SharePoint
            //clientContext.Credentials = new System.Net.NetworkCredential(USER, PWD, Domain);
            try
            {
                ClientContext clientContext = new ClientContext(webUrl);

                //Authentication for SharePoint Online
                SecureString passWord = new SecureString();
                foreach (char c in PWD.ToCharArray())
                {
                    passWord.AppendChar(c);
                }
                clientContext.Credentials = new SharePointOnlineCredentials(USER, passWord);
                //Microsoft.SharePoint.Client.List spList = clientContext.Web.Lists.GetByTitle("Documents");
                // ReadFileName(clientContext);

                //Web oWebsite = clientContext.Web;

                // 웹사이트 속성
                //clientContext.Load(oWebsite);
                //clientContext.ExecuteQuery();
                //Console.WriteLine("Title: {0} Description: {1}", oWebsite.Title, oWebsite.Description);

                //ListCollection collList = oWebsite.Lists;

                //지정된 목록 속성만
                //clientContext.Load(collList, lists => lists.Include(list => list.Title,list => list.Id));
                //clientContext.ExecuteQuery();
                //foreach (SP.List oList in collList)
                //{
                //    // Console.WriteLine("Title: {0} Created: {1}", oList.Title, oList.Created.ToString());
                //    Console.WriteLine("Title: {0} ID: {1}", oList.Title, oList.Id.ToString("D"));

                //}


                // 항목 이름
                //SP.List oList = clientContext.Web.Lists.GetByTitle("문서");
                //CamlQuery camlQuery = new CamlQuery();
                //ListItemCollection collListItem = oList.GetItems(camlQuery);
                //camlQuery.ViewXml = "<View><RowLimit>100</RowLimit></View>";

                //clientContext.Load(collListItem,
                //    items => items.Include(
                //                     item => item.Id,
                //                     item => item.DisplayName));


                //clientContext.ExecuteQuery();

                //foreach (ListItem oListItem in collListItem)
                //{
                //    Console.WriteLine("ID: {0} \nDisplay name: {1}",
                //        oListItem.Id, oListItem.DisplayName);
                //}

                List list = clientContext.Web.Lists.GetByTitle("문서");
                clientContext.Load(list.RootFolder);
                clientContext.ExecuteQuery();
               
                string fileName = "인사연동 - 복사본.xlsx";
               // string fileName = "Excel연결 From 1111.xlsx";

                // 파일 로드
                string fileServerRelativeUrl = list.RootFolder.ServerRelativeUrl + "/" + fileName;
                Microsoft.SharePoint.Client.File file = clientContext.Web.GetFileByServerRelativeUrl(fileServerRelativeUrl);
                ClientResult<System.IO.Stream> data = file.OpenBinaryStream();
                clientContext.Load(file);
                clientContext.ExecuteQuery();


                DataSet hrDataSet = new DataSet("HRTables");

                DataTable groupTable = new DataTable("GrouopDataTable");
                DataTable userTable = new DataTable("UserTable");
                DataTable userGroupTable = new DataTable("UserGroupTable");

                groupTable.Columns.Add("GroupName", typeof(String));
                groupTable.Columns.Add("GroupDisplayName", typeof(String));
                groupTable.Columns.Add("GroupID", typeof(String));
                groupTable.Columns.Add("ParentGroupCode", typeof(String));
                groupTable.Columns.Add("SortOrder", typeof(Int32));
                groupTable.Columns.Add("GroupMail", typeof(String));

                groupTable.Columns.Add("CompanyCode", typeof(String));
                groupTable.Columns.Add("Created", typeof(DateTime));
                groupTable.Columns.Add("Updated", typeof(DateTime));

               // DataTable dataTable = new DataTable("TEST");


                using (System.IO.MemoryStream mStream = new System.IO.MemoryStream())
                {
                    if (data != null)
                    {
                        data.Value.CopyTo(mStream);
                        using (SpreadsheetDocument document = SpreadsheetDocument.Open(mStream, false))
                        {
                            WorkbookPart workbookPart = document.WorkbookPart;
                            IEnumerable<Sheet> sheets = document.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();

                            //첫번째 sheet
                            string relationshipId = sheets.First().Id.Value;

                            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);


                            Worksheet workSheet = worksheetPart.Worksheet;
                            SheetData sheetData = workSheet.GetFirstChild<SheetData>();
                            //IEnumerable<Row> rows = sheetData.Descendants<Row>();
                            IEnumerable<Row> rows = sheetData.Elements<Row>().Where(r => r.Elements<Cell>().Any(ce => ce.DataType != null));

                            //foreach (Cell cell in rows.ElementAt(0))
                            //{
                            //    string str = GetCellValue(clientContext, document, cell);
                            //    dataTable.Columns.Add(str);
                            //}



                            foreach (Row row in rows)
                            {
                                if (row != null && row.RowIndex > 1)
                                {
                                    DataRow dataRow = groupTable.NewRow();

                                    //for (int i = 0; i < row.Descendants<Cell>().Count(); i++)
                                    //{
                                    //    dataRow[i] = GetCellValue(clientContext, document, row.Descendants<Cell>().ElementAt(i));
                                    //}

                                    for (int i = 0; i < groupTable.Columns.Count; i++)
                                    {
                                        if (i == 6) // companyCode
                                        {
                                            dataRow[i] = "001";
                                        }
                                        else if (i > 6)
                                        {
                                            dataRow[i] = DateTime.Today;
                                        }
                                        else
                                        {
                                            dataRow[i] = GetCellValue(clientContext, document, row.Descendants<Cell>().ElementAt(i + 1));
                                        }
                                    }

                                    groupTable.Rows.Add(dataRow);
                                
                                }
                            }
                            hrDataSet.Tables.Add(groupTable);
                           // groupTable.Rows.RemoveAt(0);
                        }
                    }
                }
              
                

            }
            catch (Exception ex)
            {
                string errorMessage = ex.ToString();
                Console.WriteLine(errorMessage);
            }
            Console.WriteLine("Please press any key to exit.");
            Console.ReadKey();

        }



        private static void ReadFileName(ClientContext clientContext)
        {
            string fileName = string.Empty;
            bool isError = true;
            const string fldTitle = "LinkFilename";
            const string lstDocName = "문서";
            const string strFolderServerRelativeUrl = "/Shared%20Documents";
            string strErrorMsg = string.Empty;
            try
            {
                List list = clientContext.Web.Lists.GetByTitle(lstDocName);
                CamlQuery camlQuery = new CamlQuery();
                camlQuery.ViewXml = @"<View Scope='Recursive'><Query></Query></View>";
                camlQuery.FolderServerRelativeUrl = strFolderServerRelativeUrl;
                SP.ListItemCollection listItems = list.GetItems(camlQuery);
                clientContext.Load(listItems, items => items.Include(i => i[fldTitle]));
                clientContext.ExecuteQuery();
                for (int i = 0; i < listItems.Count; i++)
                {
                    SP.ListItem itemOfInterest = listItems[i];
                    if (itemOfInterest[fldTitle] != null)
                    {
                        fileName = itemOfInterest[fldTitle].ToString();
                        if (i == 0)
                        {
                            // ReadExcelData(clientContext, itemOfInterest[fldTitle].ToString());
                        }
                    }
                }
                isError = false;
            }
            catch (Exception e)
            {
                isError = true;
                strErrorMsg = e.Message;
            }
            finally
            {
                if (isError)
                {
                    //Logging
                }
            }
        }



        private static string GetCellValue(ClientContext clientContext, SpreadsheetDocument document, Cell cell)
        {
            bool isError = true;
            string strErrorMsg = string.Empty;
            string value = string.Empty;
            try
            {
                if (cell != null)
                {
                    SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
                    if (cell.CellValue != null)
                    {
                        value = cell.CellValue.InnerXml;
                        if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
                        {
                            if (stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)] != null)
                            {
                                isError = false;
                                return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
                            }
                        }
                        else
                        {
                            isError = false;
                            return value;
                        }
                    }
                }
                isError = false;
                return string.Empty;
            }
            catch (Exception e)
            {
                isError = true;
                strErrorMsg = e.Message;
            }
            finally
            {
                if (isError)
                {
                    //Logging
                }
            }
            return value;
        }



    }
}
