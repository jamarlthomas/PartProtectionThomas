using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PartProtection.Models.DataTransferObjects;

namespace PartProtection.Controllers
{
    public class testController2 : ApiController
    {
        public PartProtection_QAEntities db = new PartProtection_QAEntities();

        // GET: api/test2
        [Route("api/test2")]
        public IEnumerable<dto_test2> Get()
        {

            //string test_make = "Dodge";
            int testID = 84;

            var query = db.T_WarrantyOrders.Where(w => w.T_SalesUsers.LoginId == testID).ToList();



            //var query = (from a in db.T_WarrantyOrders join b in db.T_SalesUsers
            //                 on a.loginid equals b.LoginId
            //             where a.loginid == testID
            //             select new { a.warrantyOrderID, a.sellerID, a.loginid, a.VIN, a.make, a.CustomerFirstName, b.PasswordHint, b.Email }).ToList();

            var customers = from l in query
                            select new dto_test2 
                            {
                                warrantyOrderID = l.warrantyOrderID,
                                sellerID = l.sellerID,
                                loginid = l.loginid,
                                VIN=l.VIN,
                                make=l.make,
                                CustomerFirstName=l.CustomerFirstName,
                                PasswordHint=l.T_SalesUsers.PasswordHint,
                                Email=l.T_SalesUsers.Email
                            };

            return customers.ToList();
        }


        //// this is for passing a variable from the query string, via a form from the website.
        //// GET: api/test2/1
        //[Route("api/test2/{sellerid}")]
        //public IEnumerable<dto_test2> Get(int sellerid)
        //{

        //    //string test_make = "Dodge";
        //    int testID = 84;

        //    var query = db.T_WarrantyOrders.Where(w => w.T_SalesUsers.LoginId == testID).ToList();



        //    //var query = (from a in db.T_WarrantyOrders join b in db.T_SalesUsers
        //    //                 on a.loginid equals b.LoginId
        //    //             where a.loginid == testID
        //    //             select new { a.warrantyOrderID, a.sellerID, a.loginid, a.VIN, a.make, a.CustomerFirstName, b.PasswordHint, b.Email }).ToList();

        //    var customers = from l in query
        //                    select new dto_test2
        //                    {
        //                        warrantyOrderID = l.warrantyOrderID,
        //                        sellerID = l.sellerID,
        //                        loginid = l.loginid,
        //                        VIN = l.VIN,
        //                        make = l.make,
        //                        CustomerFirstName = l.CustomerFirstName,
        //                        PasswordHint = l.T_SalesUsers.PasswordHint,
        //                        Email = l.T_SalesUsers.Email
        //                    };

        //    return customers.ToList();
        //}

    }
}
