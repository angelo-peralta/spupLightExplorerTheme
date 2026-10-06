{**
 * Search presentation using native OJS query and filter variables.
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *}
<div class="row">
  <form class="cmp_form col-sm-10 offset-sm-1 col-md-8 offset-md-2" role="search" method="get" action="{$actionUrl|strtok:"?"|escape}">
    {foreach from=$urlParameters key=paramKey item=paramValue}
      {if $paramKey != 'query' && $paramKey != 'searchJournal'}
        <input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">
      {/if}
    {/foreach}
    <div class="spup-search-bar">
      <div class="form-group">
        <label class="pkp_screen_reader" for="query">{translate key="search.searchFor"}</label>
        <input type="search" id="query" name="query" value="{$query|escape}" class="query form-control" placeholder="{translate|escape key="common.search"}">
      </div>
      <button class="submit btn btn-primary spup-search-submit" type="submit">{translate key="common.search"}</button>
    </div>
    <details class="spup-search-disclosure"{if $authors || (!$currentContext && $searchJournal) || $dateFromYear || $dateFromMonth || $dateFromDay || $dateToYear || $dateToMonth || $dateToDay} open{/if}>
      <summary>{translate key="search.advancedFilters"}</summary>
      <fieldset class="search_advanced">
        <legend class="pkp_screen_reader">{translate key="search.advancedFilters"}</legend>
        <div class="spup-search-date-range">
          <div>
            {capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
            {html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
          </div>
          <div>
            {capture assign="dateToLegend"}{translate key="search.dateTo"}{/capture}
            {html_select_date_a11y legend=$dateToLegend prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
          </div>
        </div>
        <div class="filter-authors">
          <label for="authors">{translate key="search.author"}</label>
          <input id="authors" type="text" class="form-control" name="authors" value="{$authors|escape}">
        </div>
        {if !$currentContext && $searchableContexts}
          <div class="spup-search-journal-filter">
            <label for="searchJournal">{translate key="search.journal"}</label>
            <select id="searchJournal" name="searchJournal" class="form-control">
              <option value="">{translate key="plugins.themes.spupLightExplorerTheme.search.allJournalsOption"}</option>
              {foreach from=$searchableContexts item=searchableContext}
                <option value="{$searchableContext->id|escape}"{if $searchJournal == $searchableContext->id} selected{/if}>{$searchableContext->name|escape}</option>
              {/foreach}
            </select>
          </div>
        {/if}
      </fieldset>
    </details>
  </form>
</div>
