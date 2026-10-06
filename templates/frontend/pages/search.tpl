{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Compose OJS search form, results and native pagination.
 *}

{if $currentContext}
  {assign var="spupSearchScopeKey" value="plugins.themes.spupLightExplorerTheme.search.thisJournal"}
  {capture assign="spupSearchUrl"}{url router=$smarty.const.ROUTE_PAGE journal=$currentContext->getPath() page="search" op="search" escape=false}{/capture}
{else}
  {assign var="spupSearchScopeKey" value="plugins.themes.spupLightExplorerTheme.search.allJournals"}
  {assign var="spupSearchTitleKey" value="plugins.themes.spupLightExplorerTheme.root.searchTitle"}
  {capture assign="spupSearchUrl"}{url router=$smarty.const.ROUTE_PAGE page="search" op="search" escape=false}{/capture}
{/if}
{assign var=formUrlParameters value=$activeTheme->getSearchFormParameters($spupSearchUrl)}
{include file="frontend/components/header.tpl" pageTitle=$spupSearchTitleKey|default:$spupSearchScopeKey}

<main class="page page_search">
  <section class="container-fluid container-page">
    {include file="frontend/components/spup/layout/breadcrumbs.tpl" items=[] currentTitleKey=$spupSearchTitleKey|default:$spupSearchScopeKey}
    {if !$currentContext}
      {include file="frontend/components/spup/layout/pageIntro.tpl" titleKey=$spupSearchTitleKey}
    {else}
      {include file="frontend/components/headings.tpl" currentTitleKey=$spupSearchScopeKey}
      <p class="spup-search-scope">{$currentContext->getLocalizedName()|escape}</p>
    {/if}

    {include file="frontend/components/spup/search/form.tpl" actionUrl=$spupSearchUrl urlParameters=$formUrlParameters}

    {if !$results->wasEmpty()}
      {if !$currentContext}<p class="spup-search-count">{page_info iterator=$results}</p>{/if}
      <div id="results" class="search_results">
        {iterate from=results item=result}
          {include file="frontend/components/spup/search/resultRow.tpl" result=$result}
        {/iterate}
      </div>
    {/if}

    {if $results->wasEmpty()}
      {if !$currentContext && !$error}<div class="spup-empty-state"><h2>{translate key="plugins.themes.spupLightExplorerTheme.root.noSearchResults"}</h2><p>{translate key="plugins.themes.spupLightExplorerTheme.root.searchEmptyHelp"} <a href="{url page="journals"}">{translate key="plugins.themes.spupLightExplorerTheme.root.exploreJournals"}</a></p></div>{/if}
      {if $currentContext || $error}
        <div class="row"><div class="search-notifications col-sm-10 offset-sm-1 col-md-8 offset-md-2">
          {if $error}
            {include file="frontend/components/notification.tpl" type="error" message=$error|escape}
          {else}
            {include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"}
          {/if}
        </div></div>
      {/if}
    {else}
      <div class="cmp_pagination">
        <div class="search-pagination-results"><span>{page_info iterator=$results}</span></div>
        <div class="search-pagination-numbers">
          {page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors title=$title abstract=$abstract galleyFullText=$galleyFullText discipline=$discipline subject=$subject type=$type coverage=$coverage indexTerms=$indexTerms dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear orderBy=$orderBy orderDir=$orderDir}
        </div>
      </div>
    {/if}
  </section>
</main>

{include file="frontend/components/footer.tpl"}
