using System;
using CMS.Helpers;
using CMS.SiteProvider;

namespace $rootnamespace$.FluentCaching
{
    /// <summary>
    /// Provides caching for methods that return a single content item or a collection of content items. A minimum set of cache dependencies is also specified 
    /// so when a content item changes the cached result is invalidated.
    /// </summary>
    public static class FluentCacheHelper
    {

        /// <summary>
        /// Returns the cached result for the specified method invocation, if possible; otherwise proceeds with the invocation and caches the result.
        /// Only results of methods starting with 'Get' are affected.
        /// </summary>
        public static TResult GetCachedResult<TResult>(Func<TResult> provideData, double cacheMinutes, string cacheKey, bool cacheEnabled = true, params string[] dependencyCacheKey)
        {
            if (!cacheEnabled)
            {
                System.Diagnostics.Debugger.Log(1, "Cache", "Cache miss: disabled " + cacheKey + "\r\n");
                return provideData();
            }

            var cacheSettings = CreateCacheSettings(cacheMinutes, cacheKey, dependencyCacheKey);

            return CacheHelper.Cache(() =>
            {
                System.Diagnostics.Debugger.Log(1, "Cache", "Cache miss " + cacheKey + "\r\n");
                return provideData();
            }, cacheSettings);
        }

        public static TResult GetCachedResult<TResult>(Func<TResult> provideData, CacheThis cacheBuilder, bool cacheEnabled = true)
        {
            if (!cacheEnabled)
            {
                System.Diagnostics.Debugger.Log(1, "Cache", "Cache miss: disabled " + cacheBuilder.CacheKey + "\r\n");
                return provideData();
            }

            var cacheSettings = cacheBuilder.Create();
            return CacheHelper.Cache(() =>
            {
                System.Diagnostics.Debugger.Log(1, "Cache", "Cache miss " + cacheBuilder.CacheKey + "\r\n");
                return provideData();
            }, cacheSettings);
        }

        private static CacheSettings CreateCacheSettings(double cacheMinutes, string cacheKey, string[] dependencyCacheKey)
        {
            return new CacheSettings(cacheMinutes, cacheKey)
            {
                GetCacheDependency = () => CacheHelper.GetCacheDependency(dependencyCacheKey)
            };
        }

        public static string GetDependencyCacheKeyForPageType(string kenticoClassName, string siteName = null)
        {
            return FormattableString.Invariant($"nodes|{siteName ?? SiteContext.CurrentSiteName}|{kenticoClassName}|all");
        }

        public static string GetDependencyCacheKeyForObjectType(string kenticoClassName, string siteName = null)
        {
            return FormattableString.Invariant($"{kenticoClassName}|all");
        }
		
		public static string GetDependencyCacheKeyForObjectType(string kenticoClassName, int id)
        {
            return FormattableString.Invariant($"{kenticoClassName}|byid|{id}");
        }

        public static string GetDependencyCacheKeyForChildPages(string nodeAliasPath, string siteName = null)
        {
            return FormattableString.Invariant($"node|{siteName ?? SiteContext.CurrentSiteName}|{nodeAliasPath}|childnodes");
        }

        public static string GetDependencyCacheKeyForPage(int nodeId)
        {
            return FormattableString.Invariant($"nodeid|{nodeId}");
        }

        public static string GetDependencyCacheKeyForDocument(int documentId)
        {
            return FormattableString.Invariant($"documentid|{documentId}");
        }

        public static string GetDependencyCacheKeyForRelationship(int nodeId)
        {
            return FormattableString.Invariant($"nodeid|{nodeId}|relationships");
        }

        public static string GetDependencyCacheKeyForPage(Guid nodeGuid, string siteName = null)
        {
            return FormattableString.Invariant($"nodeguid|{siteName ?? SiteContext.CurrentSiteName}|{nodeGuid}");
        }

        public static string GetDependencyCacheKeyForPage(string nodeAliasPath, string siteName = null)
        {
            return FormattableString.Invariant($"node|{siteName ?? SiteContext.CurrentSiteName}|{nodeAliasPath}");
        }

        public static string GetDependencyCacheKeyForMediaFile(Guid guid)
        {
            return FormattableString.Invariant($"mediafile|{guid:D}");
        }
    }
}
