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
    public class InvoicesController : ApiController
    {
        IInvoiceDataService detailsDataService;

        public InvoicesController(IInvoiceDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // GET: api/user_details/1
        [Route("api/invoices/{invoice_id}")]
        public dtoInvoices GetInvoices(int invoice_id)
        
        {
            InvoicesBusinessService detailsApplicationService = new InvoicesBusinessService(detailsDataService);

            dtoInvoices details = detailsApplicationService.GetInvoices(invoice_id);

            return details;
        }

        // CreateUpdateInvoice
        [Route("api/createupdate_invoice/save")]
        [HttpPost]
        public dtoInvoices CreateInvoice([FromBody]dtoInvoices invoice)
        {
            InvoicesBusinessService CustomerApplicationService = new InvoicesBusinessService(detailsDataService);

            dtoInvoices details = CustomerApplicationService.CreateUpdateInvoice(invoice);

            return details;
        }
    }
}

