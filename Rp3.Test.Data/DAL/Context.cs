using Rp3.Test.Data.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data
{
    public class Context: System.Data.Entity.DbContext
    {        
        public Context()
        {
        }

        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<TransactionType> TransactionTypes { get; set; }
        public DbSet<Category> Categories { get; set; }

    }
}
