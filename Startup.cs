using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(PartProtection.Startup))]
namespace PartProtection
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
