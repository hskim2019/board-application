using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class Attachment
    {
        [Required]
        public int AttachmentNo { get; set; }

        [Required]
        public string AttachmentPath { get; set; }

        [Required]
        public int BoardNo { get; set; }

        [ForeignKey("BoardNo")]
        public virtual Board Board { get; set; }
    }
}