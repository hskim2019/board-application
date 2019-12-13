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
        // GET: Upload
        public ActionResult SaveImages()
        {
            return View();
        }
        static byte[] binData;
        
        [HttpPost]
        public ActionResult SaveImages(HttpPostedFileBase UploadedImage)
        {
            if(UploadedImage.ContentLength > 0)
            {
                string ImageFileName = Path.GetFileName(UploadedImage.FileName);

                BinaryReader b = new BinaryReader(UploadedImage.InputStream);
                binData = b.ReadBytes(UploadedImage.ContentLength);


                //string FolderPath = Path.Combine(Server.MapPath("~/UploadedImages"), ImageFileName);
                //UploadedImage.SaveAs(FolderPath);
            }

            ViewBag.Message = "Image File Uploaded Successfully";
            return View();
        }
        
        public FileResult Download()
        {
            string fileName = "memo.txt";
            return File(binData, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }

    }
}