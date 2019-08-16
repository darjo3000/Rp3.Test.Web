using Rp3.Test.Data.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rp3.Test.Data.Repositories
{
    public class CategoryRepository: Repository<Category>
    {
        public CategoryRepository(DbContext context) : base(context)
        {
        }        

    }
}
