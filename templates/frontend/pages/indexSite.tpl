{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Template for site-wide index page
 *
 *}
{include file="frontend/components/header.tpl" spupSiteHeroHeading=true}

<main class="page_index_site">
	<section class="spup-site-hero" aria-labelledby="spup-site-hero-title">
		<div class="spup-site-container spup-site-hero__inner">
			<p class="spup-site-hero__institution">St. Paul University Philippines</p>
			<h1 id="spup-site-hero-title" class="spup-site-hero__title">
				{if $siteTitle}{$siteTitle|escape}{else}The Light Explorer{/if}
			</h1>
			<p class="spup-site-hero__subtitle">Journal Network</p>
			<div class="spup-site-hero__divider" aria-hidden="true"></div>

			{capture assign="spupSearchUrl"}{url page="search" op="search" router=$smarty.const.ROUTE_PAGE escape=false}{/capture}
			{assign var=spupSearchUrlParameters value=$activeTheme->getSearchFormParameters($spupSearchUrl)}
			<form class="spup-site-hero__search" method="get" action="{$spupSearchUrl|strtok:"?"|escape}" role="search">
				{foreach from=$spupSearchUrlParameters key=paramKey item=paramValue}
					<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">
				{/foreach}
				<label class="spup-site-hero__search-label" for="spup-site-search-query">{translate key="plugins.themes.spupLightExplorerTheme.hero.searchLabel"}</label>
				<div class="spup-site-hero__search-controls">
					<input id="spup-site-search-query" type="search" name="query" placeholder="{translate|escape key="plugins.themes.spupLightExplorerTheme.hero.searchLabel"}" required>
					<button type="submit">{translate key="common.search"}</button>
				</div>
			</form>

			{if $journals|@count}
				<p class="spup-site-hero__meta">
					{$journals|@count} {if $journals|@count == 1}{translate key="context.context"}{else}{translate key="context.contexts"}{/if}
				</p>
			{/if}
		</div>
	</section>

	<div class="spup-site-container spup-site-content">

		{if $about}
			<div class="about_site">
				{$about|nl2br}
			</div>
		{/if}

		<div class="index-site-journals">
			<h2>
				{translate key="context.contexts"}
			</h2>
			{if !$journals|@count}
				{translate key="site.noJournals"}
			{else}
				<div>
					{foreach from=$journals item=journal}
						{capture assign="url"}{url journal=$journal->getPath()}{/capture}
						{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
						{assign var="description" value=$journal->getLocalizedDescription()}
						<div class="index-site-journal">
							<div class="index-site-journal-header">
								<h3>
									<a href="{$url|escape}" rel="bookmark">
										{$journal->getLocalizedName()}
									</a>
								</h3>
							</div>

							{if $thumb}
								<div class="index-site-journal-thumb">
									<a href="{$url|escape}">
										<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape|default:''}"{/if}>
									</a>
								</div>
							{/if}

							{if $description}
								<div class="index-site-journal-description{if !$thumb} full-width{/if}">
									{$description|nl2br}
								</div>
							{/if}

							<div class="index-site-journal-links">
								<a class="btn btn-primary view" href="{$url|escape}">
									{translate key="site.journalView"}
								</a>
								<a class="btn btn-secondary view" href="{url|escape journal=$journal->getPath() page="issue" op="current"}">
									{translate key="site.journalCurrent"}
								</a>
							</div>
						</div>
					{/foreach}
				</div>
			{/if}
		</div>
	</div>

</main><!-- .page_index_site -->

{include file="frontend/components/footer.tpl"}
