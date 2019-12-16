using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BoardApp.Controllers
{
    public class UploadController : Controller
    {
        static byte[] binData;
        static string ImageFileName;
        static string FolderPath;

        // GET: Upload
        public ActionResult SaveImages()
        {
            return View();
        }
        
        [HttpPost]
        public ActionResult SaveImages(HttpPostedFileBase UploadedImage, int test)
        {

            int t = test;
            int s = t;




            if (UploadedImage.ContentLength > 0)
            {
                ImageFileName = Path.GetFileName(UploadedImage.FileName);

                BinaryReader b = new BinaryReader(UploadedImage.InputStream);
                binData = b.ReadBytes(UploadedImage.ContentLength);


                //물리적 저장
                //FolderPath = Path.Combine(Server.MapPath("~/UploadedImages"), ImageFileName);
                //UploadedImage.SaveAs(FolderPath);
            }

            ViewBag.Message = "Image File Uploaded Successfully";

            // 파일삭제
            //FileInfo fi = new FileInfo(FolderPath);
            //fi.Delete();

            return View();
        }
        
        public FileResult Download()
        {
            string fileName = "memo.txt";
            return File(binData, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }

    }
}