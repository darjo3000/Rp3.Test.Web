using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Models
{
    public class TransactionCreateModel
    {
        [Display(Name = "Tipo Movimiento"), Required]
        public short TransactionTypeId { get; set; }
        [Display(Name = "Categoria"), Required]
        public int CategoryId { get; set; }
        [Display(Name = "Fecha Registro"), Required]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime RegisterDate { get; set; }
        [Display(Name = "Monto"), Required]
        public decimal Amount { get; set; }
        [Display(Name = "Descripcion Breve"), Required]
        public string ShortDescription { get; set; }
        [Display(Name = "Notas")]
        public string Notes { get; set; }

        public SelectList CategorySelectList { get; set; }
        public SelectList TransactionTypeSelectList { get; set; }
    }
}