using BoardApp.Models;
using BoardApp.Service;
using System;
using System.Collections;
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

            Hashtable ht = new Hashtable();
            ht.Add("commentList", commentList);
            ht.Add("cmtCount", commentCount);

            //return Json(new { commentList = commentList, cmtCount = commentCount }, JsonRequestBehavior.AllowGet);
            return Json(ht, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Add(Comment model)
        {
            if (ModelState.IsValid)
            {
                // Insert 하고 결과 table 받아오기
                Comment obj = commentService.InsertComment(model);
                if (obj != null)
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("status", "success");
                    ht.Add("obj", obj);

                    //return Json(new { status = "success", obj = obj }, JsonRequestBehavior.AllowGet);
                    return Json(ht, JsonRequestBehavior.AllowGet);
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
                return Json(new { message = "비밀 번호가 일치하지 않습니다." }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { status = "success" }, JsonRequestBehavior.AllowGet);

            }
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Update(int CommentNo, string CommentContent, string CommentPassword)
        {
            if(ModelState.IsValid)
            {
                int affectedCount = commentService.UpdateComment(CommentNo, CommentContent, CommentPassword);

                if(affectedCount != 0)
                {
                    return Json(new { status = "success"}, JsonRequestBehavior.AllowGet);
                } else
                {
                    return Json(new { message = "비밀번호가 일치하지 않습니다" }, JsonRequestBehavior.AllowGet);
                }
            }

            return Json(new { message = "데이터 전달 실패" }, JsonRequestBehavior.AllowGet);
        }


    }
}