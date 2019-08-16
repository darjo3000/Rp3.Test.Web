using Rp3.Test.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rp3.Test.WebApi.Data.Controllers
{
    public class TransactionTypeDataController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Get()
        {
            List<Rp3.Test.Common.Models.TransactionType> commonModel = new List<Common.Models.TransactionType>();

            using (DataService service = new DataService())
            {
                IEnumerable<Rp3.Test.Data.Models.TransactionType> dataModel = service.TransactionTypes.Get();
                commonModel = dataModel.Select(p => new Common.Models.TransactionType()
                {
                    Name = p.Name,
                    TransactionTypeId = p.TransactionTypeId
                }).ToList();                
            }

            return Ok(commonModel);
        }
    }
}
