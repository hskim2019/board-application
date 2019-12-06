using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class File
    {
        [Key]
        public int FileNo { get; set; }

        [Required]
        public int FileName { get; set; }

        [Required]
        public int FilePath { get; set; }

        [Required]
        public int BoardNo { get; set; }

        [ForeignKey("BoardNo")]
        public virtual Board Board { get; set; }
    }
}