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
    public class VehiclesController : ApiController
    {
        IVehiclesDataService detailsDataService;

        public VehiclesController(IVehiclesDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // GET: api/user_details/1
        [Route("api/vehicles/{manufacturer_id}")]
        public dtoVehicles GetVehicles(int manufacturer_id)
        
        {
            VehiclesBusinessService detailsApplicationService = new VehiclesBusinessService(detailsDataService);

            dtoVehicles details = detailsApplicationService.GetVehicles(manufacturer_id);

            return details;
        }
    }
}
