using BoardApp.Models;
using BoardApp.Service;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BoardApp.Controllers
{
    public class CommentController : Controller
    {

        CommentService commentService = new CommentService();

        // GET: Comment
        public ActionResult Index(int boardNo)
        {
            List<Comment> commentList = commentService.ListComment(boardNo);
            var commentCount = commentService.CountCommentList(boardNo);

            return Json(new { commentList = commentList, cmtCount = commentCount }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Add(Comment model)
        {
            if (ModelState.IsValid)
            {
                // Insert 하고 결과 table 받아오기
                Comment obj = commentService.InsertComment(model);
                if (obj != null)
                {

                    return Json(new { status = "success", obj = obj }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { message = "댓글 등록 실패" }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { message = "데이터 전달 실패" }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult Delete(int CommentNo, string Password, int CommentLevel)
        {
            int affectedCount = commentService.DeleteComment(CommentNo, Password, CommentLevel);
            // affectiedNo 있으면
            if (affectedCount == 0)
            {
                return Json(new { message = "삭제 실패입니다." }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { status = "success" }, JsonRequestBehavior.AllowGet);

            }
        }


    }
}