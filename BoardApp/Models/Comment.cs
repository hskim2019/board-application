using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class Comment
    {
        [Key]
        public int CommentNo { get; set; }

        [Required]
        public int BoardNo { get; set;}

        [Required]
        public int OriginCommentNo { get; set; }

        [Required]
        public int ParentCommentNo { get; set; }

        [Required]
        public int CommentLevel { get; set; }

        [Required]
        public int CommentOrder { get; set; }

        [Required]
        public string CommentWriter { get; set; }

        [Required]
        public string CommentPassword { get; set; }

        [Required]
        public string CommentContent { get; set; }

        [Required]
        public DateTime CommentCreatedDate { get; set; }


        public string CreatedDateString
        {
            get { return CommentCreatedDate.ToShortDateString(); }
        }

        public int CommentFlag { get; set; }

        // 데이터 받을 때만 사용
        public string ParentCommentWriter { get; set; }

        [ForeignKey("BoardNo")]
        public virtual Board board { get; set; }

    }
}