using PPBaseBusiness;
using PPDataServiceInterface;
using PPModels.DataTransferObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace PartProtection.Controllers
{
    public class ProductsController : ApiController
{
        IProducts sellerDataService;

        public ProductsController(IProducts dataService)
        {
            sellerDataService = dataService;           
        }

        // GET: api/seller/1
        [Route("api/products/{product_des_id}")]
        public dtoProducts GetProducts(int product_des_id)
        {
            ProductsBusinessService sellerApplicationService = new ProductsBusinessService(sellerDataService);

            dtoProducts customer = sellerApplicationService.GetProducts(product_des_id);

            return customer;
        }

    }
}
