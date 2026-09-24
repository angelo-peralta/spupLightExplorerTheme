{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to search and view search results.
 *
 * @uses $query Value of the primary search query
 * @uses $authors Value of the authors search filter
 * @uses $dateFrom Value of the date from search filter (published after).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $dateTo Value of the date to search filter (published before).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $yearStart Earliest year that can be used in from/to filters
 * @uses $yearEnd Latest year that can be used in from/to filters
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

		{if !$currentContext}
			{include file="frontend/components/rootBreadcrumbs.tpl" currentTitleKey=$spupSearchTitleKey}
			<h1 class="page_title">{translate key=$spupSearchTitleKey}</h1>
		{else}
			{include file="frontend/components/headings.tpl" currentTitleKey=$spupSearchScopeKey}
		{/if}
		{if $currentContext}
			<p class="spup-search-scope">{$currentContext->getLocalizedName()|escape}</p>
		{/if}

		<div class="row">
			<form class="cmp_form col-sm-10 offset-sm-1 col-md-8 offset-md-2" role="search" method="get" action="{$spupSearchUrl|strtok:"?"|escape}">
				{foreach from=$formUrlParameters key=paramKey item=paramValue}
					{if $paramKey != 'query' && $paramKey != 'searchJournal'}
						<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">
					{/if}
				{/foreach}

				{* Repeat the label text just so that screen readers have a clear
				   label/input relationship *}
				<div class="form-row">
					<div class="form-group col-sm-12">
						<label class="pkp_screen_reader" for="query">
							{translate key="search.searchFor"}
						</label>
						<input type="search" id="query" name="query" value="{$query|escape}" class="query form-control" placeholder="{translate|escape key="common.search"}">
					</div>
				</div>

				<fieldset class="search_advanced">
					<legend class="search-advanced-legend">
						{translate key="search.advancedFilters"}
					</legend>

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


				<div class="submit buttons">
					<button class="submit btn btn-primary" type="submit">{translate key="common.search"}</button>
				</div>
			</form>
		</div>

		{* Search results, finally! *}
		{if !$results->wasEmpty()}
			{if !$currentContext}<p class="spup-search-count">{page_info iterator=$results}</p>{/if}

			<div id="results" class="search_results">
				{iterate from=results item=result}
					<div class="spup-search-result">
						{if !$currentContext}
							{assign var=spupResultPublication value=$result.publishedSubmission->getCurrentPublication()}
							<p class="spup-search-result-type">{translate key="plugins.themes.spupLightExplorerTheme.root.researchArticle"}</p>
							<h2><a href="{url journal=$result.journal->getPath() page="article" op="view" path=$result.publishedSubmission->getBestId()}">{$spupResultPublication->getLocalizedFullTitle(null, 'text')|escape}</a></h2>
							<p class="spup-search-result-journal">{$result.journal->getLocalizedName()|escape}</p>
							{assign var=spupResultAuthors value=$activeTheme->getPublicationAuthors($spupResultPublication)}
							{if $spupResultAuthors}<p class="spup-search-result-authors">{$spupResultAuthors|escape}</p>{/if}
							{if $spupResultPublication->getData('datePublished')}<time datetime="{$spupResultPublication->getData('datePublished')|date_format:'Y-m-d'|escape}">{$spupResultPublication->getData('datePublished')|date_format:$dateFormatShort}</time>{/if}
							{if $spupResultPublication->getLocalizedData('abstract')}<div class="spup-search-result-abstract">{$spupResultPublication->getLocalizedData('abstract')|strip_unsafe_html}</div>{/if}
							<a class="spup-text-link" href="{url journal=$result.journal->getPath() page="article" op="view" path=$result.publishedSubmission->getBestId()}">{translate key="plugins.themes.spupLightExplorerTheme.root.readArticle"} <span aria-hidden="true">&rarr;</span></a>
						{else}
							{include file="frontend/objects/article_summary.tpl" headingLevel="2" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true}
						{/if}
					</div>
				{/iterate}
			</div>
		{/if}

		{* No results found *}
		{if $results->wasEmpty()}
			{if !$currentContext && !$error}<div class="spup-empty-state"><h2>{translate key="plugins.themes.spupLightExplorerTheme.root.noSearchResults"}</h2><p>{translate key="plugins.themes.spupLightExplorerTheme.root.searchEmptyHelp"} <a href="{url page="journals"}">{translate key="plugins.themes.spupLightExplorerTheme.root.exploreJournals"}</a></p></div>{/if}
			{if $currentContext || $error}
			<div class="row">
				<div class="search-notifications col-sm-10 offset-sm-1 col-md-8 offset-md-2">
					{if $error}
						{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
					{else}
						{include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"}
					{/if}
				</div>
			</div>
			{/if}

		{* Results pagination *}
		{else}
			<div class="cmp_pagination">
				<div class="search-pagination-results">
					<span>{page_info iterator=$results}</span>
				</div>
				<div class="search-pagination-numbers">
					{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors title=$title abstract=$abstract galleyFullText=$galleyFullText discipline=$discipline subject=$subject type=$type coverage=$coverage indexTerms=$indexTerms dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear orderBy=$orderBy orderDir=$orderDir}
				</div>
			</div>
		{/if}

	</section>
</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
