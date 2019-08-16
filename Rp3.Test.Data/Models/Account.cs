using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Models
{
    [Table("tbAccount", Schema = "dbo")]
    public class Account
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int AccountId { get; set; }
        public string Email { get; set; }
        public string FullName { get; set; }      
    }
}
