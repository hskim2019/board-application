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
            List<Comment> commentList = commentService.List(boardNo);

            return Json(new { commentList = commentList }, JsonRequestBehavior.AllowGet);
        }
    }
}