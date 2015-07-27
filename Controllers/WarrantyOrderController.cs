using PPDataServiceInterface;
using PPModels.DataTransferObjects;
using PPBaseBusiness;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace PartProtection.Controllers
{
    public class WarrantyOrderController : ApiController
    {
        IWarrantyDetailsDataService detailsDataService;

        public WarrantyOrderController(IWarrantyDetailsDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // Get Orders
        [Route("api/warranty_order/{warranty_order_id}")]
        public dtoWarrantyOrder GetOrder(int warranty_order_id)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            dtoWarrantyOrder details = detailsApplicationService.GetOrder(warranty_order_id);

            return details;
        }

        // CreateUpdateOrders
        [Route("api/createupdate_order/save")]
        [HttpPost]
        public dtoWarrantyOrder CreateOrder([FromBody]dtoWarrantyOrder orders)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            dtoWarrantyOrder newDetails = detailsApplicationService.CreateUpdateOrder(orders);

            return newDetails;
        }

        // Get Order Details
        [Route("api/warranty_order_details/{order_detail_id}")]
        public dtoWarrantyOrderDetails GetDetails(int order_detail_id)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            dtoWarrantyOrderDetails details = detailsApplicationService.GetDetails(order_detail_id);

            return details;
        }

        // Get Order Details by Warranty Order ID
        [Route("api/warranty_order_details/GetDetailsbyOrderID/{warranty_order_id}")]
        public List<dtoWarrantyOrderDetails> GetDetailsbyOrderID(int warranty_order_id)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            List<dtoWarrantyOrderDetails> details = detailsApplicationService.GetDetailsbyOrderID(warranty_order_id);

            return details;
        }

        // CreateUpdateDeetails
        [Route("api/createupdate_details/save")]
        [HttpPost]
        public dtoWarrantyOrderDetails CreateDetails([FromBody]dtoWarrantyOrderDetails details)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            dtoWarrantyOrderDetails newDetails = detailsApplicationService.CreateUpdateDetails(details);

            return newDetails;
        }

        // Delete Order Details by Order Detail ID
        [Route("api/delete_details/{order_detail_id}")]
        public bool DeleteDetails(int order_detail_id)
        {
            WarrantyOrderBusinessService detailsApplicationService = new WarrantyOrderBusinessService(detailsDataService);

            bool details = detailsApplicationService.DeleteDetails(order_detail_id);

            return details;
        }

    }
}
