using Newtonsoft.Json;
using Rp3.Test.Common.Models;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;


namespace Rp3.Test.Proxies
{
    public class Proxy : BaseProxy
    {
        private const string UriGetCategory = "api/categoryData/get?active={0}";
        private const string UriGetCategoryById = "api/categoryData/getById?categoryId={0}";
        private const string UriInsertCategory = "api/categoryData/insert";
        private const string UriUpdateCategory = "api/categoryData/update";

        private const string UriGetTransactionType = "api/transactionTypeData/get";

        private const string UriGetTransactions = "api/transactionData/get?accountId={0}";
        private const string UriGetTransactionsBalance = "api/transactionData/getBalance?accountId={0}";
        private const string UriGetTransactionById = "api/transactionData/getById?transactionId={0}";
        private const string UriInsertTransactions = "api/transactionData/insert";
        private const string UriUpdateTransactions = "api/transactionData/update";

        private const string UriGetAccountById = "api/accountData/getById?accountId={0}";

        /// <summary>
        /// Obtiene el Listado de Tipos de Transacción
        /// </summary>
        /// <returns></returns>
        public List<TransactionType> GetTransactionTypes()
        {
            return HttpGet<List<TransactionType>>(UriGetTransactionType);
        }

        #region Category Services

        /// <summary>
        /// Obtiene el Listado de Categorías
        /// </summary>
        /// <param name="active">especifica si la consulta es sobre categorías activas o Inactivas</param>
        /// <returns></returns>
        public List<Category> GetCategories(bool? active = null)
        {
            return HttpGet<List<Category>>(UriGetCategory, active);
        }

        /// <summary>
        /// Obtiene una Categoría por Id
        /// </summary>
        /// <param name="categoryId">Id de la Categoría</param>
        /// <returns></returns>
        public Category GetCategory(int categoryId)
        {
            return HttpGet<Category>(UriGetCategoryById, categoryId);
        }

        /// <summary>
        /// Método para Insertar Categorías
        /// </summary>
        /// <param name="category"></param>
        /// <returns></returns>
        public bool InsertCategory(Rp3.Test.Common.Models.Category category)
        {
            return HttpPostAsJson<bool>(UriInsertCategory, category);
        }

        public bool UpdateCategory(Rp3.Test.Common.Models.Category category)
        {
            return HttpPostAsJson<bool>(UriUpdateCategory, category);
        }

        #endregion

        #region Transaction Service

        /// <summary>
        /// Obtiene el Listado de Transacciones
        /// </summary>
        /// <returns></returns>
        public List<TransactionView> GetTransactions(int accountId)
        {
            return HttpGet<List<TransactionView>>(UriGetTransactions, accountId);
        }

        /// <summary>
        /// Obtiene el Listado del Balance de las Transacciones
        /// </summary>
        /// <returns></returns>
        public List<TransactionView> GetTransactionsBalance(int accountId)
        {
            return HttpGet<List<TransactionView>>(UriGetTransactionsBalance, accountId);
        }

        /// <summary>
        /// Obtiene una Transaccion por Id
        /// </summary>
        /// <param name="transactionId">Id de la Transaccion</param>
        /// <returns></returns>
        public Transaction GetTransaction(int transactionId)
        {
            return HttpGet<Transaction>(UriGetTransactionById, transactionId);
        }

        /// <summary>
        /// Método para Insertar Transacciones
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool InsertTransaction(Rp3.Test.Common.Models.Transaction transaction)
        {
            return HttpPostAsJson<bool>(UriInsertTransactions, transaction);
        }

        public bool UpdateTransaction(Rp3.Test.Common.Models.Transaction transaction)
        {
            return HttpPostAsJson<bool>(UriUpdateTransactions, transaction);
        }

        #endregion

        /// <summary>
        /// Obtiene una Cuenta por Id
        /// </summary>
        /// <param name="accountId">Id de la Cuenta</param>
        /// <returns></returns>
        public Account GetAccount(int accountId)
        {
            return HttpGet<Account>(UriGetAccountById, accountId);
        }

    }
}