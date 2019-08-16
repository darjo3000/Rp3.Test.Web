using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Controllers
{
    public class CategoryController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            List<Rp3.Test.Mvc.Models.CategoryViewModel> categories = proxy.GetCategories().
                Select(p=> new Models.CategoryViewModel()
                {
                    Active = p.Active,
                    CategoryId = p.CategoryId,
                    Name = p.Name
                }).ToList();

            return View(categories);
        }

        public ActionResult Create()
        {

            Rp3.Test.Mvc.Models.CategoryCreateModel createModel = new Models.CategoryCreateModel();

            createModel.Name = "";

            return View(createModel);
        }

        [HttpPost]
        public ActionResult Create(Rp3.Test.Mvc.Models.CategoryCreateModel createModel)
        {
            if (!ModelState.IsValid)
            {
                return View(createModel);
            }

            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Common.Models.Category commonModel = new Common.Models.Category();

            commonModel.Active = true;
            commonModel.Name = createModel.Name;

            bool respondeOk = proxy.InsertCategory(commonModel);

            if (respondeOk)
                return RedirectToAction("Index");
            else
                return View(createModel);
        }



        public ActionResult Edit(int categoryId)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Mvc.Models.CategoryEditModel editModel = new Models.CategoryEditModel();

            var commonModel = proxy.GetCategory(categoryId);

            editModel.Active = commonModel.Active;
            editModel.CategoryId = commonModel.CategoryId;
            editModel.Name = commonModel.Name;

            return View(editModel);
        }

        [HttpPost]
        public ActionResult Edit(Rp3.Test.Mvc.Models.CategoryEditModel editModel)
        {
            if (!ModelState.IsValid)
            {
                return View(editModel);
            }

            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Common.Models.Category commonModel = new Common.Models.Category();
            
            commonModel.Active = editModel.Active;
            commonModel.CategoryId = editModel.CategoryId;
            commonModel.Name = editModel.Name;

            bool respondeOk = proxy.UpdateCategory(commonModel);

            if (respondeOk)
                return RedirectToAction("Index");
            else
                return View(editModel);
        }
    }
}
