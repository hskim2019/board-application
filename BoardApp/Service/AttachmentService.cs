using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BoardApp.Service
{
    public class AttachmentService
    {

        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);

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