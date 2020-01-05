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
    public class AttachedFileService
    {

        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);

        public int Insert(int BoardNo, string AttachedFileName, byte[] AttachedFileContent)
        {
            try
            {
            conn.Open();
            SqlCommand cmd = new SqlCommand("USP_InsertAttachedFile", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = BoardNo;

            cmd.Parameters.Add("@P_AttachedFileName", SqlDbType.VarChar, 255);
            cmd.Parameters["@P_AttachedFileName"].Value = AttachedFileName;

            cmd.Parameters.Add("@P_AttachedFileContent", SqlDbType.VarBinary, AttachedFileContent.Length);
            cmd.Parameters["@P_AttachedFileContent"].Value = AttachedFileContent;
            

            var affectedCount = cmd.ExecuteNonQuery();
            conn.Close();

            return affectedCount;

            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                }
                string errorMessage = e.ToString(); 
                return -1;
            }
        }


        public int Update(int BoardNo, string AttachedFileName, byte[] AttachedFileContent)
        {
            try
            {
            conn.Open();
            SqlCommand cmd = new SqlCommand("USP_UpdateAttachedFile", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = BoardNo;

            cmd.Parameters.Add("@P_AttachedFileName", SqlDbType.VarChar, 255);
            cmd.Parameters["@P_AttachedFileName"].Value = AttachedFileName;

            cmd.Parameters.Add("@P_AttachedFileContent", SqlDbType.VarBinary, AttachedFileContent.Length);
            cmd.Parameters["@P_AttachedFileContent"].Value = AttachedFileContent;

            var affectedCount = cmd.ExecuteNonQuery();
            conn.Close();

            return affectedCount;

            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();

                }
                var errorMessage = e.ToString();
                return -1;
            }
        }

        public int Delete(int BoardNo)
        {
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("USP_DeleteAttachedFile", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@P_BoardNo", BoardNo);

                int affectedCount = cmd.ExecuteNonQuery();

                conn.Close();

                return affectedCount;


            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                }
                var errorMessage = e.ToString();
                return -1;
            }
        }

       
    }
}