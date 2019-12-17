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
    public class BoardService
    {
        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);


        public List<Board> Index(int start, int end)
        {
            // 리스트 DB에서 불러오기, 파라미터 : 시작 row, 끝 row
            /*******paging 없이 전체 List*/
            // SqlDataAdapter dataAdapter = new SqlDataAdapter("USP_SelectBoardList", conn);

            /********paging***********/
            SqlCommand cmdP = new SqlCommand("USP_SelectBoard", conn);
            cmdP.CommandType = CommandType.StoredProcedure;
            cmdP.Parameters.Add("@P_START", SqlDbType.Int);
            cmdP.Parameters["@P_START"].Value = start;
            cmdP.Parameters.Add("@P_END", SqlDbType.Int);
            cmdP.Parameters["@P_END"].Value = end;
            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            dataAdapter.SelectCommand = cmdP;
            /*~~~~~~~~~~~~~~~~~~~~~*/



            // DataTable 생성
            DataTable dataTable = new DataTable();

            // SelectCommand 탐색 결과를 DataSet개체의 테이블 데이터를 채워주는 역할
            dataAdapter.Fill(dataTable);

            // 3-5. DataTable => List<Object> : 모델 객체 리스트로 View에 넘겨주기
            List<Board> objList = new List<Board>();

            foreach (DataRow dataRow in dataTable.Rows)
            {
                Board board = new Board();
                board.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
                board.BoardTitle = HttpUtility.HtmlDecode(dataRow["BoardTitle"].ToString());
                board.BoardWriter = HttpUtility.HtmlDecode(dataRow["BoardWriter"].ToString());
                board.CreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
                board.ViewCount = Convert.ToInt32(dataRow["ViewCount"]);
                board.RowNo = Convert.ToInt32(dataRow["ROWNUM"]);
                board.CommentCount = Convert.ToInt32(dataRow["CommentCTN"]);

                objList.Add(board);
            }
            conn.Close();

            return objList;
        }

        public int RowCount()
        {
            conn.Open();
            // 전체 개시물 개수 rowCount 계산
            SqlCommand cmd = new SqlCommand("USP_SelectRowCount", conn);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add("@count", SqlDbType.Int).Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();

            var rcObject = cmd.Parameters["@count"].Value;
            int rowCount = 0;
            rowCount = Convert.ToInt32(rcObject);
            conn.Close();

            return rowCount;
        }




        public Board Detail(int boardNo)
        {
                Board board = new Board();
            try
            {
                conn.Open();

                // 파라미터 전달
                SqlCommand cmd = new SqlCommand("USP_SelectBoardListByNo", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
                cmd.Parameters["@P_BoardNo"].Value = boardNo;

                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = cmd;

                DataTable dataTable = new DataTable();
                dataAdapter.Fill(dataTable);
                DataRow dataRow = dataTable.Rows[0];


                board.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
                board.BoardTitle = HttpUtility.HtmlDecode(dataRow["BoardTitle"].ToString());
                board.BoardContent = HttpUtility.HtmlDecode(dataRow["BoardContent"].ToString());
                board.BoardWriter = HttpUtility.HtmlDecode(dataRow["BoardWriter"].ToString());
                board.CreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
                board.ViewCount = Convert.ToInt32(dataRow["ViewCount"]);
                board.CommentCount = Convert.ToInt32(dataRow["CommentCTN"]);
                board.AttachedFileName = dataRow["AttachedFileName"].ToString();


                conn.Close();
                return board;

            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                }
                var errorMessage = e.ToString();
                return board;
            }
        }


        public int Insert(Board model)
        {
            try
            {
                SqlCommand cmd = new SqlCommand("USP_InsertBoard", conn);
                conn.Open();
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@P_BoardTitle", SqlDbType.VarChar, 255);
                cmd.Parameters["@P_BoardTitle"].Value = HttpUtility.HtmlEncode(model.BoardTitle);


                cmd.Parameters.Add("@P_BoardContent", SqlDbType.Text);
                cmd.Parameters["@P_BoardContent"].Value = HttpUtility.HtmlEncode(model.BoardContent);

                cmd.Parameters.Add("@P_BoardWriter", SqlDbType.VarChar, 50);
                cmd.Parameters["@P_BoardWriter"].Value = HttpUtility.HtmlEncode(model.BoardWriter);
                cmd.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;
                // 해당쿼리문에 적용된 레코드의 개수 반환
                var result = cmd.ExecuteNonQuery();

                var idObject = cmd.Parameters["@id"].Value;
                int intId = 0;

                conn.Close();

                if (idObject != null)
                {
                    intId = Convert.ToInt32(idObject);
                    return intId;
                } else //DB 저장 실패
                { 
                    return 0;
                }



            } catch (Exception e)  //DB Connection 실패
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
                SqlCommand cmd = new SqlCommand("USP_DeleteBoard", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
                cmd.Parameters["@P_BoardNo"].Value = BoardNo;
                int affectedCount = cmd.ExecuteNonQuery();
                conn.Close();

                return affectedCount;

            } catch(Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                    var errorMessage = e.ToString();
                }
                return -1; // DB 접속 실패
            }
        }

        public int Update(Board model)
        {
            try
            {

                conn.Open();
                SqlCommand cmd = new SqlCommand("USP_UpdateBoard", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
                cmd.Parameters["@P_BoardNo"].Value = model.BoardNo;


                cmd.Parameters.Add("@P_BoardTitle", SqlDbType.VarChar, 255);
                cmd.Parameters["@P_BoardTitle"].Value = HttpUtility.HtmlEncode(model.BoardTitle);

                cmd.Parameters.Add("@P_BoardContent", SqlDbType.Text);
                cmd.Parameters["@P_BoardContent"].Value = HttpUtility.HtmlEncode(model.BoardContent);

                //cmd.Parameters.Add("@P_BoardWriter", SqlDbType.VarChar, 20);
                //cmd.Parameters["@P_BoardWriter"].Value = model.BoardWriter;

                // 해당쿼리문에 적용된 레코드의 개수 반환
                var affectedCount = cmd.ExecuteNonQuery();
                //Console.WriteLine(a);

                return affectedCount;

            }
            catch (Exception e)
            {
                if(conn != null)
                {
                    conn.Close();
                    var errorMessage = e.ToString();
                }

                return -1;
            }
        }

    }
}