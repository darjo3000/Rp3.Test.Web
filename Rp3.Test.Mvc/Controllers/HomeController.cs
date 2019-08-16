using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            string accountId = ConfigurationManager.AppSettings["AccountId"];
            System.Web.HttpContext.Current.Session["AccountId"] = accountId;

            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();
            var commonModel = proxy.GetAccount(Convert.ToInt32(accountId));
            System.Web.HttpContext.Current.Session["AccountName"] = commonModel.FullName;

            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}