using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Models
{
    [Table("tbTransaction", Schema = "dbo")]
    public class Transaction
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TransactionId { get; set; }
        public short TransactionTypeId { get; set; }
        public int CategoryId { get; set; }
        public int AccountId { get; set; }
        public DateTime RegisterDate { get; set; }
        public string ShortDescription { get; set; }
        public decimal Amount { get; set; }
        public string Notes { get; set; }

        [ForeignKey("AccountId")]
        public Account Account { get; set; }

        [ForeignKey("CategoryId")]
        public Category Category { get; set; }

        [ForeignKey("TransactionTypeId")]
        public TransactionType TransactionType { get; set; }
    }
}
