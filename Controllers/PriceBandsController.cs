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
    public class PriceBandsController : ApiController
    {
        IPriceBands sellerDataService;

        public PriceBandsController(IPriceBands dataService)
        {
            sellerDataService = dataService;           
        }

        // GET: api/seller/1
        [Route("api/price_bands/{price_band_id}")]
        public dtoPriceBands GetPriceBands(int price_band_id)
        {
            PriceBandsBusinessService sellerApplicationService = new PriceBandsBusinessService(sellerDataService);

            dtoPriceBands customer = sellerApplicationService.GetPriceBands(price_band_id);

            return customer;
        }

        // CreateUpdatePriceBands
        [Route("api/createupdate_price_bands/save")]
        [HttpPost]
        public dtoPriceBands CreatePriceBands([FromBody]dtoPriceBands priceband)
        {
            PriceBandsBusinessService CustomerApplicationService = new PriceBandsBusinessService(sellerDataService);

            dtoPriceBands details = CustomerApplicationService.CreateUpdatePriceBands(priceband);

            return details;
        }

    }
}
