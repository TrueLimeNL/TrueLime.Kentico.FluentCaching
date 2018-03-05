using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using CMS.Membership;

namespace $rootnamespace$.FluentCaching
{
    /// <summary>
    /// Extensions for fluent caching configuration
    /// </summary>
    public static class FluentCacheExtensions
    {
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
            if (dependencies == null || dependencies.Length == 0)
                return settings;

            settings.DependencyKeys.AddRange(dependencies.Where(d => !string.IsNullOrEmpty(d)));
            return settings;
        }

        public static CacheThis WithParameter(this CacheThis settings, object value)
        {
            if (value == null) throw new ArgumentNullException(nameof(value));

            settings.CacheKeyParts.Add(string.Format(CultureInfo.InvariantCulture, "{0}", value));
            return settings;
        }

        public static CacheThis DependsOnParentPage(this CacheThis settings, string parentAliasPath)
        {
            if (parentAliasPath == null) throw new ArgumentNullException(nameof(parentAliasPath));

            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForChildPages(parentAliasPath, settings.Sitename));
            return settings;
        }

        public static CacheThis DependsOnPageType(this CacheThis settings, string pageType)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPageType(pageType, settings.Sitename));
            return settings;
        }

        public static CacheThis DependsOnObjectType(this CacheThis settings, string objectType)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForObjectType(objectType));
            return settings;
        }
		
		public static CacheThis DependsOnObjectType(this CacheThis settings, string objectType, int id)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForObjectType(objectType, id));
            return settings;
        }

        public static CacheThis DependsOnNode(this CacheThis settings, int nodeId)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPage(nodeId));
            return settings;
        }

        public static CacheThis DependsOnNodes(this CacheThis settings, IEnumerable<int> nodeIds)
        {
            foreach (var nodeId in nodeIds)
            {
                settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPage(nodeId));
            }
            
            return settings;
        }

        public static CacheThis DependsOnNodes(this CacheThis settings, IEnumerable<Guid> nodeGuids)
        {
            foreach (var nodeGuid in nodeGuids)
            {
                settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPage(nodeGuid));
            }
            
            return settings;
        }

        public static CacheThis DependsOnNode(this CacheThis settings, Guid nodeGuid)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPage(nodeGuid, settings.Sitename));
            return settings;
        }

        public static CacheThis DependsOnNode(this CacheThis settings, string nodeAliasPath)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForPage(nodeAliasPath, settings.Sitename));
            return settings;
        }

        public static CacheThis DependsOnDocument(this CacheThis settings, int documentId)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForDocument(documentId));
            return settings;
        }

        public static CacheThis DependsOnDocuments(this CacheThis settings, IEnumerable<int> documentIds)
        {
            foreach (var documentId in documentIds)
            {
                settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForDocument(documentId));
            }
            return settings;
        }

        public static CacheThis DependsOnRelationship(this CacheThis settings, int nodeId)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForRelationship(nodeId));
            return settings;
        }

        public static CacheThis DependsOnRelationship(this CacheThis settings, IEnumerable<int> nodeIds)
        {
            foreach (var nodeId in nodeIds)
            {
                settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForRelationship(nodeId));
            }
            return settings;
        }

        public static CacheThis DependsOnMediaFile(this CacheThis settings, Guid guid)
        {
            settings.DependencyKeys.Add(FluentCacheHelper.GetDependencyCacheKeyForMediaFile(guid));
            return settings;
        }

        public static CacheThis PerUser(this CacheThis settings)
        {
            settings.CacheKeyParts.Add(MembershipContext.AuthenticatedUser.UserID.ToString());
            return settings;
        }
    }
}
