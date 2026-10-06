<section class="spup-site-hero spup-site-hero-image" aria-labelledby="spup-site-hero-title">
  <div class="spup-site-hero-bg" aria-hidden="true"
    style="--spup-site-hero-desktop-image: url('{$baseUrl|escape}/plugins/themes/spupLightExplorerTheme/resources/hero-image-desktop.png'); --spup-site-hero-mobile-image: url('{$baseUrl|escape}/plugins/themes/spupLightExplorerTheme/resources/hero-image-mobile.png');"></div>
  <div class="spup-site-container spup-site-hero__inner">
    <p class="spup-site-hero__institution">St. Paul University Philippines</p>
    <h1 id="spup-site-hero-title" class="spup-site-hero__title">{$siteTitle|escape}</h1>
    <p class="spup-site-hero__subtitle">{$rootOptions.networkSubtitle|escape}</p>
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
    {if $rootOptions.showNetworkStats}{include file="frontend/components/spup/root/rootNetworkStats.tpl"}{/if}
  </div>
</section>
