using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class Board
    {
        [Key]
        public int BoardNo { get; set; }

        [Required]
        public string BoardTitle { get; set; }

        [Required]
        public string BoardContent { get; set; }

        [Required]
        public string BoardWriter { get; set; }

        [Required]
        public DateTime CreatedDate { get; set; }

        [Required]
        public int ViewCount { get; set; }


        public string CreatedDateString {
            get { return CreatedDate.ToShortDateString(); }
        }

        public int RowNo { get; set; }

        // 댓글 개수
        public int CommentCount { get; set; }

        public BoardFile BoardFile { get; set; }

        public List<BoardFile> BoardFiles { get; set; }

        public Comment Comment { get; set; }

        public string AttachedFileName { get; set; }

    }

}