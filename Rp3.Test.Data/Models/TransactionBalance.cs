using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Models
{
    public class TransactionBalance
    {
        public short TransactionTypeId { get; set; }
        public int CategoryId { get; set; }
        public int AccountId { get; set; }
        public string CategoryName { get; set; }
        public decimal Amount { get; set; }
    }
}
