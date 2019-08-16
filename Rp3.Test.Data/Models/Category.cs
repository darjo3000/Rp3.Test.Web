using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Models
{
    [Table("tbCategory", Schema = "dbo")]
    public class Category
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CategoryId { get; set; }
        public string Name { get; set; }
        public bool Active { get; set; }      
    }
}
