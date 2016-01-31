using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MemeCollector.Startup))]
namespace MemeCollector
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
