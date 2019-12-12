using BoardApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
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
                comment.ParentCommentWriter = HttpUtility.HtmlDecode(dataRow["ParentCommentWriter"].ToString());
                comment.CommentLevel = Convert.ToInt32(dataRow["CommentLevel"]);
                comment.CommentOrder = Convert.ToInt32(dataRow["CommentOrder"]);
                comment.CommentWriter = HttpUtility.HtmlDecode(dataRow["CommentWriter"].ToString());
                comment.CommentContent = HttpUtility.HtmlDecode(dataRow["CommentContent"].ToString());
                comment.CommentCreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
                comment.CommentFlag = Convert.ToInt32(dataRow["CommentFlag"]);

                commentList.Add(comment);
            }

            conn.Close();

            return commentList;

        }


        public Comment Insert(Comment model)
        {

            conn.Open();
            SqlCommand cmd = new SqlCommand("USP_InsertComment", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = model.BoardNo;
            cmd.Parameters.Add("@P_OriginCommentNo", SqlDbType.Int);
            cmd.Parameters["@P_OriginCommentNo"].Value = model.OriginCommentNo;
            cmd.Parameters.Add("@P_ParentCommentID", SqlDbType.Int);
            cmd.Parameters["@P_ParentCommentID"].Value = model.ParentCommentNo;
            cmd.Parameters.Add("@P_CommentLevel", SqlDbType.Int);
            cmd.Parameters["@P_CommentLevel"].Value = model.CommentLevel;
            cmd.Parameters.Add("@P_CommentWriter", SqlDbType.VarChar, 50);
            cmd.Parameters["@P_CommentWriter"].Value = model.CommentWriter;
            cmd.Parameters.Add("@P_CommentContent", SqlDbType.Text);
            cmd.Parameters["@P_CommentContent"].Value = model.CommentContent;
            cmd.Parameters.Add("@P_CommentPassword", SqlDbType.VarBinary);

            var tempPassword = model.CommentPassword;
            byte[] bytes = Encoding.Unicode.GetBytes(tempPassword);
            
            cmd.Parameters["@P_CommentPassword"].Value = bytes;

            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            dataAdapter.SelectCommand = cmd;

            DataTable dataTable = new DataTable();
            dataAdapter.Fill(dataTable);
            DataRow dataRow = dataTable.Rows[0];

            Comment obj = new Comment();
            obj.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
            obj.CommentNo = Convert.ToInt32(dataRow["CommentID"]);
            obj.OriginCommentNo = Convert.ToInt32(dataRow["OriginCommentNo"]);
            obj.CommentLevel = Convert.ToInt32(dataRow["CommentLevel"]);
            obj.CommentOrder = Convert.ToInt32(dataRow["CommentOrder"]);
            obj.CommentFlag = Convert.ToInt32(dataRow["CommentFlag"]);
            obj.CommentWriter = HttpUtility.HtmlDecode(dataRow["CommentWriter"].ToString());
            obj.CommentCreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
            obj.ParentCommentWriter = HttpUtility.HtmlDecode(dataRow["ParentCommentWriter"].ToString());
            obj.CommentContent = HttpUtility.HtmlDecode(dataRow["CommentContent"].ToString());

            return obj;
        }

    }
}