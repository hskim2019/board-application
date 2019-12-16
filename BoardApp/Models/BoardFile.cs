﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BoardApp.Models
{
    public class BoardFile
    {
        [Key]
        public int FileNo { get; set; }

        [Required]
        public string FileName { get; set; }

        [Required]
        public string FilePath { get; set; }

        [Required]
        public int BoardNo { get; set; }

        [ForeignKey("BoardNo")]
        public virtual Board Board { get; set; }
    }
}