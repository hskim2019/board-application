using BoardApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web;
using System.Web.Mvc;

namespace BoardApp.Controllers
{
    public class AttachedFileController : Controller
    {
            static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
            SqlConnection conn = new SqlConnection(strConn);

        // GET: File
        public ActionResult Download(int BoardNo)
        {

            conn.Open();
            SqlCommand cmd = new SqlCommand("USP_SelectAttachedFileContentWithBoardNo", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = BoardNo;

            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            dataAdapter.SelectCommand = cmd;

            DataTable dataTable = new DataTable();
            dataAdapter.Fill(dataTable);
            DataRow dataRow = dataTable.Rows[0];

            AttachedFile Attachedfiles = new AttachedFile();

            var fileName = dataRow["AttachedFileName"].ToString();
            var aaa = dataRow["AttachedFileContent"];

            BinaryFormatter bf = new BinaryFormatter();
            MemoryStream ms = new MemoryStream();
            bf.Serialize(ms, aaa);

            var tt = ms.ToArray();


            conn.Close();



            return File(tt, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }
    }
}