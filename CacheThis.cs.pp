using System.Collections.Generic;
using CMS.Helpers;

namespace $rootnamespace$.FluentCaching
{
    /// <summary>
    /// Root for fluent caching configuration.
    /// </summary>
    public class CacheThis
    {
        private CacheThis()
        {
        }

        public CacheThis(string culture, string sitename, string key)
        {
            Culture = culture;
            Sitename = sitename;
            CacheKeyParts.Add(sitename);
            CacheKeyParts.Add(culture);
            CacheKeyParts.Add(key);
        }

        public static CacheThis As(string key)
        {
            return new CacheThis()
            {
                CacheKeyParts =
                {
                    CMS.SiteProvider.SiteContext.CurrentSiteName,
                    RequestContext.CurrentDomain,
                    CMS.Localization.LocalizationContext.PreferredCultureCode,
                    key
                }
            };
        }

        public string Culture { get; }
        public string Sitename { get; }
        public double CacheMinutes { get; set; } = 10;

        public string CacheKey => string.Join("|", CacheKeyParts.ToArray());

        public List<string> DependencyKeys { get; } = new List<string>();
        public List<string> CacheKeyParts { get; } = new List<string>();

        public CacheSettings Create()
        {
            return new CacheSettings(CacheMinutes, CacheKey)
            {
                GetCacheDependency = () => CacheHelper.GetCacheDependency(DependencyKeys)
            };
        }
    }
}
