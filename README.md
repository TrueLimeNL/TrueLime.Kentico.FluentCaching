# TrueLime.Kentico.FluentCaching
Fluent API for caching data with Kentico Data API

## Introduction
This library was born out of frustration about manually formatting cache keys and cache dependency keys for Kentico.
When you're writing a bunch of data access code, for example for a Kentico MVC application, it becomes very tedious and error prone to hand code all the cache dependency keys.

We'd end up with these complex data access methods and then a blurb cache configuration code that looks cryptic at best.

The Kentico CacheHelper offers a more semantic interface on top of the Kentico Cache helpers.
Looking the blurb of cache configuration is still there, but it's much easier to write, read and maintain.

## Example - generic data access
The default implementation takes culture, site name and domain name of the current request from the (Kentico) context.

```csharp
  FluentCacheHelper.GetCachedResult(() =>
        // Data access goes here
            DocumentHelper.GetDocuments<NewsItem>()
                .LatestVersion(false)
                .Published(true)
                .OnCurrentSite()
                .Culture(cultureName)
                .OrderByIfNullColumn("DocumentPublishFrom", "DocumentCreatedWhen", OrderDirection.Descending)
                .Page(pageCount, pageSize);
                .ToArray(),
        
        // Cache configuration goes here
            CacheThis.As("latestnews")
                .ForMinutes(10)
                .WithParameter("count", pageCount)
                .WithParameter("size", pageSize)
                .DependsOnPageType(NewsItem.CLASS_NAME));
```

## Example - MVC repository style 
In an MVC repository, you'd probably use the pattern set out in the Kentico MVC sample application.
This includes support for setting the culture and site name per repository, as well as enabling support for previewing content.

On the base repository, you'd have something like this:

```csharp
public abstract class CachingRepositoryBase {
    public CachingRepositoryBase( string siteName, string cultureName, bool enableCaching ){

    }

    public CacheThis CacheAs(string key)
    {
        return new CacheThis(_cultureName, _siteName, key);
    }

    protected TResult GetCachedResult<TResult>(Func<TResult> provideData, CacheThis settings)
    {
         return FluentCacheHelper.GetCachedResult(provideData, settings, _enableCaching);
    }
}
```

Then in the repository implementation you can do this:

```csharp
public class ContentPageRepository : CachingRepositoryBase, IContentPageRepository
{

    // .... constructor etc here ...

    public ContentPage GetContentPage(int nodeId)
    {
        return GetCachedResult(() =>
        // Data access goes here
        DocumentHelper.GetDocuments<ContentPage>()
            .ByNodeId(nodeId)
            .AddSpecificColumns()
            .AddDefaultClauses(_latestVersionEnabled, _cultureName)
            .WhereEqualsOrNull(nameof(CMS.DocumentEngine.TreeNode.NodeLinkedNodeID), 0),
        
        // Cache configuration goes here
        CacheAs(ContentPage.CLASS_NAME)
                    .ForMinutes(5)
                    .WithParameter("nodeId", nodeId)
                    .DependsOnNode(nodeId)
            );
    }
}
```

