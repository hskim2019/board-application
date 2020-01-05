using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class AttachedFile
    {

        [Key]
        public int AttachedFileNo { get; set; }

        [Required]
        public string AttachedFileName { get; set; }

        [Required]
        public byte[] AttachedFileContent { get; set; }

        [Required]
        public int BoardNo { get; set; }

        [ForeignKey("BoardNo")]
        public virtual Board Board { get; set; }

    }
}