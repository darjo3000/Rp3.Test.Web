using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Repositories
{
    public class Repository<TEntity> where TEntity : class
    {
        protected DbSet<TEntity> dbSet;
        protected System.Data.Entity.DbContext context;

        public Repository(DbContext context)
        {
            this.context = context;
            this.dbSet = context.Set<TEntity>();
        }

        public Database DataBase
        {
            get
            {
                return context.Database;
            }
        }

        public void Attach(TEntity entity)
        {
            dbSet.Attach(entity);
        }

        public void Detach(TEntity entity)
        {
            context.Entry<TEntity>(entity).State = EntityState.Detached;
        }

        public void Load(TEntity entity, string navigationProperty)
        {
            this.context.Entry<TEntity>(entity).Collection(navigationProperty).Load();
        }

        public IQueryable<TEntity> AsQueryable()
        {
            return dbSet;
        }

        public virtual T GetMaxValue<T>(Expression<Func<TEntity, T>> maxExpression, T defaultValue,
            Expression<Func<TEntity, bool>> filter = null)
        {
            IQueryable<TEntity> query = dbSet;

            if (filter != null)
            {
                query = query.Where(filter);
            }
            try
            {
                return query.Max(maxExpression);
            }
            catch
            {
                return defaultValue;
            }
        }

        public virtual IQueryable<TEntity> GetQueryable(
           Expression<Func<TEntity, bool>> filter = null,
           Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null,
           string includeProperties = "")
        {
            IQueryable<TEntity> query = dbSet;

            if (filter != null)
            {
                query = query.Where(filter);
            }

            if (!string.IsNullOrWhiteSpace(includeProperties))
            {
                foreach (var includeProperty in includeProperties.Split
                    (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    query = query.Include(includeProperty);
                }
            }

            if (orderBy != null)
            {
                return orderBy(query);
            }
            else
            {

                return query;
            }
        }

        public virtual IEnumerable<TEntity> Get(
            Expression<Func<TEntity, bool>> filter = null,
            Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null,
            string includeProperties = "")
        {
            return GetQueryable(filter, orderBy, includeProperties).ToList();
        }

        public virtual TEntity GetSingleOrDefault(
            Expression<Func<TEntity, bool>> filter,
            string includeProperties = "")
        {
            return GetQueryable(filter, includeProperties: includeProperties).SingleOrDefault();
        }

        public virtual bool Exists(Expression<Func<TEntity, bool>> expression = null)
        {
            return dbSet.Any(expression);
        }

        public virtual TEntity GetByID(object id)
        {
            return dbSet.Find(id);
        }

        public virtual void Insert(TEntity entity)
        {
            dbSet.Add(entity);
        }
        
        public virtual void Delete(object id)
        {
            TEntity entityToDelete = dbSet.Find(id);
            Delete(entityToDelete);
        }

        public virtual void Delete(TEntity entityToDelete)
        {
            if (context.Entry(entityToDelete).State == EntityState.Detached)
            {
                dbSet.Attach(entityToDelete);
            }
            dbSet.Remove(entityToDelete);
        }
        
        public virtual void Update(TEntity entityToUpdate)
        {
            dbSet.Attach(entityToUpdate);

            context.Entry(entityToUpdate).State = EntityState.Modified;
        }

      
        public virtual IEnumerable<TEntity> GetWithRawSql(string query, params object[] parameters)
        {
            return dbSet.SqlQuery(query, parameters).ToList();
        }

    }
}
