using Rp3.Test.Common.Models;
using Rp3.Test.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rp3.Test.WebApi.Data.Controllers
{
    public class TransactionDataController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Get(int accountId)
        {            
            List<Rp3.Test.Common.Models.TransactionView> commonModel = new List<Common.Models.TransactionView>();

            using (DataService service = new DataService())
            {
                IEnumerable<Rp3.Test.Data.Models.Transaction> 
                    dataModel = service.Transactions.Get(p => p.AccountId == accountId,
                    includeProperties: "Category,TransactionType", 
                    orderBy: p=> p.OrderByDescending(o=>o.RegisterDate) );

                //Para incluir una condición, puede usar el primer parametro de Get
                /*
                 * Ejemplo
                 IEnumerable<Rp3.Test.Data.Models.Transaction>
                    dataModel = service.Transactions.Get(p=> p.TransactionId > 0
                    includeProperties: "Category,TransactionType",
                    orderBy: p => p.OrderByDescending(o => o.RegisterDate));

                 */

                commonModel = dataModel.Select(p => new Common.Models.TransactionView()
                {
                    CategoryId = p.CategoryId,
                    AccountId = p.AccountId,
                    CategoryName = p.Category.Name,
                    Notes = p.Notes,
                    Amount = p.Amount,
                    RegisterDate = p.RegisterDate,
                    ShortDescription = p.ShortDescription,
                    TransactionId = p.TransactionId,
                    TransactionType = p.TransactionType.Name,
                    TransactionTypeId = p.TransactionTypeId
                }).ToList();
            }

            return Ok(commonModel);
        }

        [HttpGet]
        public IHttpActionResult GetById(int transactionId)
        {
            Rp3.Test.Common.Models.Transaction commonModel = null;
            using (DataService service = new DataService())
            {
                var model = service.Transactions.GetByID(transactionId);

                commonModel = new Common.Models.Transaction()
                {
                    TransactionId = model.TransactionId,
                    TransactionTypeId = model.TransactionTypeId,
                    CategoryId = model.CategoryId,
                    AccountId = model.AccountId,
                    RegisterDate = model.RegisterDate,
                    Amount = model.Amount,
                    ShortDescription = model.ShortDescription,
                    Notes = model.Notes
                };
            }
            return Ok(commonModel);
        }

        [HttpGet]
        public IHttpActionResult GetBalance(int accountId)
        {
            List<Rp3.Test.Common.Models.TransactionView> commonModel = new List<Common.Models.TransactionView>();

            using (DataService service = new DataService())
            {
                IEnumerable<Rp3.Test.Data.Models.TransactionBalance> dataModel = service.Transactions.GetBalance(accountId, DateTime.Now, DateTime.Now);

                commonModel = dataModel.Select(p => new Common.Models.TransactionView()
                {
                    CategoryId = p.CategoryId,
                    AccountId = p.AccountId,
                    CategoryName = p.CategoryName,
                    Amount = p.Amount,
                    TransactionTypeId = p.TransactionTypeId
                }).ToList();
            }

            return Ok(commonModel);
        }

        [HttpPost]
        public IHttpActionResult Insert(Rp3.Test.Common.Models.Transaction transaction)
        {
            //Complete the code
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Transaction model = new Test.Data.Models.Transaction();
                model.TransactionTypeId = transaction.TransactionTypeId;
                model.CategoryId = transaction.CategoryId;
                model.AccountId = transaction.AccountId;
                model.RegisterDate = DateTime.Now;
                model.ShortDescription = transaction.ShortDescription;
                model.Amount = transaction.Amount;
                model.Notes = transaction.Notes;
                model.TransactionId = service.Transactions.GetMaxValue<int>(p => p.TransactionId, 0) + 1;
                
                service.Transactions.Insert(model);
                service.SaveChanges();
            }

            return Ok(true);
        }

        [HttpPost]
        public IHttpActionResult Update(Rp3.Test.Common.Models.Transaction transaction)
        {
            //Complete the code
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Transaction model = service.Transactions.GetByID(transaction.TransactionId);
                model.TransactionTypeId = transaction.TransactionTypeId;
                model.CategoryId = transaction.CategoryId;
                model.AccountId = transaction.AccountId;
                model.ShortDescription = transaction.ShortDescription;
                model.Amount = transaction.Amount;
                model.Notes = transaction.Notes;

                service.Transactions.Update(model);
                service.SaveChanges();
            }

            return Ok(true);
        }
    }
}
