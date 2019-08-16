using Rp3.Test.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rp3.Test.WebApi.Data.Controllers
{
    public class CategoryDataController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Get(bool? active = null)
        {
            List<Rp3.Test.Common.Models.Category> commonModel = new List<Common.Models.Category>();

            using (DataService service = new DataService())
            {
                var query = service.Categories.GetQueryable();
                
                if (active.HasValue)
                    query = query.Where(p => p.Active == active.Value);

                commonModel = query.Select(p => new Common.Models.Category()
                {
                    Active = p.Active,
                    CategoryId = p.CategoryId,
                    Name = p.Name                    
                }).ToList();                
            }

            return Ok(commonModel);
        }

        [HttpGet]
        public IHttpActionResult GetById(int categoryId)
        {
            Rp3.Test.Common.Models.Category commonModel = null;
            using (DataService service = new DataService())
            {
                var model = service.Categories.GetByID(categoryId);

                commonModel = new Common.Models.Category()
                {
                    Active = model.Active,
                    CategoryId = model.CategoryId,
                    Name = model.Name
                };
            }
            return Ok(commonModel);
        }

        [HttpPost]
        public IHttpActionResult Insert(Rp3.Test.Common.Models.Category category)
        {
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Category categoryModel = new Test.Data.Models.Category();
                categoryModel.Active = category.Active;                
                categoryModel.Name = category.Name;

                categoryModel.CategoryId = service.Categories.GetMaxValue<int>(p => p.CategoryId,0) + 1;

                service.Categories.Insert(categoryModel);
                service.SaveChanges();
            }

            return Ok(true);
        }

        [HttpPost]
        public IHttpActionResult Update(Rp3.Test.Common.Models.Category category)
        {
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Category categoryModel = new Test.Data.Models.Category();
                categoryModel.Active = category.Active;
                categoryModel.CategoryId = category.CategoryId;
                categoryModel.Name = category.Name;

                service.Categories.Update(categoryModel);
                service.SaveChanges();
            }

            return Ok(true);
        }
    }
}
