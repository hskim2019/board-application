using BoardApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace BoardApp.Service
{
    public class AttachmentService
    {

        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);


        public List<Attachment> Index(int BoardNo)
        {
            List<Attachment> objList = new List<Attachment>();

            try
            {
                SqlCommand cmd = new SqlCommand("USP_SelectAttachment", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@P_BoardNo", BoardNo);

                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = cmd;

                DataTable dataTable = new DataTable();
                dataAdapter.Fill(dataTable);

                foreach(DataRow dataRow in dataTable.Rows)
                {
                    Attachment attachment = new Attachment();
                    attachment.AttachmentNo = Convert.ToInt32(dataRow["AttachmentID"]);
                    attachment.AttachmentPath = dataRow["AttachmentPath"].ToString();

                    objList.Add(attachment);
                }

                conn.Close();

            return objList;

            } catch (Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                }
                var errorMessage = e.ToString();

                return objList;
            }


        }


        public string GetFilePath(int AttachmentNo)
        {
            //Attachment attachment = new Attachment();

            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("USP_SelectAttachmentByAttachmentNo", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@P_AttachmentNo", AttachmentNo);

                SqlDataReader dataReader = cmd.ExecuteReader();
                dataReader.Read();
                var filePath = dataReader[0].ToString();
                dataReader.Close();
                conn.Close();

                return filePath;

            } catch(Exception e)
            {
                if(conn !=null)
                {
                    conn.Close();
                }
                var errorMessage = e.ToString();
                return "error";
            }
        }

        public int Count(int BoardNo)
        {

            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("USP_CountAttachmentByBoardNo", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@P_BoardNo", BoardNo);
                cmd.Parameters.Add("@AttachmentCount", SqlDbType.Int).Direction = ParameterDirection.Output;

                var returnValue = cmd.ExecuteScalar();

                var rowCount = Convert.ToInt32(cmd.Parameters["@AttachmentCount"].Value);
                return rowCount;

            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                }
                var errorMessage = e.ToString();

                return 0;
            }

           
        }


        public int Insert(int BoardNo, string AttachmentPath)
        {
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("USP_InsertAttachment", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
                cmd.Parameters["@P_BoardNo"].Value = BoardNo;

                cmd.Parameters.Add("@P_AttachmentPath", SqlDbType.VarChar, 255);
                cmd.Parameters["@P_AttachmentPath"].Value = AttachmentPath;

              
                var affectedCount = cmd.ExecuteNonQuery();
                conn.Close();

                


                return affectedCount;



            }
            catch (Exception e)
            {
                if (conn != null)
                {
                    conn.Close();
                }
                string errorMessage = e.ToString();
                return -1;
            }
        }
    }
}