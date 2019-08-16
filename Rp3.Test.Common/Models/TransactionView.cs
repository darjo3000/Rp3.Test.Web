using System;
using System.Collections.Generic;
using System.Text;

namespace Rp3.Test.Common.Models
{
    public class TransactionView : Transaction
    {
        public string CategoryName { get; set; }
        public string TransactionType { get; set; }
    }
}
