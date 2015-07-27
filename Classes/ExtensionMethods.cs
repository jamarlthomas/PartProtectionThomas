using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ExtensionMethods
{
    public static class StringValidationMethods
    {
        public static bool isNullOrEmpty(this String str)
        {
           return (str == null || str == string.Empty);
        }
    
    }

}
