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

        public File File { get; set; }

        public Comment Comment { get; set; }

    }

}