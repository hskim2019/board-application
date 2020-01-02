using BoardApp.Models;
using BoardApp.Service;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BoardApp.Controllers
{
    public class AttachmentController : Controller
    {
        AttachmentService attachmentService = new AttachmentService();

        // GET: Attachment
        public ActionResult Index(int boardNo)
        {
            List<Attachment> attachmentList = attachmentService.Index(boardNo);
            var attachmentCount = attachmentService.Count(boardNo);

            Hashtable ht = new Hashtable();
            ht.Add("list", attachmentList);
            ht.Add("rowCount", attachmentCount);

            return Json(ht, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Download(int attachmentNo)
        {

            var filePath = attachmentService.GetFilePath(attachmentNo);

            if(filePath == "error")
            {
            return Json(new { message = "파일 다운로드 실패입니다." }, JsonRequestBehavior.AllowGet);
            }

            string[] result = filePath.Split('_');
            var fileName = result[1];

             byte[] fileBytes = System.IO.File.ReadAllBytes(filePath);

             return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);

        }
    }
}