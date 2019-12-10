using BoardApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BoardApp.Service
{

    public class CommentService
    {
        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);

      
        public List<Comment> List(int boardNo)
        {
            conn.Open();

            SqlCommand cmd = new SqlCommand("USP_SelectCommentByBoardNo", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = boardNo;

            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            dataAdapter.SelectCommand = cmd;

            DataTable dataTable = new DataTable();
            dataAdapter.Fill(dataTable);

            List<Comment> commentList = new List<Comment>();

            foreach (DataRow dataRow in dataTable.Rows)
            {
                Comment comment = new Comment();
                comment.CommentNo = Convert.ToInt32(dataRow["CommentID"]);
                comment.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
                comment.OriginCommentNo = Convert.ToInt32(dataRow["OriginCommentNo"]);
                comment.CommentLevel = Convert.ToInt32(dataRow["CommentLevel"]);
                comment.CommentWriter = HttpUtility.HtmlDecode(dataRow["CommentWriter"].ToString());
                comment.CommentContent = HttpUtility.HtmlDecode(dataRow["CommentContent"].ToString());
                comment.CommentCreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
                comment.CommentFlag = Convert.ToInt32(dataRow["CommentFlag"]);

                commentList.Add(comment);
            }

            conn.Close();

            return commentList;

        }
    }
}