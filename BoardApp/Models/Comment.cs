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
        public int CommentLevel { get; set; }

        [Required]
        public int CommentOrder { get; set; }

        [Required]
        public string CommentWriter { get; set; }

        [Required]
        public string CommentContent { get; set; }

        [Required]
        public DateTime CommentCreatedDate { get; set; }

 
        [ForeignKey("BoardNo")]
        public virtual Board board { get; set; }

    }
}