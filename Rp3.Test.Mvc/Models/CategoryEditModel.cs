using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Rp3.Test.Mvc.Models
{
    public class CategoryEditModel
    {
        public int CategoryId { get; set; }
        [Display(Name = "Nombre"), Required]
        public string Name { get; set; }
        [Display(Name = "Activo")]
        public bool Active { get; set; }
    }
}