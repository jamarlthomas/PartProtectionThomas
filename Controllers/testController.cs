using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PartProtection.Models.DataTransferObjects;

namespace PartProtection.Controllers
{
    public class testController : ApiController
    {
        public PartProtection_QAEntities context = new PartProtection_QAEntities();

        // GET: api/test
        [Route("api/test")]
        public IEnumerable<dto_test> Get()
        {

            var query = context.T_WarrantyOrders.ToList();

            var customers = from l in query
                            select new dto_test 
                            {
                                warrantyOrderID = l.warrantyOrderID,
                                sellerID = l.sellerID,
                                loginid = l.loginid,
                                //VIN=l.VIN,
                                make=l.make,
                                CustomerFirstName=l.CustomerFirstName
                            };

            return customers.ToList();
        }
    }
}
