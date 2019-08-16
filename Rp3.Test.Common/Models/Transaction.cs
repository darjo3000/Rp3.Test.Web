using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Common.Models
{
    public class Transaction
    {
        public int TransactionId { get; set; }
        public short TransactionTypeId { get; set; }
        public int CategoryId { get; set; }
        public int AccountId { get; set; }
        public DateTime RegisterDate { get; set; }
        public decimal Amount { get; set; }
        public string ShortDescription { get; set; }
        public string Notes { get; set; }        
    }
}
