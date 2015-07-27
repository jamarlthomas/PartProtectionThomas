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
    public class UserDetailsController : ApiController
    {

        IUserDetailsDataService detailsDataService;

        public UserDetailsController(IUserDetailsDataService dataService)
        {
            detailsDataService = dataService;           
        }

        // GET: api/user_details/1
        [Route("api/user_details/{user_id}")]
        public dtoUserDetails GetUser(int user_id)
        {
            UserDetailBusinessService detailsApplicationService = new UserDetailBusinessService(detailsDataService);

            dtoUserDetails details = detailsApplicationService.GetUser(user_id);

            return details;
        }

        // POST: api/user_details/
        [Route("api/update_user/save")]
        [HttpPost]
        public dtoUserDetails UpdateUser([FromBody]dtoUserDetails user)
        {
            UserDetailBusinessService detailsApplicationService = new UserDetailBusinessService(detailsDataService);

            dtoUserDetails details = detailsApplicationService.UpdateUser(user);

            return details;
        }

    }
}
