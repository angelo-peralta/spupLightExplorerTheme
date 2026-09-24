{include file="frontend/components/header.tpl" spupSiteHeroHeading=true}
<main class="page_index_site">
  <section class="spup-site-hero" aria-labelledby="spup-site-hero-title">
    <div class="spup-site-container spup-site-hero__inner">
      <p class="spup-site-hero__institution">St. Paul University Philippines</p>
      <h1 id="spup-site-hero-title" class="spup-site-hero__title">{if $siteTitle}{$siteTitle|escape}{else}The Light Explorer{/if}</h1>
      <p class="spup-site-hero__subtitle">Journal Network</p>
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
      <dl class="spup-network-stats" aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.root.networkStatistics"}">
        <div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.journals"}</dt><dd>{$spupNetworkStats.journals|escape}</dd></div>
        <div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.articles"}</dt><dd>{$spupNetworkStats.articles|escape}</dd></div>
        <div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.issues"}</dt><dd>{$spupNetworkStats.issues|escape}</dd></div>
      </dl>
    </div>
  </section>
  <div class="spup-site-container spup-site-content">
    <section id="journals" class="index-site-journals" aria-labelledby="spup-journals-heading">
      <p class="spup-section-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.root.discover"}</p>
      <h2 id="spup-journals-heading">{translate key="plugins.themes.spupLightExplorerTheme.root.exploreJournals"}</h2>
      <div class="spup-section-rule" aria-hidden="true"></div>
      {if !$journals|@count}
        <p class="spup-empty-state">{translate key="site.noJournals"}</p>
      {else}
        <div class="spup-journal-grid">
          {foreach from=$journals item=journal}
            {capture assign="journalUrl"}{url journal=$journal->getPath()}{/capture}
            {assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
            {assign var="descriptionPreview" value=$activeTheme->getJournalDescriptionPreview($journal->getLocalizedDescription())}
            {assign var="abbreviation" value=$journal->getLocalizedData('abbreviation')}
            <article class="spup-journal-cover{if !$thumb} spup-journal-cover--missing{/if}">
              <a class="spup-journal-cover__link" href="{$journalUrl|escape}" aria-labelledby="spup-journal-title-{$journal->getId()|escape}">
                <figure class="spup-journal-cover__figure">
                  <div class="spup-journal-cover__media">
                    {if $thumb}
                      <img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}" alt="" loading="lazy" decoding="async">
                    {else}
                      <div class="spup-journal-cover__fallback" aria-hidden="true">{if $abbreviation}<span>{$abbreviation|escape}</span>{/if}<strong>{$journal->getLocalizedName()|escape}</strong></div>
                    {/if}
                  </div>
                  <figcaption class="spup-journal-cover__overlay">
                    {if $abbreviation}<span class="spup-journal-cover__abbreviation">{$abbreviation|escape}</span>{/if}
                    <h3 id="spup-journal-title-{$journal->getId()|escape}">{$journal->getLocalizedName()|escape}</h3>
                    {if $descriptionPreview}<p class="spup-journal-cover__description">{$descriptionPreview|escape}</p>{/if}
                    <span class="spup-journal-cover__action">{translate key="plugins.themes.spupLightExplorerTheme.directory.openJournal"} <span aria-hidden="true">&rarr;</span></span>
                  </figcaption>
                </figure>
              </a>
            </article>
          {/foreach}
        </div>
      {/if}
    </section>
    <section class="spup-latest" aria-labelledby="spup-latest-heading">
      <p class="spup-section-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.root.publishing"}</p>
      <h2 id="spup-latest-heading">{translate key="plugins.themes.spupLightExplorerTheme.root.latestScholarship"}</h2>
      <div class="spup-section-rule" aria-hidden="true"></div>
      <div class="spup-latest__columns{if !$spupNetworkAnnouncements|@count} spup-latest__columns--single{/if}">
        <div class="spup-latest__publications">
          <h3>{translate key="plugins.themes.spupLightExplorerTheme.root.recentPublications"}</h3>
          {if $spupRecentPublications|@count}
            <ol class="spup-editorial-list">
              {foreach from=$spupRecentPublications item=recent}
                <li><article>
                  <h4><a href="{url journal=$recent.journal->getPath() page="article" op="view" path=$recent.submission->getBestId()}">{$recent.publication->getLocalizedFullTitle(null, 'text')|escape}</a></h4>
                  <p class="spup-editorial-list__meta">{$recent.journal->getLocalizedName()|escape}{if $recent.authors} &middot; {$recent.authors|escape}{/if}{if $recent.datePublished} &middot; <time datetime="{$recent.datePublished|date_format:'Y-m-d'|escape}">{$recent.datePublished|date_format:$dateFormatShort}</time>{/if}</p>
                </article></li>
              {/foreach}
            </ol>
          {else}<p class="spup-empty-state">{translate key="plugins.themes.spupLightExplorerTheme.root.noPublications"}</p>{/if}
        </div>
        {if $spupNetworkAnnouncements|@count}
          <aside class="spup-latest__announcements" aria-labelledby="spup-latest-announcements-heading">
            <h3 id="spup-latest-announcements-heading">{translate key="announcement.announcements"}</h3>
            <ol class="spup-editorial-list">
              {foreach from=$spupNetworkAnnouncements item=announcement}
                <li><article>
                  <time datetime="{$announcement->datePosted|date_format:'Y-m-d'|escape}">{$announcement->datePosted|date_format:$dateFormatShort}</time>
                  <h4><a href="{url page="announcement" op="view" path=$announcement->id}">{$announcement->getLocalizedData('title')|escape}</a></h4>
                </article></li>
              {/foreach}
            </ol>
            <a class="spup-text-link" href="{url page="announcement"}">{translate key="plugins.themes.spupLightExplorerTheme.root.allAnnouncements"} <span aria-hidden="true">&rarr;</span></a>
          </aside>
        {/if}
      </div>
    </section>
  </div>
</main>
{include file="frontend/components/footer.tpl"}
