using System;
using System.Collections.Generic;
using System.Globalization;

namespace $rootnamespace$.FluentCaching
{
    /// <summary>
    /// Extensions for fluent caching configuration
    /// </summary>
    public static class FluentCacheExtensions
    {
        public static CacheThis DependsOnObject(this CacheThis settings, string objectType)
        {
            settings.DependencyKeys.Add(GetDependencyCacheKeyForObject(objectType));
            return settings;
        }

        public static CacheThis ForMinutes(this CacheThis settings, int minutes)
        {
            settings.CacheMinutes = minutes;
            return settings;
        }

        public static CacheThis WithParameter(this CacheThis settings, string key, object value)
        {
            if (string.IsNullOrEmpty(key)) throw new ArgumentException("Value cannot be null or empty.", nameof(key));
            settings.CacheKeyParts.Add(
                value != null
                    ? FormattableString.Invariant($"{key}={value}")
                    : key
                );

            return settings;
        }

        public static CacheThis WithDependencies(this CacheThis settings, string[] dependencies)
        {
            settings.DependencyKeys.AddRange(dependencies);
            return settings;
        }

        public static CacheThis WithParameter(this CacheThis settings, object value)
        {
            if (value == null) throw new ArgumentNullException(nameof(value));

            settings.CacheKeyParts.Add(string.Format(CultureInfo.InvariantCulture, "{0}", value));
            return settings;
        }

        public static CacheThis DependsOnPage(this CacheThis settings, string objectType)
        {
            settings.DependencyKeys.Add(GetDependencyCacheKeyForPage(settings.Sitename, objectType));
            return settings;
        }

        public static string GetDependencyCacheKeyForPage(string sitename, string kenticoClassName)
        {
            return FormattableString.Invariant($"nodes|{sitename}|{kenticoClassName}|all");
        }

        public static string GetDependencyCacheKeyForChildPages(this CacheThis settings, string sitename, string nodeAliasPath)
        {
            return FormattableString.Invariant($"node|{sitename}|{nodeAliasPath}|childnodes");
        }

        public static string GetDependencyCacheKeyForPage(string kenticoClassName, int nodeId)
        {
            return FormattableString.Invariant($"nodeid|{nodeId}");
        }

        public static string GetDependencyCacheKeyForPage(string sitename, string kenticoClassName, Guid nodeGuid)
        {
            return FormattableString.Invariant($"nodeguid|{sitename}|{nodeGuid}");
        }

        public static string GetDependencyCacheKeyForObject(string kenticoClassName)
        {
            return FormattableString.Invariant($"{kenticoClassName}|all");
        }

        public static string GetDependencyCacheKeyForMediaFile(Guid guid)
        {
            return FormattableString.Invariant($"mediafile|{guid:D}");
        }
    }
}
