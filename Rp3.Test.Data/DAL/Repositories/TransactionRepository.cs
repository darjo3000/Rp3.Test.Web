using Rp3.Test.Data.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Repositories
{
    public class TransactionRepository : Repository<Transaction>
    {
        public TransactionRepository(DbContext context) : base(context)
        {
        }

        /*
        Ejemplo consultar datos a partir de un procedimiento almacenado
        */

        public List<TransactionBalance> GetBalance(int accountId, DateTime dateStart, DateTime dateEnd)
        {
            return this.DataBase.SqlQuery<TransactionBalance>("EXEC dbo.spGetBalance @AccountId = {0}", accountId).ToList();
        }
    }
}