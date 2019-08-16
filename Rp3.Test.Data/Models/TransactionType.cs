using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Models
{
    [Table("tbTransactionType", Schema = "dbo")]
    public class TransactionType
    {
        [Key]
        public short TransactionTypeId { get; set; }
        public string Name { get; set; }
    }
}
