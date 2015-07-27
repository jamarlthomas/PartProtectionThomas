using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PPBaseBusiness;
using PPDataServiceInterface;
using PPModels.DataTransferObjects;

namespace PartProtection.Controllers
{
    public class SellerController : ApiController
    {
        ISellerDataService sellerDataService;

        public SellerController(ISellerDataService dataService)
        {
            sellerDataService = dataService;           
        }

        // GET: api/seller/1
        [Route("api/seller/{seller_id}")]
        public dtoSeller GetSeller(int seller_id)
        {
            SellerBusinessService sellerApplicationService = new SellerBusinessService(sellerDataService);

            dtoSeller customer = sellerApplicationService.GetSeller(seller_id);

            return customer;
        }

        // GET: api/seller_payment/1
        [Route("api/seller_payment/{payment_id}")]
        public dtoSellerPayment GetSellerPayment(int payment_id)
        {
            SellerBusinessService sellerApplicationService = new SellerBusinessService(sellerDataService);

            dtoSellerPayment sellerPay = sellerApplicationService.GetSellerPayment(payment_id);

            return sellerPay;
        }

        // CreateUpdateSeller
        [Route("api/createupdate_sellers/save")]
        [HttpPost]
        public dtoSeller CreateSeller([FromBody]dtoSeller sellers)
        {
            SellerBusinessService sellerApplicationService = new SellerBusinessService(sellerDataService);

            dtoSeller details = sellerApplicationService.CreateUpdateSeller(sellers);

            return details;
        }

        // CreateUpdateSeller
        [Route("api/createupdate_sellerpayment/save")]
        [HttpPost]
        public dtoSellerPayment CreateUpdatePayment([FromBody]dtoSellerPayment sellerpayment)
        {
            SellerBusinessService sellerApplicationService = new SellerBusinessService(sellerDataService);

            dtoSellerPayment details = sellerApplicationService.CreateUpdatePayment(sellerpayment);

            return details;
        }
    }
}
