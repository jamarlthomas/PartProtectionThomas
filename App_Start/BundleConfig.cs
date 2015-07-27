using System.Web;
using System.Web.Optimization;

namespace PartProtection
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-1.11.3.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/app").Include(
                        "~/Scripts/app.js",
                        "~/Scripts/knockout-3.3.0.js"));

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-2.8.3.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/CSS/css").Include(
                      //"~/CSS/bootstrap.css",
                      //"~/CSS/site.css",
                      "~/CSS/normalize.css",
                      "~/CSS/font-awesome.min.css",
                      "~/CSS/main.css",
                      "~/CSS/style.css"));
        }
    }
}
