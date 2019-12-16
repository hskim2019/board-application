using BoardApp.Models;
using BoardApp.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace BoardApp.Controllers
{
    public class BoardController : Controller
    {

        static string strConn = ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString;
        SqlConnection conn = new SqlConnection(strConn);




        // GET: Board
        /// <summary>
        /// 게시판 리스트
        /// </summary>
        /// <returns></returns>
        //public ActionResult Index()
        //{
        //    /** 1) DbContext & LinQ 로 DbSet에 데이터 받기**/
        //    //using (var db = new BoardAppDbContext())
        //    //{
        //    //    var list = db.Boards.ToList();

        //    //    var list2 = db.Boards.OrderByDescending(x => x.BoardNo).ToList();

        //    //    var list3 = db.Boards.OrderByDescending(x => x.BoardNo)     // = order by BoardNo Desc
        //    //        .Select(o => new Board                                  // = o : 개체 
        //    //        {
        //    //            BoardNo = o.BoardNo
        //    //        }).ToList();                                            // List로 반환 (ObjectList)

        //    //    var one = db.Boards.Where(x => x.BoardNo == 1).FirstOrDefault();   // = where BoardNo = 1로 select한 결과 중 가장 첫번쨰 열
        //    //}

        //    /**참고**/
        //    //DataSet ds = new DataSet();
        //    //DataTable dt = ds.Tables[0];
        //    //Board bs =


        //    /**삭제**/
        //    //   SqlCommand cmd = new SqlCommand("USP_SelectBoardList", conn);
        //    //   cmd.CommandType = CommandType.StoredProcedure;


        //    /**2) TableSet => TableData => List<Object> 형태로 View에 넘기기 **/

        //    //// 2-1. DB Connection 열기
        //    //conn.Open();

        //    //// 2-2. DataAdapter개체 생성하기 : Database와 DataSet 개체 사이의 링크
        //    //SqlDataAdapter dataAdapter = new SqlDataAdapter("USP_SelectBoardList", conn);

        //    //// 2-3. DataSet 개체 인스턴스 선언
        //    //// new DataSet("Database Name");
        //    //DataSet dataSet = new DataSet("BoardAppDb");

        //    //// 2-4. 데이터 로드
        //    //// Fill(DataSet, "DB의 Table Name")
        //    //dataAdapter.Fill(dataSet, "Boards");

        //    //// 2-5. DataSet ->  DataTable
        //    ////DataTable dataTable = boardDataSet.Tables["Boards"];
        //    //DataTable dataTable = dataSet.Tables[0];


        //    //// 2-6. Linq : AsEnuerable List<Object> View에 리턴
        //    //var convertedList = (from rw in dataTable.AsEnumerable()
        //    //                     select new Board()
        //    //                     {
        //    //                         BoardNo = Convert.ToInt32(rw["boardNo"]),
        //    //                         BoardTitle = rw["boardTitle"].ToString(),
        //    //                         BoardWriter = Convert.ToString(rw["boardWriter"]),
        //    //                         CreatedDate = Convert.ToDateTime(rw["createdDate"]),
        //    //                         ViewCount = Convert.ToInt32(rw["viewCount"])
        //    //                     }).ToList();
        //    //return View(convertedList);


        //    /**3) DataTable => List<Object>로 View에 넘기기**/

        //    // 3-1. Connection Open
        //    conn.Open();

        //    // 3-2. DataAdapter개체 생성하기 : Database와 DataSet 개체 사이의 링크
        //    SqlDataAdapter dataAdapter = new SqlDataAdapter("USP_SelectBoardList", conn);


        //    // 3-3. DataSet >  DataTable > DataRow
        //    // DataTable 생성
        //    DataTable dataTable = new DataTable();

        //    // 3-4. DataAdapter : Fill 메서드 : 
        //    // SelectCommand 탐색 결과를 DataSet개체의 테이블 데이터를 채워주는 역할
        //    dataAdapter.Fill(dataTable);

        //    // 3-5. DataTable => List<Object> : 모델 객체 리스트로 View에 넘겨주기
        //    List<Board> objList = new List<Board>();

        //    foreach (DataRow dataRow in dataTable.Rows)
        //    {
        //        Board board = new Board();
        //        board.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
        //        board.BoardTitle = dataRow["BoardTitle"].ToString();
        //        board.BoardWriter = dataRow["BoardWriter"].ToString();
        //        board.CreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
        //        board.ViewCount = Convert.ToInt32(dataRow["ViewCount"]);
        //        board.RowNo = Convert.ToInt32(dataRow["ROWNUM"]);

        //        objList.Add(board);
        //    }
        //    conn.Close();
        //    return View(objList);

        //} // Index() end

        /// <summary>
        /// 상세페이지 조회
        /// </summary>
        /// <returns></returns>
        public ActionResult Detail(int? boardNo)
        {
            //using (var db = new BoardAppDbContext())
            //{
            //    var board = db.Boards.FirstOrDefault(n => n.BoardNo.Equals(boardNo));
            //    return View(board);
            //}

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

                Board board = new Board();

                board.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
                board.BoardTitle = HttpUtility.HtmlDecode(dataRow["BoardTitle"].ToString());
                board.BoardContent = HttpUtility.HtmlDecode(dataRow["BoardContent"].ToString());
                board.BoardWriter = HttpUtility.HtmlDecode(dataRow["BoardWriter"].ToString());
                board.CreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
                board.ViewCount = Convert.ToInt32(dataRow["ViewCount"]);
                board.CommentCount = Convert.ToInt32(dataRow["CommentCTN"]);


                conn.Close();
                return View(board);

            }
            catch (Exception e)
            {
                if (conn != null)
                {
                    conn.Close();
                }
                string ee = e.ToString();
            }

            return Redirect("Index");

        }

        /// <summary>
        /// 게시판 추가
        /// </summary>
        /// <returns></returns>
        public ActionResult Add()
        {
            return View();
        }

        //[HttpPost]
        //[ValidateInput(false)]
        //public ActionResult Add(Board model)
        //{

        //    if (ModelState.IsValid)
        //    {

        //        //using( var db = new BoardAppDbContext())
        //        //{
        //        //    db.Boards.Add(model);

        //        //    if(db.SaveChanges() > 0)              // Commit, add 성공 시 성공개수 return 됨
        //        //    {
        //        //    return Redirect("Index");
        //        //    // return RedirectToAction("Index", "Board");
        //        //    }
        //        //}

        //        try
        //        {

        //            SqlCommand cmd = new SqlCommand("USP_InsertBoard", conn);
        //            conn.Open();
        //            cmd.CommandType = CommandType.StoredProcedure;

        //            cmd.Parameters.Add("@P_BoardTitle", SqlDbType.VarChar, 255);
        //            cmd.Parameters["@P_BoardTitle"].Value = HttpUtility.HtmlEncode(model.BoardTitle);


        //            cmd.Parameters.Add("@P_BoardContent", SqlDbType.Text);
        //            cmd.Parameters["@P_BoardContent"].Value = HttpUtility.HtmlEncode(model.BoardContent);

        //            cmd.Parameters.Add("@P_BoardWriter", SqlDbType.VarChar, 50);
        //            cmd.Parameters["@P_BoardWriter"].Value = HttpUtility.HtmlEncode(model.BoardWriter);
        //            cmd.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;
        //            // 해당쿼리문에 적용된 레코드의 개수 반환
        //            var result = cmd.ExecuteNonQuery();

        //            var idObject = cmd.Parameters["@id"].Value;
        //            int intId = 0;

        //            conn.Close();

        //            if (idObject != null)
        //            {
        //                intId = Convert.ToInt32(idObject);
        //                //return RedirectToAction("Detail", new { @boardNo = intId });
        //                return Json(new { status = "success", boardNo = intId }, JsonRequestBehavior.AllowGet);

        //            }
        //            else
        //            {
        //                return Json(new { message = "데이터 등록 실패" }, JsonRequestBehavior.AllowGet);
        //            }
        //            //intId = idObject != null ? Convert.ToInt32(idObject) : 0;


        //            // return Redirect("Index");

        //        }
        //        catch (Exception e)
        //        {
        //            if (conn != null)
        //            {
        //                conn.Close();
        //            }
        //            var errorMessage = e.ToString();
        //            ModelState.AddModelError(string.Empty, "게시물을 저장할 수 없습니다");
        //        }

        //    }
        //    // return View(model); // Valid 아닐 경우 확인
        //    return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);

        //}


        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Add(Board model, HttpPostedFileBase uploadFile)
        {

            if (ModelState.IsValid)
            {

                //using( var db = new BoardAppDbContext())
                //{
                //    db.Boards.Add(model);

                //    if(db.SaveChanges() > 0)              // Commit, add 성공 시 성공개수 return 됨
                //    {
                //    return Redirect("Index");
                //    // return RedirectToAction("Index", "Board");
                //    }
                //}

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



                    if(uploadFile.ContentLength > 0)
                    {
                        var fileName = Path.GetFileName(uploadFile.FileName);


                        

                        // Get file data
                        byte[] data = new byte[] { };
                        using (var binaryReader = new BinaryReader(uploadFile.InputStream))
                        {
                            data = binaryReader.ReadBytes(uploadFile.ContentLength);
                        }

                    

                    }





                    conn.Close();

                    if (idObject != null)
                    {
                        intId = Convert.ToInt32(idObject);
                        //return RedirectToAction("Detail", new { @boardNo = intId });
                        return Json(new { status = "success", boardNo = intId }, JsonRequestBehavior.AllowGet);

                    }
                    else
                    {
                        return Json(new { message = "데이터 등록 실패" }, JsonRequestBehavior.AllowGet);
                    }
                    //intId = idObject != null ? Convert.ToInt32(idObject) : 0;


                    // return Redirect("Index");

                }
                catch (Exception e)
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }
                    var errorMessage = e.ToString();
                    ModelState.AddModelError(string.Empty, "게시물을 저장할 수 없습니다");
                }

            }
            // return View(model); // Valid 아닐 경우 확인
            return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);

        }



        /// <summary>
        /// 게시판 수정
        /// </summary>
        /// <returns></returns>
        public ActionResult Update(int BoardNo)
        {
            conn.Open();

            // 파라미터 전달
            SqlCommand cmd = new SqlCommand("USP_SelectBoardListByNo", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
            cmd.Parameters["@P_BoardNo"].Value = BoardNo;

            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            dataAdapter.SelectCommand = cmd;

            DataTable dataTable = new DataTable();
            dataAdapter.Fill(dataTable);
            DataRow dataRow = dataTable.Rows[0];

            Board board = new Board();

            board.BoardNo = Convert.ToInt32(dataRow["BoardNo"]);
            board.BoardTitle = dataRow["BoardTitle"].ToString();
            board.BoardContent = dataRow["BoardContent"].ToString();
            board.BoardWriter = dataRow["BoardWriter"].ToString();
            board.CreatedDate = Convert.ToDateTime(dataRow["CreatedDate"]);
            board.ViewCount = Convert.ToInt32(dataRow["ViewCount"]);


            conn.Close();
            return View(board);

        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Update(Board model)
        {
            if (ModelState.IsValid)
            {
                try
                {

                    SqlCommand cmd = new SqlCommand("USP_UpdateBoard", conn);
                    conn.Open();
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
                    var a = cmd.ExecuteNonQuery();
                    //Console.WriteLine(a);

                    conn.Close();

                    //return Redirect("Index");
                    // return RedirectToAction("Detail", new { @boardNo = model.BoardNo });
                    return Json(new { status = "success", boardNo = model.BoardNo }, JsonRequestBehavior.AllowGet);

                }
                catch
                {
                    if (conn != null)
                    {
                        conn.Close();
                        return Json(new { status = "fail" }, JsonRequestBehavior.AllowGet);
                    }
                    ModelState.AddModelError(string.Empty, "게시물을 저장할 수 없습니다");
                }

            }
            //return View(model); // Valid 아닐 경우 확인
            return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 게시판 삭제
        /// </summary>
        /// <returns></returns>
        //public ActionResult Delete(int BoardNo)
        //{
        //    conn.Open();
        //    SqlCommand cmd = new SqlCommand("USP_DeleteBoard", conn);
        //    cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.Parameters.Add("@P_BoardNo", SqlDbType.Int);
        //    cmd.Parameters["@P_BoardNo"].Value = BoardNo;
        //    int affectedCount = cmd.ExecuteNonQuery();
        //    conn.Close();

        //    if(affectedCount == 0)
        //        return Redirect("Detail");


        //    return Redirect("Index");
        //}



        //[System.Web.Services.WebMethod]
        //[System.Web.Script.Services.ScriptMethod]
        public ActionResult Delete(int BoardNo)
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

                if (affectedCount == 0)
                {
                    return Json(new { message = "no data" }, JsonRequestBehavior.AllowGet);
                    //return Redirect("Detail");
                }



            }
            catch (Exception e)
            {
                if (conn != null)
                {
                    conn.Close();
                    var errorMessage = e.ToString();
                }
                return Json(new { message = "해당 글이 없습니다." }, JsonRequestBehavior.AllowGet);
            }


            return Json(new { status = "success" }, JsonRequestBehavior.AllowGet);

        }






        ///페이징
        ///
        public ActionResult Index(int? curPage, int? pageScale)
        {
            // 전체 개시물 개수 rowCount


            // 전체 페이지 개수 totalPage = rowCount / pageSize 
            // totalPage == 0 이거나 rowCount % pageSize > 0 면 totalPage++ (마지막 페이지의 잔여 개시물)
            // curPage > totalPage 면 curPage = totalPage

            // 가져올 페이지의 게시물시작번호 rowNo = (현재페이지-1) * pageSize

            // 리스트 가져오기
            // DB에서 필요한 것 : limi 시작rowNo , 한페이지당출력할게시물수pageSize
            if (curPage != null)
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

                // rowCount, curPage, pageScale 파라미터 전달 => 게시물 시작번호, 끝번호 계산
                //int  tempCurPage = 1;
                //int temppageScale = 10;
                var tempCurPage = (int)curPage;
                var temppageScale = (int)pageScale;


                BoardPager boardPager = new BoardPager(rowCount, tempCurPage, temppageScale);
                int start = boardPager.PageBegin;
                int end = boardPager.PageEnd;


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
                // return View();
                // return View(objList);

                Hashtable ht = new Hashtable();
                ht.Add("list", objList);
                ht.Add("rowCount", rowCount);
                ht.Add("boardPager", boardPager);

                //return Json(new { list = objList, rowCount = rowCount, boardPager = boardPager }, JsonRequestBehavior.AllowGet);
                return Json(ht, JsonRequestBehavior.AllowGet);
                // view에 넘겨줄 것 : select 결과 , 레코드 개수, boardPager

            }
            else
            {
                return View();
            }

            //return View();



        } // Index() end



    }
}