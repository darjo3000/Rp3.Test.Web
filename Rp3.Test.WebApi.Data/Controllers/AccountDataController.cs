using Rp3.Test.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rp3.Test.WebApi.Data.Controllers
{
    public class AccountDataController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Get()
        {
            List<Rp3.Test.Common.Models.Account> commonModel = new List<Common.Models.Account>();

            using (DataService service = new DataService())
            {
                var query = service.Accounts.GetQueryable();

                commonModel = query.Select(p => new Common.Models.Account()
                {
                    Email = p.Email,
                    FullName = p.FullName
                }).ToList();
            }

            return Ok(commonModel);
        }

        [HttpGet]
        public IHttpActionResult GetById(int accountId)
        {
            Rp3.Test.Common.Models.Account commonModel = null;
            using (DataService service = new DataService())
            {
                var model = service.Accounts.GetByID(accountId);

                commonModel = new Common.Models.Account()
                {
                    Email = model.Email,
                    FullName = model.FullName
                };
            }
            return Ok(commonModel);
        }

        [HttpPost]
        public IHttpActionResult Insert(Rp3.Test.Common.Models.Account account)
        {
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Account accountModel = new Test.Data.Models.Account();
                accountModel.Email = account.Email;
                accountModel.FullName = account.FullName;

                accountModel.AccountId = service.Accounts.GetMaxValue<int>(p => p.AccountId,0) + 1;

                service.Accounts.Insert(accountModel);
                service.SaveChanges();
            }

            return Ok(true);
        }

        [HttpPost]
        public IHttpActionResult Update(Rp3.Test.Common.Models.Account account)
        {
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Account accountModel = new Test.Data.Models.Account();
                accountModel.Email = account.Email;
                accountModel.FullName = account.FullName;
                accountModel.AccountId = account.AccountId;

                service.Accounts.Update(accountModel);
                service.SaveChanges();
            }

            return Ok(true);
        }
    }
}
