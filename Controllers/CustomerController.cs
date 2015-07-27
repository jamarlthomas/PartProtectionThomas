using PPDataServiceInterface;
using PPModels.DataTransferObjects;
using PPBaseBusiness;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ExtensionMethods;


namespace PartProtection.Controllers
{
    public class CustomerController : ApiController
    {

        ICustomerDataService detailsDataService;

        public CustomerController(ICustomerDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // GET: api/user_details/1
        [Route("api/customer/{customer_id}")]
        public dtoCustomer GetCustomer(int customer_id)
        {
            CustomerBusinessService detailsApplicationService = new CustomerBusinessService(detailsDataService);

            dtoCustomer details = detailsApplicationService.GetCustomer(customer_id);
            
            return details;
        }

        // GET: api/user_details/1
        [Route("api/customer/GetCustomerbyOrderID/{warranty_order_id}")]
        public dtoCustomer GetCustomerbyOrderID(int warranty_order_id)
        {
            CustomerBusinessService detailsApplicationService = new CustomerBusinessService(detailsDataService);

            dtoCustomer details = detailsApplicationService.GetCustomerbyOrderID(warranty_order_id);

            return details;
        }

        // Update Customer
        [Route("api/update_customer/save")]
        [HttpPost]
        public dtoCustomer UpdateCustomer([FromBody]dtoCustomer customer)
        {
            CustomerBusinessService CustomerApplicationService = new CustomerBusinessService(detailsDataService);

            dtoCustomer details = CustomerApplicationService.CreateUpdateCustomer(customer);

            return details;
        }


        // POST: api/member/save
        [Route("api/create_customer/save")]
        [HttpPost]
        public dtoCustomer CreateCustomer([FromBody]dtoCustomer customer)
        {
            CustomerBusinessService CustomerApplicationService = new CustomerBusinessService(detailsDataService);

            dtoCustomer details = CustomerApplicationService.CreateUpdateCustomer(customer);

            return details;
        }
    
    }
}
