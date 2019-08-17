using Rp3.Test.Common.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Controllers
{
    public class TransactionController : Controller
    {

        public ActionResult Index()
        {
            Proxies.Proxy proxy = new Proxies.Proxy();

            int accountId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AccountId"]);
            var data = proxy.GetTransactions(accountId);

            List<Rp3.Test.Mvc.Models.TransactionViewModel> model = new List<Models.TransactionViewModel>();

            foreach(var item in data)
            {
                model.Add(new Models.TransactionViewModel()
                {
                    Amount = item.Amount,
                    CategoryId = item.CategoryId,
                    CategoryName = item.CategoryName,
                    Notes = item.Notes,
                    RegisterDate = item.RegisterDate,
                    ShortDescription = item.ShortDescription,
                    TransactionId = item.TransactionId,
                    TransactionType = item.TransactionType,
                    TransactionTypeId = item.TransactionTypeId                    
                });
            }
            
            return View(model);
        }

        public ActionResult Create()
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();
            Rp3.Test.Mvc.Models.TransactionCreateModel createModel = new Models.TransactionCreateModel();

            List<TransactionType> transactionTypeList = proxy.GetTransactionTypes();
            List<SelectListItem> transactionTypeItems = transactionTypeList.Select(x => GetTransactionTypeItem(x)).ToList();
            createModel.TransactionTypeSelectList = new SelectList(transactionTypeItems, "Value", "Text", 1);

            List<Category> categoryList = proxy.GetCategories();
            List<SelectListItem> categoryItems = categoryList.Select(x => GetCategoryItem(x)).ToList();
            createModel.CategorySelectList = new SelectList(categoryItems, "Value", "Text", 1);
            
            createModel.Amount = 0;
            createModel.ShortDescription = "";
            createModel.Notes = "";

            return View(createModel);
        }

        [HttpPost]
        public ActionResult Create(Rp3.Test.Mvc.Models.TransactionCreateModel createModel)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            int accountId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AccountId"]);

            List<TransactionType> transactionTypeList = proxy.GetTransactionTypes();
            List<SelectListItem> transactionTypeItems = transactionTypeList.Select(x => GetTransactionTypeItem(x)).ToList();
            createModel.TransactionTypeSelectList = new SelectList(transactionTypeItems, "Value", "Text", 1);

            List<Category> categoryList = proxy.GetCategories();
            List<SelectListItem> categoryItems = categoryList.Select(x => GetCategoryItem(x)).ToList();
            createModel.CategorySelectList = new SelectList(categoryItems, "Value", "Text", 1);

            if (createModel.Amount <= 0)
            {
                ModelState.AddModelError("Amount", "El monto debe ser mayor a cero");
            }

            if (!ModelState.IsValid)
            {
                return View(createModel);
            }

            Rp3.Test.Common.Models.Transaction commonModel = new Common.Models.Transaction();

            commonModel.TransactionTypeId = createModel.TransactionTypeId;
            commonModel.CategoryId = createModel.CategoryId;
            commonModel.AccountId = accountId;
            commonModel.Amount = createModel.Amount;
            commonModel.ShortDescription = createModel.ShortDescription;
            commonModel.Notes = createModel.Notes;

            bool respondeOk = proxy.InsertTransaction(commonModel);

            if (respondeOk)
                return RedirectToAction("Index");
            else
            {
                return View(createModel);
            }
        }

        public ActionResult Edit(int transactionId)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Mvc.Models.TransactionEditModel editModel = new Models.TransactionEditModel();

            List<TransactionType> transactionTypeList = proxy.GetTransactionTypes();
            List<SelectListItem> transactionTypeItems = transactionTypeList.Select(x => GetTransactionTypeItem(x)).ToList();
            editModel.TransactionTypeSelectList = new SelectList(transactionTypeItems, "Value", "Text", 1);

            List<Category> categoryList = proxy.GetCategories();
            List<SelectListItem> categoryItems = categoryList.Select(x => GetCategoryItem(x)).ToList();
            editModel.CategorySelectList = new SelectList(categoryItems, "Value", "Text", 1);

            var commonModel = proxy.GetTransaction(transactionId);

            editModel.TransactionId = commonModel.TransactionId;
            editModel.TransactionTypeId = commonModel.TransactionTypeId;
            editModel.CategoryId = commonModel.CategoryId;
            editModel.Amount = commonModel.Amount;
            editModel.ShortDescription = commonModel.ShortDescription;
            editModel.Notes = commonModel.Notes;

            return View(editModel);
        }

        [HttpPost]
        public ActionResult Edit(Rp3.Test.Mvc.Models.TransactionEditModel editModel)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            int accountId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AccountId"]);

            List<TransactionType> transactionTypeList = proxy.GetTransactionTypes();
            List<SelectListItem> transactionTypeItems = transactionTypeList.Select(x => GetTransactionTypeItem(x)).ToList();
            editModel.TransactionTypeSelectList = new SelectList(transactionTypeItems, "Value", "Text", 1);

            List<Category> categoryList = proxy.GetCategories();
            List<SelectListItem> categoryItems = categoryList.Select(x => GetCategoryItem(x)).ToList();
            editModel.CategorySelectList = new SelectList(categoryItems, "Value", "Text", 1);

            if (editModel.Amount <= 0)
            {
                ModelState.AddModelError("Amount", "El monto debe ser mayor a cero");
            }

            if (!ModelState.IsValid)
            {
                return View(editModel);
            }

            Rp3.Test.Common.Models.Transaction commonModel = new Common.Models.Transaction();

            commonModel.TransactionId = editModel.TransactionId;
            commonModel.TransactionTypeId = editModel.TransactionTypeId;
            commonModel.CategoryId = editModel.CategoryId;
            commonModel.AccountId = accountId;
            commonModel.Amount = editModel.Amount;
            commonModel.ShortDescription = editModel.ShortDescription;
            commonModel.Notes = editModel.Notes;

            bool respondeOk = proxy.UpdateTransaction(commonModel);

            if (respondeOk)
                return RedirectToAction("Index");
            else
            {
                return View(editModel);
            }
        }

        public ActionResult Balance()
        {
            Proxies.Proxy proxy = new Proxies.Proxy();

            int accountId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AccountId"]);
            var data = proxy.GetTransactionsBalance(accountId, DateTime.Now.AddDays(-30).ToString(), DateTime.Now.ToString());

            List<Rp3.Test.Mvc.Models.TransactionViewModel> model = new List<Models.TransactionViewModel>();

            foreach (var item in data)
            {
                model.Add(new Models.TransactionViewModel()
                {
                    Amount = item.Amount,
                    CategoryName = item.CategoryName,
                    TransactionTypeId = item.TransactionTypeId
                });
            }

            return View(model);
        }

        #region Private Functions

        public SelectListItem GetTransactionTypeItem(TransactionType transactionType)
        {
            SelectListItem item = new SelectListItem()
            {
                Text = transactionType.Name,
                Value = transactionType.TransactionTypeId.ToString()
            };
            return item;
        }

        public SelectListItem GetCategoryItem(Category category)
        {
            SelectListItem item = new SelectListItem()
            {
                Text = category.Name,
                Value = category.CategoryId.ToString()
            };
            return item;
        }

        #endregion

    }
}
