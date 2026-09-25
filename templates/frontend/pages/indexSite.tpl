{include file="frontend/components/header.tpl" spupSiteHeroHeading=true}
<main class="page_index_site">
  <section class="spup-site-hero spup-site-hero-image" aria-labelledby="spup-site-hero-title">
    <div class="spup-site-hero-bg" aria-hidden="true"
      style="background-image: url('{$baseUrl|escape}/plugins/themes/spupLightExplorerTheme/resources/hero-image.png');"></div>
    <div class="spup-site-container spup-site-hero__inner">
      <p class="spup-site-hero__institution">St. Paul University Philippines</p>
      <h1 id="spup-site-hero-title" class="spup-site-hero__title">{$siteTitle|escape}</h1>
      <p class="spup-site-hero__subtitle">{$spupRootOptions.networkSubtitle|escape}</p>
      <div class="spup-site-hero__divider" aria-hidden="true"></div>
      {capture assign="spupSearchUrl"}{url page="search" op="search" router=$smarty.const.ROUTE_PAGE escape=false}{/capture}
      {assign var=spupSearchUrlParameters value=$activeTheme->getSearchFormParameters($spupSearchUrl)}
      <form class="spup-site-hero__search" method="get" action="{$spupSearchUrl|strtok:"?"|escape}" role="search">
        {foreach from=$spupSearchUrlParameters key=paramKey item=paramValue}
          {if $paramKey != 'query' && $paramKey != 'searchJournal'}<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">{/if}
        {/foreach}
        <label class="spup-site-hero__search-label" for="spup-site-search-query">{translate key="plugins.themes.spupLightExplorerTheme.search.allJournals"}</label>
        <div class="spup-site-hero__search-controls">
          <input id="spup-site-search-query" type="search" name="query" placeholder="{translate|escape key="plugins.themes.spupLightExplorerTheme.hero.searchLabel"}" required>
          <button type="submit">{translate key="common.search"}</button>
        </div>
      </form>
      {if $spupRootOptions.showNetworkStats}{include file="frontend/components/rootNetworkStats.tpl"}{/if}
    </div>
  </section>
  <div class="spup-site-container spup-site-content">
    <section id="journals" class="index-site-journals" aria-labelledby="spup-journals-heading">
      <p class="spup-section-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.root.discover"}</p>
      <h2 id="spup-journals-heading">{translate key="plugins.themes.spupLightExplorerTheme.root.exploreJournals"}</h2>
      <div class="spup-section-rule" aria-hidden="true"></div>
      {assign var="spupGalleryJournals" value=$journals}
      {include file="frontend/components/rootJournalGallery.tpl"}
    </section>
    {if $spupRootOptions.showLatestScholarship || $spupNetworkAnnouncements|@count}
    <section class="spup-latest" aria-labelledby="spup-latest-heading">
      <p class="spup-section-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.root.publishing"}</p>
      <h2 id="spup-latest-heading">{if $spupRootOptions.showLatestScholarship}{translate key="plugins.themes.spupLightExplorerTheme.root.latestScholarship"}{else}{translate key="announcement.announcements"}{/if}</h2>
      <div class="spup-section-rule" aria-hidden="true"></div>
      <div class="spup-latest__columns{if !$spupRootOptions.showLatestScholarship || !$spupNetworkAnnouncements|@count} spup-latest__columns--single{/if}">
        {if $spupRootOptions.showLatestScholarship}
        <div class="spup-latest__publications">
          <h3>{translate key="plugins.themes.spupLightExplorerTheme.root.recentPublications"}</h3>
          {if $spupRecentPublications|@count}
            <ol class="spup-editorial-list">
              {foreach from=$spupRecentPublications item=recent}
                <li><article>
                  <h4><a href="{url journal=$recent.journal->getPath() page="article" op="view" path=$recent.submission->getBestId()}">{$recent.publication->getLocalizedFullTitle(null, 'text')|escape} <span class="spup-editorial-arrow" aria-hidden="true">&rarr;</span></a></h4>
                  <p class="spup-editorial-list__meta">{$recent.journal->getLocalizedName()|escape}{if $recent.authors} &middot; {$recent.authors|escape}{/if}{if $recent.datePublished} &middot; <time datetime="{$recent.datePublished|date_format:'Y-m-d'|escape}">{$recent.datePublished|date_format:$dateFormatShort}</time>{/if}</p>
                </article></li>
              {/foreach}
            </ol>
          {else}<p class="spup-empty-state">{translate key="plugins.themes.spupLightExplorerTheme.root.noPublications"}</p>{/if}
        </div>
        {/if}
        {if $spupNetworkAnnouncements|@count}
          <aside class="spup-latest__announcements" aria-labelledby="spup-latest-announcements-heading">
            <h3 id="spup-latest-announcements-heading">{translate key="announcement.announcements"}</h3>
            <ol class="spup-editorial-list">
              {foreach from=$spupNetworkAnnouncements item=announcement}
                <li><article>
                  <time datetime="{$announcement->datePosted|date_format:'Y-m-d'|escape}">{$announcement->datePosted|date_format:$dateFormatShort}</time>
                  <h4><a href="{url page="announcement" op="view" path=$announcement->id}">{$announcement->getLocalizedData('title')|escape} <span class="spup-editorial-arrow" aria-hidden="true">&rarr;</span></a></h4>
                </article></li>
              {/foreach}
            </ol>
            <a class="spup-text-link" href="{url page="announcement"}">{translate key="plugins.themes.spupLightExplorerTheme.root.allAnnouncements"} <span aria-hidden="true">&rarr;</span></a>
          </aside>
        {/if}
      </div>
    </section>
    {/if}
  </div>
</main>
{include file="frontend/components/footer.tpl"}
