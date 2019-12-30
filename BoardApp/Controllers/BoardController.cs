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

        BoardService boardService = new BoardService();
        AttachedFileService attachedFileService = new AttachedFileService();
        AttachmentService attachmentService = new AttachmentService();


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

                //전체 게시물 개수 구하기
                var rowCount = boardService.RowCount();

                // rowCount, curPage, pageScale 파라미터 전달 => 게시물 시작번호, 끝번호 계산

                BoardPager boardPager = new BoardPager(rowCount, (int)curPage, (int)pageScale);
                int start = boardPager.PageBegin;
                int end = boardPager.PageEnd;

                List<Board> objList = boardService.Index(start, end);

                Hashtable ht = new Hashtable();
                ht.Add("list", objList);
                ht.Add("rowCount", rowCount);
                ht.Add("boardPager", boardPager);

                //return Json(new { list = objList, rowCount = rowCount, boardPager = boardPager }, JsonRequestBehavior.AllowGet);
                return Json(ht, JsonRequestBehavior.AllowGet);

            }
            else
            {
                return View();
            }

        } // Index() end



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
            if (boardNo != null)
            {

                Board board = boardService.Detail((int)boardNo);
                if (board != null)
                {

                    return View(board);
                }
                return Redirect("Index");
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
        //public ActionResult Add(Board model, HttpPostedFileBase uploadFile)
        //{

        //    if (ModelState.IsValid)
        //    {
        //        // Linq로 데이터 Insert하는 방법
        //        //using( var db = new BoardAppDbContext())
        //        //{
        //        //    db.Boards.Add(model);

        //        //    if(db.SaveChanges() > 0)              // Commit, add 성공 시 성공개수 return 됨
        //        //    {
        //        //    return Redirect("Index");
        //        //    // return RedirectToAction("Index", "Board");
        //        //    }
        //        //}

        //        var intId = boardService.Insert(model);

        //        if (intId == 0) // DB 저장 실패
        //        {
        //            return Json(new { message = "데이터 등록 실패" }, JsonRequestBehavior.AllowGet);
        //        }
        //        else if (intId == -1) // DB Connection 실패
        //        {
        //            return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
        //        }
        //        else // Board데이터 ADD 성공
        //        {

        //            //if (uploadFile.ContentLength > 0) //데이터가 있으면 저장하기
        //            if (uploadFile != null)
        //            {
        //                var fileName = Path.GetFileName(uploadFile.FileName);

        //                // Get file data
        //                //byte[] data = new byte[] { };
        //                //using (var binaryReader = new BinaryReader(uploadFile.InputStream))
        //                //{
        //                //    data = binaryReader.ReadBytes(uploadFile.ContentLength);
        //                //}


        //                byte[] data = new byte[uploadFile.ContentLength];
        //                uploadFile.InputStream.Read(data, 0, uploadFile.ContentLength);


        //                int affectedFileCount = attachedFileService.Insert(intId, fileName, data);

        //                if (affectedFileCount == 0 || affectedFileCount == -1)
        //                {
        //                    // 게시글 지워줘야 함
        //                    return Json(new { message = "첨부파일 등록 실패" }, JsonRequestBehavior.AllowGet);
        //                }


        //            }


        //            return Json(new { status = "success", boardNo = intId }, JsonRequestBehavior.AllowGet);


        //        }
        //    }

        //    return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
        //}


        /// <summary>
        /// 게시판 수정
        /// </summary>
        /// <returns></returns>
        public ActionResult Update(int? BoardNo)
        {
            if (BoardNo != null)
            {
                Board board = boardService.Update((int)BoardNo);
                
                if (board != null)
                {

                    return View(board);
                }
                else
                {
                    return RedirectToAction("Index", "Board");
                }

            }
            else
            {
                return RedirectToAction("Index", "Board");
            }

        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Update(Board model, HttpPostedFileBase uploadFile, string FileName)
        {
            if (ModelState.IsValid)
            {

                int affectedCount = boardService.Update(model);
                if (affectedCount == 0 || affectedCount == -1)
                {
                    return Json(new { message = "데이터 수정 실패" }, JsonRequestBehavior.AllowGet);
                }
                else if (affectedCount > 0)
                {
                    if (uploadFile != null)
                    {
                        var fileName = Path.GetFileName(uploadFile.FileName);

                        // Get file data
                        //byte[] data = new byte[] { };
                        //using (var binaryReader = new BinaryReader(uploadFile.InputStream))
                        //{
                        //    data = binaryReader.ReadBytes(uploadFile.ContentLength);
                        //}


                        byte[] data = new byte[uploadFile.ContentLength];
                        uploadFile.InputStream.Read(data, 0, uploadFile.ContentLength);


                        int affectedFileCount = attachedFileService.Update(model.BoardNo, fileName, data);

                        if (affectedFileCount == 0 || affectedFileCount == -1)
                        {
                            // 게시글 업데이트 한 것 취소 해줘야 함
                            return Json(new { message = "첨부파일 수정 실패" }, JsonRequestBehavior.AllowGet);
                        }
                    }



                    if (FileName.Length == 0)
                    {
                        attachedFileService.Delete(model.BoardNo);
                    }




                    return Json(new { status = "success", boardNo = model.BoardNo }, JsonRequestBehavior.AllowGet);

                }


            }
            //return View(model); // Valid 아닐 경우 확인
            return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult Delete(int BoardNo)
        {

            int affectedCount = boardService.Delete(BoardNo);


            if (affectedCount == 0)
            {
                return Json(new { message = "no data" }, JsonRequestBehavior.AllowGet);
                //return Redirect("Detail");
            }
            else if (affectedCount == -1)
            {

                return Json(new { message = "데이터 삭제 실패" }, JsonRequestBehavior.AllowGet);
            }

            return Json(new { status = "success" }, JsonRequestBehavior.AllowGet);

        }




        // 다중파일첨부test
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Add(Board model, HttpPostedFileBase[] uploadFile)
        {

            if (ModelState.IsValid)
            {
                var intId = boardService.Insert(model);

                if (intId == 0) // DB 저장 실패
                {
                    return Json(new { message = "데이터 등록 실패" }, JsonRequestBehavior.AllowGet);
                }
                else if (intId == -1) // DB Connection 실패
                {
                    return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
                }
                else // Board데이터 ADD 성공
                {

                    //if (uploadFile.ContentLength > 0) //데이터가 있으면 저장하기
                    if (uploadFile != null)
                    {
                        foreach (HttpPostedFileBase file in uploadFile)
                        {
                            if (file != null && file.ContentLength > 0)
                            {
                                try
                                {


                                    var fileName = Path.GetFileName(file.FileName);
                                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                                    string fileSize = file.ContentLength.ToString();

                                    string path = Path.Combine(Server.MapPath("~/UploadedFiles"), uniqueFileName);

                                    //var directoryInfo = new FileInfo(path).Directory;
                                    //if (directoryInfo != null)
                                    //{
                                    //    directoryInfo.Create();
                                    //}

                                    
                                    file.SaveAs(path);

                                    // DB에 boardNo, path 넣어주기

                                    int affectedFileCount = attachmentService.Insert(intId, path);

                                    if (affectedFileCount == 0 || affectedFileCount == -1)
                                    {
                                        FileInfo fileInfo = new FileInfo(path);
                                        // 게시글 지워줘야 함
                                        fileInfo.Delete();
                                        return Json(new { message = "첨부파일 등록 실패" }, JsonRequestBehavior.AllowGet);
                                    }

                                }
                                catch (Exception e)
                                {
                                    string errorMessage = e.ToString();
                                }
                            }
                            else
                            {

                            }
                        }








                    }


                    return Json(new { status = "success", boardNo = intId }, JsonRequestBehavior.AllowGet);


                }
            }

            return Json(new { message = "데이터 전달 실패. 목록 페이지로 돌아갑니다." }, JsonRequestBehavior.AllowGet);
        }





    }
}