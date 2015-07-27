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
    public class DMSDataController : ApiController
    {

         IDMSDataService detailsDataService;

        public DMSDataController(IDMSDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // GET: api/user_details/1
        [Route("api/dms_data/{seller_id}")]
        public dtoDMSData GetDMS(int seller_id)
        {
            DMSBusinessService detailsApplicationService = new DMSBusinessService(detailsDataService);

            dtoDMSData details = detailsApplicationService.GetDMS(seller_id);

            return details;
        }

    }
}
